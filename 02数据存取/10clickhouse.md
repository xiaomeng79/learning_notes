# ClickHouse

## 介绍

- [ClickHouse](https://github.com/ClickHouse/ClickHouse)
- [使用场景](https://zhuanlan.zhihu.com/p/98439924)

# **ClickHouse 原理详细介绍**

ClickHouse 是一个开源的 **列式存储** 数据库管理系统，专为 **实时分析** 设计，具有 **高性能 OLAP（Online Analytical Processing）查询** 能力。它主要用于处理大规模数据的实时分析，如日志数据、金融交易、区块链数据等。

---

## **1️⃣ ClickHouse 体系架构**
ClickHouse 采用 **Shared-Nothing 分布式架构**，每个节点都可以独立运行，并通过分片（Sharding）和副本（Replication）提升可用性和性能。

### **🔹 主要组件**
- **MergeTree 存储引擎**：核心存储引擎，支持数据的列式存储和分区管理，适用于大规模数据处理。
- **SQL 查询优化器**：支持 `ORDER BY`、`GROUP BY`、`bloom_filter` 等优化策略，提升查询效率。
- **分布式计算**：通过 `Distributed` 表实现数据的水平扩展。
- **高效索引机制**：包括 **主键索引（Primary Index）、稀疏索引（Sparse Index）、跳跃索引（Skip Index）**，减少 I/O 读取量。
- **数据压缩**：ClickHouse 使用多种压缩算法（如 LZ4、ZSTD）减少存储占用，提高查询性能。

---

## **2️⃣ ClickHouse 的存储原理**
ClickHouse 采用 **列式存储（Columnar Storage）**，与传统 **行存储（Row-Based Storage）** 不同：
- **列存储**：仅存储查询所需的列，减少 I/O 读取，加速聚合查询。
- **高效压缩**：相同类型的数据存储在一起，压缩率更高。
- **批量处理**：优化 `GROUP BY`、`ORDER BY` 操作，提升计算效率。

### **🔹 MergeTree 存储引擎**
`MergeTree` 是 ClickHouse 最常用的存储引擎，提供 **分区（Partitioning）、索引（Primary Index）、数据合并（Merge）** 等功能。

#### **🌟 MergeTree 关键特性**
| **特性**               | **描述** |
|----------------------|--------|
| **分区（Partitioning）**  | 通过 `PARTITION BY` 定义数据存储分区，提升查询效率 |
| **主键索引（Primary Index）** | 采用稀疏索引，仅存储部分数据，提高查询速度 |
| **数据合并（Merge）**    | 后台自动合并数据文件，提升存储效率 |
| **TTL 过期删除（TTL Expiry）** | 自动清理历史数据，减少存储成本 |

---

## **3️⃣ ClickHouse 的查询优化**
ClickHouse 针对大规模数据查询进行了深度优化：

### **🔹 索引机制**
- **主键索引（Primary Index）**：基于 `ORDER BY` 维护的索引，加速范围查询。
- **跳跃索引（Skip Index）**：跳过不必要的数据块，减少 I/O。
- **bloom_filter**：加速 `WHERE` 过滤条件匹配。

### **🔹 查询优化策略**
| **优化点**          | **描述** |
|------------------|--------|
| **向量化执行**    | 采用 SIMD 指令加速计算 |
| **预计算（Materialized View）** | 通过物化视图存储聚合结果，提高查询性能 |
| **分布式查询（Distributed Query）** | 通过分片加速大规模数据查询 |
| **并行查询（Parallel Query）** | 多核并行处理 SQL，提高执行速度 |

---


### **🔹 ClickHouse vs 其他数据库**
| **对比项**      | **ClickHouse** | **MySQL** | **StarRocks** |
|---------------|-------------|----------|-------------|
| **存储模型**   | 列式存储     | 行式存储  | 列式存储     |
| **查询性能**   | 高并发、OLAP | 适用于 OLTP | 高并发、实时分析 |
| **索引机制**   | 主键索引、跳跃索引 | B+ 树索引  | 主键索引、物化视图 |
| **实时性**     | 主要用于批处理 | 事务处理  | 近实时分析 |
| **适用场景**   | 日志分析、BI、金融数据 | 事务处理  | 实时数据分析 |

---

## **5️⃣ ClickHouse 的优缺点**
### **✅ 优势**
- **超高查询性能**：列式存储 + 并行计算，查询速度远超传统数据库。
- **高效数据压缩**：降低存储成本，提高查询效率。
- **分布式架构**：支持海量数据存储 & 分布式计算。
- **灵活的 SQL 支持**：兼容大部分 SQL 语法，易于迁移。

### **❌ 限制**
- **不支持事务（ACID）**：适用于 OLAP 场景，不适用于高并发事务处理。
- **数据更新较慢**：追加写入模式，不适用于频繁更新数据的场景。
- **高内存占用**：需要大量内存优化查询。

---

## **6️⃣ 总结**
ClickHouse 是 **高性能 OLAP 数据库**，专为 **大规模数据分析** 设计，采用 **列式存储、MergeTree 引擎、分布式计算** 提供超快的查询速度。适用于 **日志分析、金融交易、区块链数据** 等实时分析场景，但不适用于高并发 OLTP 事务处理。


# **Shared-Nothing 分布式架构**

## **🔹 Shared-Nothing 架构概述**
**Shared-Nothing（无共享）架构** 是一种分布式系统设计理念，其中 **每个节点都是独立的，不共享 CPU、内存、磁盘或网络资源**。每个节点自主存储和处理数据，并通过网络通信协作完成分布式计算。

---

## **🔹 Shared-Nothing vs. 其他架构**
| **架构类型**         | **描述** | **代表数据库** |
|---------------------|--------|--------------|
| **Shared-Nothing**  | **每个节点独立**，无资源共享，横向扩展能力强 | ClickHouse、StarRocks、Hadoop、CitusDB |
| **Shared-Disk**     | 多个节点共享磁盘存储，计算独立 | Oracle RAC、IBM DB2 |
| **Shared-Memory**   | 多个计算节点共享内存和磁盘 | SAP HANA |

---

## **🔹 Shared-Nothing 架构的关键特性**
1. **分布式存储**  
   - 每个节点存储独立数据，避免磁盘 I/O 竞争，提高吞吐量。  
2. **分片（Sharding）**  
   - 数据按照一定策略（如哈希、范围）分配到不同节点，提高查询并发能力。  
3. **无集中式瓶颈**  
   - **没有共享存储或共享内存**，扩展时仅需增加新节点，支持 **水平扩展（Scale-Out）**。  
4. **高可用性 & 容错性**  
   - 通过数据副本（Replication）和故障恢复（Failover）机制，保证高可用性。  

---

## **🔹 Shared-Nothing 架构的优势**
| **优势**           | **描述** |
|------------------|--------|
| **高可扩展性**     | 通过增加节点即可扩展存储 & 计算能力 |
| **无共享瓶颈**     | 每个节点独立工作，避免 I/O 或 CPU 竞争 |
| **高容错能力**     | 节点故障不会影响整个系统，副本机制可恢复数据 |
| **并行计算**       | 查询可在多个节点并发执行，提高吞吐量 |

---

## **🔹 Shared-Nothing 在 ClickHouse / StarRocks 中的应用**
### **🚀 ClickHouse**
- 采用 **分片（Sharding）+ 副本（Replication）** 机制。
- `Distributed` 表用于分布式查询，数据存储在多个节点，无需共享磁盘。

### **🚀 StarRocks**
- 通过 **存算分离（Storage & Compute Separation）** 提供高扩展性。
- 使用 **Colocation Join** 技术优化分布式查询，减少跨节点数据传输。

---


## **🔹 适用场景**
✅ **Shared-Nothing 适用于**：
- **大规模数据分析（OLAP）**：ClickHouse、StarRocks、Hadoop。
- **高并发查询**：日志分析、广告分析、金融数据。
- **分布式存储 & 计算**：海量数据场景。

🚫 **不适用于**：
- **高频事务（OLTP）**：银行系统、订单处理（适合 Shared-Disk）。
- **低延迟 JOIN 查询**：需要数据紧密存储的情况。

---

## **🔹 总结**
Shared-Nothing **架构简单、可扩展、无共享瓶颈**，是 **大规模分布式数据库**（如 ClickHouse、StarRocks、Hadoop）广泛采用的设计。适用于 **大数据分析、高并发查询** 场景，但对于事务型应用（OLTP）可能不是最佳选择。

🚀 **如果你的业务需要处理 PB 级数据并进行高效分析，Shared-Nothing 是理想架构！**


## 表引擎

### MergeTree

- ReplacingMergeTree ：在数据合并期间删除排序键值相同的重复项。
- CollapsingMergeTree ：增加状态列`Sign`，主键相同，没成对的状态行保留，多线程情况下-1和1可能存在乱序，导致无法被删除。
- VersionedCollapsingMergeTree ： 为了解决CollapsingMergeTree乱序写入情况下无法正常折叠问题，新增一列`Version`，主键相同，且Version相同、Sign相反的行，在Compaction时会被删除。
- SummingMergeTree ： 把所有具有相同主键的行合并为一行，并根据指定的字段进行累加。
- AggregatingMergeTree ： SummingMergeTree只能累加，这个能进行各种聚合，需要指定聚合函数。

#### 功能
- 按照主键排序
- 如果指定了分区键，则可以使用分区
- 支持数据复制
- 支持数据采样
- 并发/索引/分区/crud

### Log

  为了需要写入许多小数据量（少于一百万行）的表的场景而开发的。

#### 功能
- 数据被顺序append写到磁盘上；
- 不支持delete、update；
- 不支持index；
- 不支持原子性写；
- insert会阻塞select操作。

### Integration

  该系统表引擎主要用于将外部数据导入到ClickHouse中，或者在ClickHouse中直接操作外部数据源。

## **1. 交易数据（Transactions）表结构**
存储区块链上的所有交易记录，包括普通转账和智能合约调用。

```sql
CREATE TABLE transactions (
    tx_hash String,           -- 交易哈希
    block_number UInt64,      -- 区块号
    block_timestamp DateTime, -- 交易时间
    from_address String,      -- 发送方地址
    to_address String,        -- 接收方地址（可能为空）
    value Decimal(38,18),     -- 交易金额（ETH）
    gas_price UInt64,         -- Gas 价格（Wei）
    gas_used UInt64,          -- 实际 Gas 消耗
    status UInt8,             -- 交易状态（0:失败, 1:成功）
    method_id String,         -- 调用的合约方法 ID
    contract_address String,  -- 交易涉及的合约地址
    -- 物理存储引擎
    INDEX idx_tx_hash tx_hash TYPE bloom_filter() GRANULARITY 1,
    INDEX idx_from_address from_address TYPE bloom_filter() GRANULARITY 1,
    INDEX idx_to_address to_address TYPE bloom_filter() GRANULARITY 1
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(block_timestamp) 
ORDER BY (block_number, tx_hash) 
SAMPLE BY block_number
SETTINGS index_granularity = 8192;
```
