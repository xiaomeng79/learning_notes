# Sui

## 资料
- Github:  https://github.com/MystenLabs
- Sui docs:  https://docs.sui.io/
- Sui 接口文档: https://docs.sui.io/sui-api-ref#suix_getallbalances
- Sui 浏览器: https://suiscan.xyz/
- https://suivision.xyz/
- Typescript: https://sdk.mystenlabs.com/typescript/install

## 概念
一层区块链平台，目标是解决传统区块链在性能和可扩展性方面的瓶颈。

## 对象模型
Sui 中存储的基本单位是对象。与许多其他区块链（存储以包含键值存储的账户为中心）不同，Sui 的存储以可通过唯一 ID 在链上寻址的对象为中心。智能合约是一个对象（称为 Sui Move 包），这些智能合约在 Sui 网络上操纵对象：
- Sui Move 包： 一组 Sui Move 字节码模块。每个模块都有一个在包含包内唯一的名称。包的链上 ID 和模块名称的组合唯一地标识了模块。当您将智能合约发布到 Sui 时，包是发布的单位。发布包对象后，它是不可变的，永远无法更改或删除。包对象可以依赖于之前发布到 Sui 的其他包对象。
- Sui Move 对象： 由 Sui Move 包中的特定 Sui Move 模块控制的类型化数据。每个对象值都是一个结构体，其字段可以包含原始类型（例如整数和地址）、其他对象和非对象结构体。

## SUI 共识
依靠委托权益证明（DPoS）来确定处理交易的验证者集。

## SUI 代币
SUI 代币是 SUI 区块链平台的原生加密货币，SUI 代币主要用于交易费用，质押和激励等。

## Sui Indexer 提供三个主要功能
- 将数据从完整节点提取到关系数据库。完整节点上的数据以 BCS 字节的形式存储在嵌入式 RocksDB 中，因此查询功能非常有限。索引器提取检查点 blob 数据，并使用适当的索引将其模式化为各种表（如对象、交易等）。
- 为在线事务处理 (OLTP) RPC 请求提供服务。利用关系数据库中的数据，Sui 索引器将无状态读取器二进制文件旋转为具有接口的 JSON RPC 服务器。
- 分析索引器。除了 OLTP 数据提取和请求之外，索引器还支持一些分析数据提取，如每秒事务数 (TPS) 和每日活跃用户 (DAU) 指标。

## Sui 代币精度：9
