# ClickHouse

## 介绍

- [ClickHouse](https://github.com/ClickHouse/ClickHouse)
- [使用场景](https://zhuanlan.zhihu.com/p/98439924)

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