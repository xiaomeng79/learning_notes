# Cosmos

## 资料
- 区块链浏览器： https://cosmos.bigdipper.live/
- 官网： https://cosmos.network/
- github: https://github.com/cosmos/
- 电报群： https://t.me/cosmosproject
- reddit： https://reddit.com/r/cosmosnetwork
- twitter： https://twitter.com/cosmos
- slideshare： https://www.slideshare.net/tendermint
- API 文档： https://docs.cosmos.network/api#tag/Query/operation/AllBalances
- Tendermint API 文档： https://docs.cometbft.com/main/rpc/#/Info/status

## 介绍
Cosmos 是一个去中心化的网络平台，它旨在解决当前区块链技术中的可扩展性和互操作性问题。Cosmos 通过一种称为 Tendermint 核心的共识机制，提供了一种模块化和高效的区块链架构，使不同区块链能够相互通信和协作。

## 关键组件

- Tendermint
  - Tendermint 是一种拜占庭容错 (BFT) 共识算法，它为 Cosmos 提供了基础层。Tendermint 核心允许开发人员快速构建高效、安全和可扩展的区块链应用。它包含两个主要部分：
    - Tendermint 核心：处理网络和共识部分，使区块链能够在不信任的环境中达到共识。
    - Application Blockchain Interface (ABCI)：允许开发人员用任意编程语言构建应用程序逻辑。
- Cosmos SDK
  - Cosmos SDK 是一个开发框架，它帮助开发者创建自定义区块链应用。SDK 提供了一组预定义的模块（例如账户、治理、staking 等），开发者可以使用这些模块构建他们的区块链，也可以创建新的模块来满足特定需求。

## (IBC) Protocol
IBC 协议是 Cosmos 实现不同区块链之间通信的关键。IBC 允许独立的区块链通过共享的中心枢纽进行通信和资产交换。该协议确保了跨链操作的安全性和可靠性。

## Cosmos 的互链安全
Cosmos 的互链安全（Interchain Security）是一种增强区块链网络整体安全性的机制，它允许多个区块链共享一个共同的安全层。具体来说，互链安全使较小的区块链（zones）能够利用较大、较安全的区块链（如 Cosmos Hub）的验证者集群来保护自己。这种机制提升了整个 Cosmos 生态系统的安全性和稳定性。

## Cosmos Hub
Cosmos Hub 是 Cosmos 网络的中心区块链，它充当不同区块链之间的中介，管理跨链通信和资产交换。ATOM 是 Cosmos Hub 的原生加密货币，用于支付交易费用和参与治理。

## 特点和优势
- 可扩展性：Cosmos 通过分区架构实现了高可扩展性，每个区块链（zone）可以独立处理交易，避免了传统区块链的性能瓶颈问题。
- 可互操作性：通过 IBC 协议，Cosmos 实现了不同区块链之间的无缝互操作，使得资产和数据能够跨链流动。
- 模块化： Cosmos SDK 提供了模块化的开发框架，开发者可以灵活地组合预定义模块或创建新模块，快速构建区块链应用。
- 安全性：Tendermint 核心提供了强大的安全保障，支持拜占庭容错共识，确保在部分节点恶意或故障的情况下，区块链仍能正常运作。



