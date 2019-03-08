## TiDB

[中文文档](https://pingcap.com/docs-cn/)

#### 特性

- 高度兼容Mysql
- 水平弹性拓展
- 分布式事物
- 真正金融级高可用
- 一站式ＨＴＡＰ解决方案
- 云原生ＳＱＬ数据库

#### 组件

1. TiDB Server　: TiDB Server 负责接收 SQL 请求，处理 SQL 相关的逻辑，并通过 PD 找到存储计算所需数据的 TiKV 地址，与 TiKV 交互获取数据，最终返回结果
2. PD Server : Placement Driver (简称 PD) 是整个集群的管理模块
3. TiKV Server : TiKV Server 负责存储数据