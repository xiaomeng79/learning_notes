# **StarRocks 存储区块链交易数据 & ERC-20 数据的推荐存储结构**

在 StarRocks 中存储区块链交易数据（Transactions）和 ERC-20 代币交易数据时，需要考虑：  
✅ **高吞吐写入**（处理链上大量交易）  
✅ **高效查询**（查询账户余额、代币持有情况、交易历史等）  
✅ **支持实时分析**（基于最新交易数据进行查询）  
✅ **数据去重 & 合并**（避免重复交易数据）  

---

## **1. 交易数据（Transactions）表结构**
存储区块链上的所有交易记录，包括普通转账、合约调用等。

```sql
CREATE TABLE transactions (
    tx_hash         VARCHAR(66) NOT NULL,  -- 交易哈希，唯一索引
    block_number    BIGINT NOT NULL,      -- 区块号
    block_timestamp DATETIME NOT NULL,    -- 交易时间
    from_address    VARCHAR(42) NOT NULL, -- 发送方
    to_address      VARCHAR(42),          -- 接收方
    value           DECIMAL(38,18),       -- 转账金额（以 ETH 计算）
    gas_price       BIGINT,               -- Gas 价格（Wei）
    gas_used        BIGINT,               -- 实际 Gas 消耗
    status          TINYINT NOT NULL,     -- 交易状态（0:失败, 1:成功）
    method_id       VARCHAR(10),          -- 调用的合约方法 ID
    contract_address VARCHAR(42),         -- 如果是合约创建，则存合约地址
    PRIMARY KEY(tx_hash) -- 交易哈希作为主键
) ENGINE=OLAP 
DUPLICATE KEY(tx_hash) 
DISTRIBUTED BY HASH(tx_hash) BUCKETS 16 
PROPERTIES ("replication_num" = "3");
```
## ✅ 设计特点

- **交易哈希 (`tx_hash`) 作为唯一键**，确保查询唯一性。
- **`DUPLICATE KEY(tx_hash)` 适用于事务数据的去重**，但 StarRocks 4.0+ 也支持 **Primary Key 模型（适用于账户余额等更新场景）**。
- **分布式存储 (`DISTRIBUTED BY HASH(tx_hash)`) 提高查询效率**。

---

## 📌 常见查询
```sql
-- 查询某个地址的所有交易记录
SELECT * FROM transactions WHERE from_address = '0xabc...' OR to_address = '0xabc...' ORDER BY block_number DESC LIMIT 100;

-- 查询某个交易的详细信息
SELECT * FROM transactions WHERE tx_hash = '0x123...';

-- 统计某个时间段的交易量
SELECT DATE(block_timestamp) AS tx_date, COUNT(*) AS tx_count FROM transactions 
WHERE block_timestamp >= '2024-01-01' GROUP BY tx_date ORDER BY tx_date;
```

###  ERC-20 代币交易表
ERC-20 代币交易涉及 from_address 转账 value 到 to_address，通常通过合约调用实现。
```sql
CREATE TABLE erc20_transfers (
    tx_hash         VARCHAR(66) NOT NULL,  -- 交易哈希
    block_number    BIGINT NOT NULL,      -- 区块号
    block_timestamp DATETIME NOT NULL,    -- 交易时间
    contract_address VARCHAR(42) NOT NULL, -- 代币合约地址
    from_address    VARCHAR(42) NOT NULL, -- 发送方
    to_address      VARCHAR(42) NOT NULL, -- 接收方
    value           DECIMAL(38,18) NOT NULL, -- 代币数量
    token_symbol    VARCHAR(20),          -- 代币符号（如 USDT, WETH）
    token_decimals  INT,                  -- 代币小数位数
    PRIMARY KEY(tx_hash, contract_address, from_address, to_address) -- 避免重复
) ENGINE=OLAP 
DUPLICATE KEY(tx_hash, contract_address, from_address, to_address) 
DISTRIBUTED BY HASH(tx_hash) BUCKETS 16 
PROPERTIES ("replication_num" = "3");

```
✅ 设计特点

- 支持多个代币的存储（不同 contract_address）。
- 以 (tx_hash, contract_address, from_address, to_address) 作为去重键，防止重复数据。
- 适用于 ERC-20 代币交易查询，如持仓、转账记录等。

## 📌 常见查询
```sql
-- 查询某个地址的所有 ERC-20 代币转账记录
SELECT * FROM erc20_transfers WHERE from_address = '0xabc...' OR to_address = '0xabc...' ORDER BY block_number DESC LIMIT 100;

-- 查询某个代币的转账情况
SELECT * FROM erc20_transfers WHERE contract_address = '0x123...' ORDER BY block_number DESC LIMIT 100;

-- 统计某个代币的每日交易量
SELECT DATE(block_timestamp) AS tx_date, token_symbol, SUM(value) AS total_volume FROM erc20_transfers 
WHERE contract_address = '0x123...' GROUP BY tx_date, token_symbol ORDER BY tx_date;

```

### 账户余额表（支持主键更新模型）
账户余额需要随交易动态变化，可以使用 StarRocks Primary Key 模型。
```sql
CREATE TABLE erc20_balances (
    address         VARCHAR(42) NOT NULL, -- 账户地址
    contract_address VARCHAR(42) NOT NULL, -- 代币合约地址
    balance         DECIMAL(38,18) NOT NULL, -- 账户余额
    updated_at      DATETIME NOT NULL, -- 最后更新时间
    PRIMARY KEY(address, contract_address) -- 以地址 + 代币合约作为主键
) ENGINE=OLAP 
PRIMARY KEY(address, contract_address) 
DISTRIBUTED BY HASH(address) BUCKETS 16 
PROPERTIES ("replication_num" = "3");
```
✅ 设计特点

- 使用 PRIMARY KEY(address, contract_address)，支持余额更新。
- 适用于查询某个账户的代币持仓情况。

## 
