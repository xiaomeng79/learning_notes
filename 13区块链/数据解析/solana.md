# solana

## 确定 programId 对应的程序类型​


## 解析数据的步骤
- 连接到Solana的RPC节点。
- 获取指定slot的区块信息。
- 遍历每个交易，解析其中的指令。
  - 处理系统转账（SOL）和代币转账（USDT）。系统转账的指令类型是2，而代币转账的指令类型是3或12（TransferChecked）。
  - 找到与USDT相关的转账操作。这需要识别SPL代币程序的Transfer指令，并验证代币的Mint地址是否为USDT的官方地址。

## 注意点
- 在解析交易时，需通过 Program ID 区分是系统转账（SOL）还是代币转账（SPL）。
- SOL 的精度为 9 位小数（1 SOL = 10^9 Lamports），而 SPL 代币的精度由合约定义（如 USDT 为 6 位）。
- 处理 SPL 代币转账时，需检查接收方的代币账户是否存在，若不存在需先创建关联账户。


## 解析代码
```go
// main.go
package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"time"

	"github.com/gagliardetto/solana-go"
	"github.com/gagliardetto/solana-go/programs/token"
	"github.com/gagliardetto/solana-go/rpc"
	_ "github.com/go-sql-driver/mysql"
)

// Solana USDT代币合约地址（主网）
const USDT_MINT_ADDRESS = "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB"

// MySQL数据库连接配置
const (
	DB_USER     = "root"
	DB_PASSWORD = "password"
	DB_HOST     = "localhost"
	DB_PORT     = 3306
	DB_NAME     = "solana_analytics"
)

// 数据库表结构
/*
CREATE TABLE transactions (
    tx_hash VARCHAR(88) PRIMARY KEY,
    slot BIGINT,
    fee BIGINT,
    timestamp DATETIME,
    is_success BOOLEAN
);

CREATE TABLE token_transfers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tx_hash VARCHAR(88),
    mint VARCHAR(44),
    from_address VARCHAR(44),
    to_address VARCHAR(44),
    amount BIGINT,
    decimals TINYINT,
    FOREIGN KEY (tx_hash) REFERENCES transactions(tx_hash)
);
*/

func main() {
	// 初始化MySQL数据库连接
	db, err := sql.Open("mysql", fmt.Sprintf("%s:%s@tcp(%s:%d)/%s", 
		DB_USER, DB_PASSWORD, DB_HOST, DB_PORT, DB_NAME))
	if err != nil {
		log.Fatal("数据库连接失败:", err)
	}
	defer db.Close()

	// 初始化Solana客户端
	client := rpc.New(rpc.MainNet_RPC)

	// 指定要解析的slot号
	targetSlot := uint64(100)

	// 1. 获取指定slot的区块信息
	block, err := client.GetBlockWithOpts(context.Background(), targetSlot, 
		&rpc.GetBlockOpts{
			Encoding:   solana.EncodingBase64,
			Commitment: rpc.CommitmentConfirmed,
		})
	if err != nil {
		log.Fatal("获取区块失败:", err)
	}

	// 2. 遍历区块中的所有交易
	for txIndex, tx := range block.Transactions {
		fmt.Printf("\n处理交易 %d/%d\n", txIndex+1, len(block.Transactions))

		// 基础交易信息
		txHash := tx.Transaction.Signatures[0].String()
		txMeta := tx.Meta
		txMsg := tx.Transaction.Transaction.Message

		// 3. 写入交易基础数据
		_, err = db.Exec(`INSERT INTO transactions 
			(tx_hash, slot, fee, timestamp, is_success) 
			VALUES (?, ?, ?, ?, ?) 
			ON DUPLICATE KEY UPDATE slot=VALUES(slot)`,
			txHash,
			targetSlot,
			txMeta.Fee,
			block.BlockTime.Time().UTC(),
			txMeta.Err == nil,
		)
		if err != nil {
			log.Printf("写入交易记录失败: %v", err)
			continue
		}

		// 4. 解析交易中的指令
		for _, instr := range txMsg.Instructions {
			programID := txMsg.Accounts[instr.ProgramIDIndex]

			// 只处理代币转账指令
			if programID != token.ProgramID {
				continue
			}

			// 5. 解析SPL代币指令
			data := instr.Data
			if len(data) < 1 {
				continue
			}

			// 检查指令类型是否为转账
			switch data[0] {
			case 3: // Transfer指令
				handleTransferInstruction(db, txHash, txMsg, instr)
			case 12: // TransferChecked指令（包含精度验证）
				handleTransferCheckedInstruction(db, txHash, txMsg, instr, data)
			}
		}
	}
}

// 处理普通转账指令（Transfer）
func handleTransferInstruction(db *sql.DB, txHash string, 
	txMsg solana.Message, instr solana.CompiledInstruction) {

	// 解析转账参数
	accounts := instr.Accounts
	if len(accounts) < 3 {
		return
	}

	// 获取相关账户地址
	mintAccount := txMsg.Accounts[accounts[0]].String()
	sourceAccount := txMsg.Accounts[accounts[1]].String()
	destAccount := txMsg.Accounts[accounts[2]].String()

	// 只处理USDT转账
	if mintAccount != USDT_MINT_ADDRESS {
		return
	}

	// 解析转账金额（8字节大端序）
	amount := solana.Uint64FromBytes(instr.Data[1:9]).Uint64()

	// 插入代币转账记录
	_, err := db.Exec(`INSERT INTO token_transfers 
		(tx_hash, mint, from_address, to_address, amount, decimals)
		VALUES (?, ?, ?, ?, ?, ?)`,
		txHash,
		USDT_MINT_ADDRESS,
		sourceAccount,
		destAccount,
		amount,
		6, // USDT固定6位小数
	)
	if err != nil {
		log.Printf("写入代币转账失败: %v", err)
	}
}

// 处理带精度验证的转账指令（TransferChecked）
func handleTransferCheckedInstruction(db *sql.DB, txHash string, 
	txMsg solana.Message, instr solana.CompiledInstruction, data []byte) {

	// 解析账户索引
	accounts := instr.Accounts
	if len(accounts) < 4 {
		return
	}

	// 获取相关账户地址
	mintAccount := txMsg.Accounts[accounts[0]].String()
	sourceAccount := txMsg.Accounts[accounts[1]].String()
	destAccount := txMsg.Accounts[accounts[2]].String()

	// 只处理USDT转账
	if mintAccount != USDT_MINT_ADDRESS {
		return
	}

	// 解析金额和精度
	amount := solana.Uint64FromBytes(data[1:9]).Uint64()
	decimals := data[9]

	// 插入代币转账记录
	_, err := db.Exec(`INSERT INTO token_transfers 
		(tx_hash, mint, from_address, to_address, amount, decimals)
		VALUES (?, ?, ?, ?, ?, ?)`,
		txHash,
		USDT_MINT_ADDRESS,
		sourceAccount,
		destAccount,
		amount,
		decimals,
	)
	if err != nil {
		log.Printf("写入代币转账失败: %v", err)
	}
}

```

