# ETH

## 账户
- 外部账户：即普通用户用私钥控制的账户.
- 合约账户：一种拥有合约代码的账户，它不属于任何人，也没有私钥与之对应。

## 账户结构
- 以太坊存储账户数据的数据结构是MPT：Merkle Patricia Tree，它是一种改进的Merkle Tree。当MPT的每个叶子结点的值确定后，计算出的Root Hash就是完全确定的。
- 以太坊就是一个状态机，每个区块通过记录一个stateRoot来表示一个新状态。如果给定某个区块的stateRoot，我们肯定能完全确定所有账户的所有余额等信息。因此，stateRoot就被称为当前的世界状态。
- 每个节点的数据被存放到LevelDB中，节点仅在内存中存储当前活动的一些账户信息。如果需要操作某个不在内存的账户，则会将其从LevelDB加载到内存。如果内存不够，也会将长期不活动的节点从内存中移除，因为将来可以通过节点的路径再次从LevelDB加载。

## 账户数据
一个以太坊账户由4部分数据构成：
- nonce：是一个递增的整数，每发送一次交易，+1，记录的就是交易次数。
- balance：记录的就是账户余额，以wei为单位，1 Ether等于1018wei。
- storageRoot：如果一个账户是合约账户，则storageRoot存储合约相关的状态数据。
- codeHash：存储合约代码的Hash。对于外部账户，这两部分数据都是空。

## 结构
```go
parentHash（上一个区块的Hash）;
stateRoot（世界状态）;
sha3Uncles：记录引用的叔块,叔块的目的是给予竞争失败的矿工部分奖励，避免出现较长的分叉。；
transactionRoot：记录当前区块所有交易的Root Hash；
receiptsRoot：记录当前区块所有交易回执的Root Hash；
logsBloom：一个Bloom Filter，用于快速查找Log；
difficulty：挖矿难度值；
number：区块高度，严格递增的整数；
timestamp：区块的时间戳（以秒为单位）；
```

### 账户生成方式
- ECDSA算法生成私钥
- keccak256哈希计算公钥
- 十六进制编码
secp256k1椭圆曲线，但和比特币不同的是，以太坊采用非压缩公钥，然后直接对公钥做keccak256哈希，得到32字节的哈希值，取后20字节加上0x前缀即为地址，可以通过大小写字母实现地址的校验。


## 概念
- 智能合约: （Smart Contracts）智能合约是一段存储在以太坊区块链上的代码，它可以自动执行协议的条款。例如，你可以创建一个智能合约来管理众筹活动，当筹款达到目标时，合约会自动将资金转给项目方。
- 以太币 (ETH): 以太坊的原生货币称为以太币（Ether，简称 ETH）。ETH 是用于支付以太坊网络上的交易费用和计算服务的代币。用户需要支付 ETH 来执行智能合约和转账。
- 以太坊虚拟机 (EVM):以太坊虚拟机（Ethereum Virtual Machine，EVM）是以太坊的核心组件。EVM 是一个图灵完备的虚拟机，它可以执行用以太坊脚本语言（如 Solidity）编写的任意代码。EVM 使得智能合约的执行变得可能。
- DApps (去中心化应用):（Decentralized Applications，DApps）是基于以太坊区块链和智能合约构建的应用程序。与传统应用不同，DApps 没有中央服务器，数据和应用逻辑是分布式的，这使得它们更加透明和安全。
- 以太坊 2.0:以太坊 2.0 引入了股权证明（Proof of Stake, PoS）共识机制，而不是现有的工作量证明（Proof of Work, PoW）。这将大幅减少能耗并提高交易处理速度。
- ERC 标准:以太坊的技术规范，用于创建代币和其他合约。最著名的是 ERC-20 标准.

## ETH1.0和2.0的区别
- 共识：POW->POS
- 性能:15-30笔/秒->数千甚至数万/秒
- 信标链（Beacon Chain）：ETH2.0的核心链，负责协调分片和验证者活动，确保整个网络的同步和共识。
- 安全性:去中心化和抗攻击性：PoS 机制下，恶意攻击者需要持有大量ETH，成本高昂，使得网络更安全。此外，验证者被随机选择，进一步分散风险。
- 智能合约和DApps：更高的吞吐量和更低的费用。
- 扩展性： 分片技术和信标链的引入显著提高了网络的扩展性和吞吐量。

## Epoch（纪元）, Slot（时隙）, Block 和 Block 状态
ETH2.0 按照 epoch 出块，每一个 epoch 有 32 slot，每一个 slot 可以承载 1 个块。
- Slot（时隙）
  -  是以太坊2.0中最基本的时间单位，每个slot都有一个指定的时间长度。在每个 slot 中，可能会有一个区块被提议并添加到链中。
  -  一个 slot 的长度为 12 秒。
  -  在每个 slot 中，网络中的验证者将有机会提议一个新的区块。这些提议者是通过权益证明（PoS）随机选择的。
-  Epoch（纪元）
   -  在 Eth2.0 中，Epoch 用于管理和组织验证者的活动。
   -  一个 Epoch 由 32 个 slot 组成。
   -  由于一个 slot 是12秒，一个 Epoch 的总长度是 384 秒（即6.4分钟）。
   -  在每个 Epoch 结束时，网络会进行状态和共识的检查和调整，包括对验证者的奖励和惩罚。
-  Block（区块）
   -  Block 是包含交易和其他相关数据的记录单元。
   -  一个区块包含区块头、交易列表、状态根哈希、签名等数据。
   -  在每个 slot 开始时，网络会随机选出一个验证者来提议区块。该验证者将创建一个包含新交易和其他必要信息的区块，并广播到网络中。
-  Safe（安全）
   -  指的是一个区块已经被多数验证者接受和认可，超过了一个特定的阈值，但还没有达到最终确定的标准。
- Finalized（最终确定）
  - 是一个区块已经被永久地添加到区块链中，并且不可能被回滚或替代。这是区块链中最强的确认状态。
  - 通过了严格的共识验证，通常需要超过2/3的验证者投票同意。具体来说，两个连续的epoch被最终确定时，意味着在这两个epoch之间的所有区块都被最终确定。
  - 这种状态防止了分叉和双花攻击的可能性。
  - 2个Epoch前的块会进入这个状态。

## 注意请求响应参数
- eth_blockNumber：获取最新块高
  - inalized：返回已经确定的块
  - safe: 返回安全的块
  - atest: 反回最新块
- eth_getBlockByNumber:获取这个区块的信息
  - false: 只返回交易 Hash, 不反回交易体; true 两者都返回，实际工作中用 false
- eth_getTransactionByHash:根据交易 Hash 获取交易详情
  - 根据返回信息里面的from和to地址来判断是充值还是体现。
- eth_getTransactionReceipt:获取交易状态
  - 返回参数：status 为 1 成功，status 为 0 失败。
- eth_getTransactionCount:获取签名需要的参数 Nonce
  - 返回参数:result 值即为签名里面需要的 nonce 值
- eth_gasPrice:获取签名需要的参数 Gas
  - 返回值即为签名里面需要的 gasPrice
- eth_sendRawTransaction:发送交易到区块链网络
  - 返回值为交易 Hash

## Gas（汽油）
- [gas追踪](https://etherscan.io/gastracker)
- [ethgasstation](https://ethgasstation.info/)
- 为了保证合约代码的可靠执行(不要永远执行)，以太坊给每一个虚拟机指令都标记了一个Gas基本费用，称为gasUsed。
- 消耗CPU比消耗存储便宜，简单计算比复杂计算便宜，读取比写入便宜。
- 因为有if等判断逻辑，不能准确预估gas费，一笔交易，先给出gasPrice和gasLimit，如果执行完成后有剩余，剩余的退还，如果执行过程中消耗殆尽，那么交易执行失败，但已执行的Gas不会退。
- Gas Limit: 在创建这个交易时，允许交易消耗的最大的gas数值，如果交易在实际执行中，所消耗的gas大于了这个值，则交易直接失败，不生效，但是手续费还是需要扣除。单纯的eth转账交易，gas消耗固定为21000。
- Gas Used by Transaction: 交易中真实使用的gas值。在合约中，成功的交易大部分这个数值会小于Gas Limit。
- 
- Gas Price是全网用户竞价产生的，它时刻在波动。如果交易少，Gas Price将下降，如果交易多，网络拥堵，则Gas Price将上升。以太坊的Gas价格可以在Etherscan跟踪。

## 转账交易
- Transaction Hash: 0xb940...4ad7，这是交易Hash，即交易的唯一标识；
- Status: Success，表示交易成功；
- From: 0x0FFf...bBc4，交易的发送方；
- To: 0x5b2a...5a46，交易的接收方；
- Value: 1.6912 Ether，交易发送的Ether；
- Gas Price: 82 Gwei，Gas的价格；
- Gas Limit: 21,000，转账交易恰好消耗21000Gas，因此总是21000；
- Usage by Txn: 21,000 (100%)，消耗的Gas占比，这里恰好全部消耗完；
- Nonce：0，发送方的nonce，0表示第1笔交易,可避免重放攻击；
- Input Data: 0x，因为是转账交易，没有输入数据，因此为空。

## 合约交易
是指一个外部账号调用某个合约的某个public函数
- From: 0x2329...BA3a，交易的发起方，该地址一定是外部账户；
- To: 0x7a25...488D，交易的接收方，这里地址是一个合约地址；
- Value: 4.5 Ether，即向合约发送4.5 Ether；
- Gas Limit: 152,533，这是交易发起前设定的最大Gas；
- Usage by Txn: 125,290 (82.14%)，这是交易实际消耗的Gas；
- Input Data: 0x7ff36ab5...，这是交易的输入数据，其中包含了调用哪个函数，以及传递的参数，解码后可知调用函数是swapExactETHForTokens。


## 交易所提币流程
- 获取热钱包地址和热钱包私钥
- 获取热钱包余额
- 获取gasPrice
- 获取待处理提币条目
  - 判断热钱包余额是否足够提币
  - 获取热钱包nonce
  - 创建提币交易
  - 将创建的交易插入待发送队列
  - 更改提币条目状态为已生成提币交易

## **2. 以太坊区块的组成**
每个以太坊区块由 **区块头（Block Header）、区块体（Block Body）** 组成。

### **📌 以太坊区块结构**
| **字段** | **描述** |
|---------|---------|
| **区块头（Block Header）** | 存储区块的元数据 |
| **区块号（Block Number）** | 区块的高度 |
| **父区块哈希（Parent Hash）** | 上一个区块的哈希值 |
| **状态根（State Root）** | 交易执行后的全局状态 |
| **交易默克尔根（Transactions Root）** | 交易列表的 Merkle 树根 |
| **收据默克尔根（Receipts Root）** | 交易收据的 Merkle 树根 |
| **Gas 限制（Gas Limit）** | 该区块可消耗的最大 Gas |
| **Gas 使用量（Gas Used）** | 该区块实际消耗的 Gas |
| **时间戳（Timestamp）** | 该区块生成的时间 |
| **区块体（Block Body）** | 存储交易数据 |
| **交易列表（Transactions）** | 该区块包含的所有交易 |
| **叔块列表（Ommers）** | PoW 时代包含的孤块 |

---

## **3. 以太坊区块链数据结构**
### **📌 以太坊区块链由以下 3 棵默克尔树组成**
1️⃣ **账户状态树（State Trie）**：存储账户余额、Nonce、智能合约状态  
2️⃣ **交易树（Transactions Trie）**：存储区块中的交易数据  
3️⃣ **收据树（Receipts Trie）**：存储每笔交易的执行结果  

✅ **采用 Patricia Merkle Trie（Patricia 默克尔前缀树）**  
✅ **高效支持状态存储和查询**  

---

## **4. 以太坊区块生成流程**
1️⃣ **交易广播**：用户发起交易，交易被广播到网络  
2️⃣ **验证交易**：节点检查交易的合法性（签名、余额、Gas 限制）  
3️⃣ **共识机制**：
   - **PoW 时代（以前）**：矿工进行工作量证明（Ethash 算法）  
   - **PoS 时代（Ethereum 2.0）**：验证者（Validator）负责打包区块  
4️⃣ **交易执行**：虚拟机（EVM）运行交易，更新账户状态  
5️⃣ **存储数据**：状态更新并写入状态树  
6️⃣ **新区块添加到链**：区块被确认后添加到链中  

## **6. 以太坊交易结构**
每个以太坊交易（Transaction）都包含**发送者、接收者、金额、Gas、签名等信息**。

### **📌 交易结构**
| **字段** | **描述** |
|---------|---------|
| **Nonce** | 账户已发出的交易数量 |
| **Gas Price** | 交易的 Gas 价格 |
| **Gas Limit** | 交易可消耗的最大 Gas |
| **To** | 交易接收方地址 |
| **Value** | 发送的 ETH 数量 |
| **Data** | 智能合约调用数据（如合约函数） |
| **签名（Signature）** | 发送者对交易的数字签名 |

✅ **智能合约交易（调用合约）**：`to` 字段指向合约地址  
✅ **普通转账交易**：`to` 字段指向用户地址  



# 📌 以太坊交易票据（Transaction Receipt）详细解析

## **1. 交易票据的作用**
以太坊交易票据（Transaction Receipt）是 **交易执行后的证明**，记录了交易的最终状态，例如：
- 交易是否成功
- 消耗的 Gas 量
- 事件日志（Event Logs）
- 合约创建地址（如果是创建合约的交易）
- 交易影响的状态变更  

每笔交易的票据存储在 **Receipts Trie** 中，是 **可验证的执行结果**。

---

## **2. 交易票据的结构**
### **📌 以太坊票据的关键字段**
| **字段** | **描述** |
|---------|---------|
| **transactionHash** | 交易哈希 |
| **transactionIndex** | 交易在区块中的索引 |
| **blockHash** | 交易所属区块的哈希 |
| **blockNumber** | 交易所属区块的高度 |
| **from** | 交易发送者 |
| **to** | 交易接收者（或 `null`，如果是合约创建） |
| **cumulativeGasUsed** | 区块内所有交易累积的 Gas 消耗 |
| **gasUsed** | 当前交易实际消耗的 Gas |
| **contractAddress** | 如果是合约创建交易，则为新合约地址，否则为 `null` |
| **logs** | 交易执行过程中触发的事件日志 |
| **logsBloom** | 用于快速索引日志的布隆过滤器 |
| **status** | 交易状态：`1` 表示成功，`0` 表示失败 |

---

## **3. 交易票据示例**
可以使用 **Go Ethereum (geth) 的 RPC API** 获取交易票据。  
使用 `eth_getTransactionReceipt` 获取票据信息：

### **📌 示例 JSON 交易票据**
```json
{
  "transactionHash": "0x12345...",
  "transactionIndex": 1,
  "blockHash": "0xabcde...",
  "blockNumber": 12345678,
  "from": "0xSenderAddress...",
  "to": "0xReceiverAddress...",
  "cumulativeGasUsed": 150000,
  "gasUsed": 50000,
  "contractAddress": null,
  "logs": [
    {
      "address": "0xContractAddress...",
      "topics": ["0xddf252ad...", "0xSender...", "0xReceiver..."],
      "data": "0x00000000000000000000000000000000000000000000000000000000000003e8"
    }
  ],
  "logsBloom": "0x...",
  "status": "0x1"
}

```

## 使用 Go 解析以太坊交易票据
```go
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/core/types"
)

func main() {
	// 连接以太坊 RPC 节点
	client, err := ethclient.Dial("https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID")
	if err != nil {
		log.Fatal(err)
	}

	// 交易哈希
	txHash := common.HexToHash("0x交易哈希值...")

	// 获取交易票据
	receipt, err := client.TransactionReceipt(context.Background(), txHash)
	if err != nil {
		log.Fatal(err)
	}

	// 打印交易票据
	printReceipt(receipt)
}

// 打印交易票据信息
func printReceipt(receipt *types.Receipt) {
	jsonData, err := json.MarshalIndent(receipt, "", "  ")
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("交易票据信息：")
	fmt.Println(string(jsonData))

	fmt.Println("\n解析字段：")
	fmt.Println("交易哈希:", receipt.TxHash.Hex())
	fmt.Println("交易状态:", receipt.Status) // 1: 成功, 0: 失败
	fmt.Println("区块高度:", receipt.BlockNumber.Uint64())
	fmt.Println("Gas 消耗:", receipt.GasUsed)

	// 解析事件日志
	for _, log := range receipt.Logs {
		fmt.Println("\n事件日志地址:", log.Address.Hex())
		fmt.Println("日志 Topics:", log.Topics)
		fmt.Println("日志数据:", log.Data)
	}
}

```

##  解析事件日志
```solidity
event Transfer(address indexed from, address indexed to, uint256 value);

function transfer(address to, uint256 value) public {
    emit Transfer(msg.sender, to, value);
}

```
触发 Transfer 事件后，在 logs 里存储：
```json
{
  "address": "0xTokenContractAddress...",
  "topics": [
    "0xddf252ad...",  // Transfer 事件哈希
    "0xSenderAddress...",
    "0xReceiverAddress..."
  ],
  "data": "0x00000000000000000000000000000000000000000000000000000000000003e8"
}

```

## Go 解析日志
```go
for _, log := range receipt.Logs {
	fmt.Println("事件地址:", log.Address.Hex())
	for i, topic := range log.Topics {
		fmt.Printf("Topic %d: %s\n", i, topic.Hex())
	}
	fmt.Println("数据:", log.Data)
}

```

## 票据存储:Receipts Trie 结构
以太坊交易票据存储在 **Receipts Trie** 中，每个区块都维护一棵 **默克尔帕特里夏树（MPT）** 来存储：

### **📌 关键结构**
- `blockHeader.receiptRoot`：存储 **Receipts Trie** 的根哈希
- **优势**：
  - 高效存储
  - 快速验证

### **📌 计算过程**
1. 计算每个交易的 `receiptHash`
2. 组成 **Receipts Trie**
3. 生成 `receiptRoot`，存入 **区块头（Block Header）**



