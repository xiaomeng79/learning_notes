# Solana

## 教程
- [solanazh](https://www.solanazh.com/)

## 资料
- RPC 文档： https://solana.com/docs/rpc
- github： https://github.com/solana-labs
- 浏览器 1： https://explorer.solana.com/
- 浏览器 2： https://solscan.io/
- 钱包相关的资料： https://solana.com/developers/cookbook
- solana web3js： https://github.com/solana-labs/solana-web3.js

## 账户
```rust
// 其中的lamports表示账号余额，data表示存储的内容，owner表示这个Account可以被谁来操作，类似文件所有者。 如果是合约账号，这里data的内容就是合约编译后的代码，同时executable为true
pub struct Account {
        /// lamports in the account
        pub lamports: u64,
        /// data held in this account
        #[serde(with = "serde_bytes")]
        pub data: Vec<u8>,
        /// the program that owns this account. If executable, the program that loads this account.
        pub owner: Pubkey,
        /// this account's data contains a loaded program (and is now read-only)
        pub executable: bool,
        /// the epoch at which this account will next owe rent
        pub rent_epoch: Epoch,
}
```

## 交易和指令

### 交易
交易包含调用网络上程序的指令，特性:
- 交易具有原子性——如果任何指令失败，整个交易失败且不会发生任何更改。
- 交易中的指令按顺序依次执行。
- 交易的大小限制为 1232 字节，来源于 IPv6 最大传输单元 (MTU) 的大小 1280 字节，减去网络头的 48 字节（40 字节 IPv6 + 8 字节分片头）。。

### 指令
调用程序的指令需要以下三个关键信息：
- 程序 ID：包含指令执行逻辑的程序
- 账户：指令所需的账户列表
- 指令数据：字节数组，指定要在程序上调用的指令以及指令所需的任何参数
```rust
pub struct Transaction {
    #[wasm_bindgen(skip)]
    #[serde(with = "short_vec")]
    pub signatures: Vec<Signature>,

    #[wasm_bindgen(skip)]
    pub message: Message,
}
pub struct Message {
    /// The message header, identifying signed and read-only `account_keys`.
    pub header: MessageHeader,

    /// All the account keys used by this transaction.
    #[serde(with = "short_vec")]
    pub account_keys: Vec<Pubkey>,

    /// 作为时间戳，防止重复交易，区块哈希在 150个区块后过期
    pub recent_blockhash: Hash,

    /// Programs that will be executed in sequence and committed in
    /// one atomic transaction if all succeed.
    #[serde(with = "short_vec")]
    pub instructions: Vec<CompiledInstruction>,
}
pub struct Instruction {
    /// Pubkey of the program that executes this instruction.
    pub program_id: Pubkey,
    /// Metadata describing accounts that should be passed to the program.
    pub accounts: Vec<AccountMeta>,
    /// Opaque data passed to the program for its own interpretation.
    pub data: Vec<u8>,
}
pub struct AccountMeta {
    /// An account's public key.
    pub pubkey: Pubkey,
    /// True if an `Instruction` requires a `Transaction` signature matching `pubkey`.
    pub is_signer: bool,
    /// True if the account data or metadata may be mutated during program execution.
    pub is_writable: bool,
}
```

## 介绍
Solana 是一个高性能的区块链平台，旨在实现快速、安全且可扩展的去中心化应用（dApps）和加密货币交易。它的设计初衷是解决传统区块链网络在扩展性和速度方面的局限，特别是比特币和以太坊在交易吞吐量和确认时间上的瓶颈。

## 特点
- 高吞吐量： Solana 通过独特的共识机制和优化的网络协议，能够处理高达 65,000 笔交易每秒（TPS），远高于比特币的 7 TPS 和以太坊的 15 TPS。
- 低延迟： Solana 网络的交易确认时间通常在 400 毫秒左右，确保了几乎即时的交易确认。
- 低交易费用： 由于其高效的网络设计，Solana 的交易费用非常低，通常只有几美分。这使得它在处理大量小额交易时非常经济。

## 技术亮点
- Proof of History (PoH)： Solana 的 PoH 是一种时间戳机制，创建了一个历史记录，证明了事件发生的顺序。这减少了节点这是一种区块传播协议，通过将数据拆分成小包并在节点之间传输，优化了数据传播的速度和效率。之间的通信需求，极大地提高了网络的效率。
- Tower BFT： 基于 PoH，Solana 实现了一种改进的拜占庭容错机制，称为 Tower BFT。这种机制确保了网络的安全性和一致性。
- Turbine： 由于其高效的网络设计，Solana 的交易费用非常低，通常只有几美分。这使得它在处理大量小额交易时非常经济。
- Gulf Stream：： Solana 采用的这项技术可以提前确认和转发交易，从而减少内存池中的未确认交易数量，提高网络吞吐量。
- Sealevel： Solana 的智能合约运行环境，允许并行处理数千个智能合约调用，从而实现高效的计算性能。
- Pipelining：  通过流水线处理，Solana 能够优化区块验证和传播的速度，使得整个网络保持高效运行。
- Cloudbreak：  这是一种水平扩展的账户数据库，支持并行读取和写入操作，从而优化了存储访问的性能。
- Archivers： 用于存储区块链数据的去中心化节点，确保数据的可靠存储和访问。

## 共识算法流程
- PoH 生成时间序列： Solana 网络通过 PoH 生成一个全局时间序列，所有节点都遵循这个时间序列。PoH 是通过连续的 SHA-256 哈希运算产生的，每个哈希值都是前一个哈希值的输入，从而形成一个不可篡改的时间链。
- 节点状态同步： 所有参与共识的节点都使用 PoH 时间序列来同步它们的状态。这意味着节点可以在不频繁通信的情况下验证和确认交易顺序。
- 验证者投票： 网络中的验证者（validators）对每个区块的有效性进行投票。每个验证者根据其在时间序列中的位置，对当前区块进行投票。如果区块被足够多的验证者投票通过，它将被确认并添加到区块链中。
- 投票计数和锁定机制： Tower BFT 使用一种称为“锁定投票”的机制。验证者在投票时会锁定其投票，如果某个区块在指定的时间内没有获得足够多的投票，验证者将锁定其投票，直到达成共识。锁定机制防止网络分叉，并确保共识的稳定性。
- 区块确认和传播： 一旦区块获得足够多的验证者投票通过，它将被确认并添加到区块链中。确认后的区块通过网络传播给其他节点，确保全网状态一致。
- 冲突处理： 如果出现分叉或投票冲突，Tower BFT 依赖于 PoH 时间序列来决定最优链。节点会选择包含更多已确认区块且时间戳最新的链作为主链，并放弃较短或较旧的分叉链。

## 算法优势
- 高效性： 由于 PoH 提供了一个全局时间序列，Tower BFT 大幅减少了节点之间的通信需求，提高了共识达成的效率。
- 安全性： Tower BFT 的锁定投票机制和基于 PoH 的冲突处理策略确保了网络的安全性，能够抵抗拜占庭节点的攻击。
- 低延迟： Tower BFT 结合 PoH 使得区块确认时间显著降低，通常在几百毫秒内完成交易确认。

## 生态系统
- Solana 的原生代币 SOL： SOL 是 Solana 网络的原生加密货币，用于支付交易费用和参与网络共识（通过质押）。
- dApps 和项目： Solana 上已经构建了多个去中心化应用和项目，包括去中心化金融（DeFi）平台、NFT 市场、游戏等。例如，知名的 Serum 去中心化交易所就是基于 Solana 构建的。
- 社区和开发者支持： Solana 具有活跃的开发者社区，并提供了丰富的开发工具和资源，如 Solana SDK 和开发者文档，以支持开发者在其平台上构建应用。

## Epoch 的定义
- 每个 Slot 是 Solana 的最小时间单位（约 400 毫秒）。
- Epoch是Solana 中的一个时间段，由多个 Slot 组成。
- 每个 Epoch 的长度固定为 432,000 个 Slot ，大约持续 2 天 （48 小时）。
- 每个 Epoch 开始时，网络会重新选举验证者集合。
- 每个 Epoch 结束后，系统会根据验证者的贡献（如出块、投票）发放奖励。
- 每个 Epoch 结束时，网络会生成状态快照（Snapshot），用于节点同步和数据恢复。

## 钱包开发相关的 RPC 接口

- getAccountInfo：获取账户信息
  - 本接口的作用是判断账户是否可用，如果 value 为 null, 说明不可用，否则可用
- getRecentBlockhash：获取 recentBlochHash
  - 获取最近的区块的 blockHash, 做为交易签名的 Nonce
- getMinimumBalanceForRentExemption：获取 rent 账户的最小 Rent
  - result 的结果为 prepareAccount的minBalanceForRentExemption 值
- getSlot：获取最新块高
- getConfirmedBlock：根据区块号获取里面的交易
- getConfirmedTransaction：根据交易 Hash 获取交易详情
- sendTransaction：发送交易到区块链网络





