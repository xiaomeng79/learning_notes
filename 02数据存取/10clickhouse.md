# ClickHouse

## 一、概述
### 1.1 定义
ClickHouse 是开源的**列式存储数据库**，专为实时分析设计，具有高性能OLAP查询能力，适用于日志分析、金融交易等场景。

### 1.2 核心特性
- **列式存储**：仅读取查询列，减少I/O
- **高压缩率**：LZ4/ZSTD压缩算法
- **分布式架构**：Shared-Nothing架构支持水平扩展
- **SQL兼容**：支持标准SQL语法
- **实时分析**：支持每秒万级QPS的聚合查询

### 1.3 适用场景
- 日志/事件数据分析
- 实时BI报表
- 时序数据存储
- 用户行为分析
- 区块链交易追踪

---

## 二、核心原理
### 2.1 体系架构
#### Shared-Nothing 架构
| 特性          | 说明                          |
|---------------|-------------------------------|
| 节点独立性    | 每个节点独立存储/计算资源     |
| 扩展方式      | 分片(Sharding)+副本(Replication) |
| 数据分布      | Distributed表引擎管理分布式查询 |
| 容错机制      | 多副本自动切换                |

#### 架构对比
| 类型          | 特点                          | 代表系统       |
|---------------|-------------------------------|----------------|
| Shared-Nothing | 无资源共享，横向扩展能力强    | ClickHouse     |
| Shared-Disk   | 共享存储，计算节点独立        | Oracle RAC     |
| Shared-Memory | 共享内存和存储                | SAP HANA       |

### 2.2 存储引擎
#### MergeTree 系列
| 引擎类型                  | 功能特性                                      |
|--------------------------|---------------------------------------------|
| MergeTree                | 基础引擎，支持分区/索引/数据合并               |
| ReplacingMergeTree       | 删除重复数据（需指定版本列）                   |
| CollapsingMergeTree      | 通过Sign列折叠数据（±1标记）                  |
| VersionedCollapsingMergeTree | 增加Version列解决乱序问题                   |
| SummingMergeTree         | 自动聚合数值列                                |
| AggregatingMergeTree     | 支持预聚合函数（uniq/state等）                |

#### 特殊引擎
| 引擎类型      | 适用场景                          |
|---------------|----------------------------------|
| Log引擎       | 小数据量快速写入（无索引/事务）    |
| Integration引擎 | 外部数据源集成（如MySQL/Kafka）   |

### 2.3 查询优化
#### 索引机制
- **主键索引**：稀疏索引加速范围查询
- **跳跃索引**：跳过无关数据块（minmax/bloom_filter等）
- **分区裁剪**：根据分区键过滤数据

#### 执行优化
| 优化技术       | 实现方式                          |
|---------------|----------------------------------|
| 向量化执行     | SIMD指令加速批量计算              |
| 并行计算       | 多核并行处理查询                  |
| 分布式查询     | 分片并行执行+结果聚合             |
| 缓存机制       | 查询结果缓存（实验性）            |

---

## 三、对比分析
### 3.1 与OLTP数据库对比
| 特性          | ClickHouse          | MySQL              |
|---------------|---------------------|--------------------|
| 存储模型      | 列式存储            | 行式存储           |
| 事务支持      | 无                  | ACID事务           |
| 查询场景      | 大批量聚合查询      | 点查/简单查询      |
| 更新性能      | 低（批量写入）      | 高（行级更新）     |
| 数据压缩率    | 5-10倍              | 1-3倍              |

### 3.2 与同类OLAP对比
| 特性          | ClickHouse          | StarRocks          |
|---------------|---------------------|--------------------|
| 实时写入      | 弱（批量导入）      | 强（支持UPSERT）   |
| JOIN性能      | 需优化（分布式JOIN）| 本地JOIN优化       |
| 资源隔离      | 无                  | 支持资源组         |
| 生态集成      | 丰富（Kafka/Spark） | 云原生集成         |

---

## 四、最佳实践
### 4.1 数据建模建议
1. **分区策略**：按时间分区（如`toYYYYMMDD(event_date)`）
2. **主键设计**：高频查询字段+时间列组合
3. **物化视图**：预计算加速聚合查询
4. **数据TTL**：自动清理过期数据

### 4.2 性能调优
- **压缩算法**：ZSTD（高压缩率） vs LZ4（高速度）
- **索引粒度**：INDEX_GRANULARITY=8192（默认值）
- **并行度**：max_threads参数配置
- **内存管理**：max_memory_usage限制

### 4.3 典型用例
```sql
-- 创建分布式表
CREATE TABLE hits_distributed ON CLUSTER cluster
AS hits_local
ENGINE = Distributed(cluster, default, hits_local, rand());

-- 使用AggregatingMergeTree
CREATE MATERIALIZED VIEW view_name
ENGINE = AggregatingMergeTree()
ORDER BY (event_date)
AS SELECT 
    event_date,
    uniqState(user_id) AS uv
FROM hits_local
GROUP BY event_date;

```

## 主键索引（Primary Index）
1. 核心概念
本质 ：ClickHouse 的主键索引是稀疏索引 ，本质是数据排序的依据。
作用 ：通过 ORDER BY 子句定义，决定数据在磁盘上的物理存储顺序。
查询加速 ：通过跳过无关的数据块，减少 I/O 开销。
2. 创建方式
```sql
-- 在建表时通过 ORDER BY 指定主键：
CREATE TABLE example_table
(
    event_time DateTime,
    user_id UInt32,
    metric_value Float64
)
ENGINE = MergeTree()
ORDER BY (event_time, user_id)  -- 主键由 event_time 和 user_id 组成
PARTITION BY toYYYYMM(event_time);
```
3. 特点
- 稀疏性 ：索引标记（Index Granule）默认每 8192 行 存储一个标记。
- 非唯一性 ：允许重复值，不强制唯一约束。
- 排序性 ：数据按 ORDER BY 列的顺序物理存储。

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
