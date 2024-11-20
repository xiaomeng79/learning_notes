# EOS

## 概述
EOS（Enterprise Operating System）是一种开源的区块链平台，旨在提供一个可扩展的去中心化应用程序（DApp）开发环境。它采用了类似操作系统的架构，具有账户、验证器、数据库、消息传递等核心功能，为开发者提供了一个强大而灵活的平台，以构建各种区块链应用。


## 关键特性和组成部分
- 智能合约平台： EOS 提供了一个智能合约平台，开发者可以在上面部署和执行智能合约。这些合约可以编写使用 C++ 或其他支持的语言，并通过 EOSIO 软件进行部署。
- 高性能： EOS 致力于实现高吞吐量和低延迟的区块链交易处理。它使用了一种名为“委托权益证明（Delegated Proof of Stake，DPoS）”的共识机制，这种机制通过选举一组验证者来验证交易，并将交易打包进区块中。
- 低成本： EOS 设计的目标之一是降低区块链应用程序的开发和运行成本。它使用的资源模型允许用户根据其持有的代币来获取资源，而不需要支付每笔交易的费用。
- 水平扩展性： EOS 被设计为可以轻松地水平扩展，以满足不断增长的用户需求。其架构允许多个并行的链运行，并且可以通过网络链接来扩展其功能。
- 治理模型： EOS 采用了一种基于代币持有者的治理模型，使持币者能够对网络的发展和升级做出决策。这种模型通过投票来选择验证者和制定网络规则。

## 共识算法
DPoS 是一种共识机制。

## EOS 和 WAXP 钱包使用的 RPC 接口
- 获取链信息和状态
https://developers.eos.io/manuals/eos/v2.2/nodeos/plugins/chain_api_plugin/api-reference/index#operation/get_info
- 获取账户信息
https://developers.eos.io/manuals/eos/v2.2/nodeos/plugins/chain_api_plugin/api-reference/index#operation/get_account
- 获取账户余额
https://developers.eos.io/manuals/eos/v2.2/nodeos/plugins/chain_api_plugin/api-reference/index#operation/get_currency_balance
- 根据区块获取区块信息
https://developers.eos.io/manuals/eos/v2.2/nodeos/plugins/chain_api_plugin/api-reference/index#operation/get_block_info
- 根据 block 获取交易
https://developers.eos.io/manuals/eos/v2.2/nodeos/plugins/chain_api_plugin/api-reference/index#operation/get_block
- Json To Bin 编码接口
https://developers.eos.io/manuals/eos/v2.2/nodeos/plugins/chain_api_plugin/api-reference/index#operation/abi_json_to_bin
- 广播交易
  - https://developers.eos.io/manuals/eos/v2.2/nodeos/plugins/chain_api_plugin/api-reference/index#operation/push_transaction
  - https://developers.eos.io/manuals/eos/v2.2/nodeos/plugins/chain_api_plugin/api-reference/index#operation/send_transaction

