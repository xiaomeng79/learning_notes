## influxdb

[官方文档](https://docs.influxdata.com/influxdb/v1.7/)

## 与传统数据库的比较

- 存储成本大：对于时序数据压缩不佳，需占用大量机器资源
- 维护成本高：单机系统，需要在上层人工的分库分表，维护成本高
- 写入吞吐低：单机写入吞吐低，很难满足时序数据千万级的写入压力
- 查询性能差：适用于交易处理，海量数据的聚合分析性能差

## 与Hadoop的比较

- 数据延迟高：离线批处理系统，数据从产生到可分析，耗时数小时、甚至天级
- 查询性能差：不能很好的利用索引，依赖MapReduce任务，查询耗时一般在分钟级

## 时序数据库需要解决的问题

- 时序数据的写入：如何支持每秒钟上千万上亿数据点的写入
- 时序数据的读取：如何支持在秒级对上亿数据的分组聚合运算
- 成本敏感：由海量数据存储带来的是成本问题。如何更低成本的存储这些数据，将成为时序数据库需要解决的重中之重

## 如何解决

- 存储成本:利用时间递增、维度重复、指标平滑变化的特性，合理选择编码压缩算法，提高数据压缩比
- 高并发写入:数据先写入内存，再周期性的dump为不可变的文件存储
- 低查询延时，高查询并发:优化常见的查询模式，通过索引等技术降低查询延时；通过缓存、routing等技术提高查询并发

## 存储的原理

- 索引:由于其在查询和顺序插入时有利于减少寻道次数的组织形式,传统的数据库采用B Tree,
- TSM存储引擎:根据LSM Tree针对时间序列数据优化而来

## 概念

[InfluxDB详解之TSM存储引擎解析](http://blog.fatedier.com/2016/08/05/detailed-in-influxdb-tsm-storage-engine-one/)

### 数据格式
- database:数据库名称 物理隔离数据文件
- retention policy:存储策略,用于定期清除过期数据
- measurement: 测量指标名(表名)，例如 cpu_usage 表示 cpu 的使用率
- tag sets: tags 在 InfluxDB 中会按照字典序排序,索引
- field sets: 字段值,可以设置多个,底层是当做多条数据存储
- timestamp: 每一条数据都需要指定一个时间戳

### Point
InfluxDB 中单条插入语句的数据结构，series + timestamp 可以用于区别一个 point，也就是说一个 point 可以有多个 field name 和 field value

### Series
相当于是 InfluxDB 中一些数据的集合,series 的key为measurement + 所有 tags 的序列化字符串

### Shard
根据 retention policy 分割数据,存储成一个shard,每个shard就是一个tsm存储引擎

