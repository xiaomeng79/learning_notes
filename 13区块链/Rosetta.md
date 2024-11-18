# Rosetta

## 资料
- [Rosetta 开发文档](https://docs.cdp.coinbase.com/rosetta/reference/networklist/)
- [开发文档](https://github.com/coinbase/mesh-ecosystem/blob/master/implementations.md)

## Rosetta Api
Bitcoin Rosetta API 是由 Coinbase 提出的 Rosetta 标准的一部分，旨在为区块链和钱包提供一个统一的接口标准。这个标准化的接口使得与各种区块链的交互更加容易和一致，无论是对交易数据的读取还是写入。目前已经支持很多链，包含比特币，以太坊等主流链，也包含像 IoTex 和 Oasis 这样的非主流链。

### Data API：用于读取区块链数据。
- /network/list：返回支持的网络列表。
- /network/status：返回当前网络的状态信息。
- /network/options：返回支持的网络选项和版本信息。
- /block：返回指定区块的数据。
- /block/transaction：返回指定交易的数据。
- /account/balance：返回指定账户的余额。
- /mempool：返回当前未确认的交易池。
- /mempool/transaction：返回指定未确认交易的数据。

### Construction API：用于构建和提交交易。
- /construction/preprocess：分析交易需求并返回交易所需的元数据。
- /construction/metadata：返回构建交易所需的元数据。
- /construction/payloads：生成待签名的交易有效载荷。
- /construction/parse：解析交易并返回其操作。
- /construction/combine：将签名与待签名交易合并。
- /construction/hash：返回交易的唯一标识符（哈希）。
- /construction/submit：提交签名后的交易。