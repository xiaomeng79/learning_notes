# ETH

## 合约执行流程
- 当一个合约编写完成并成功编译后，我们就可以把它部署到以太坊上。合约部署后将自动获得一个地址，通过该地址即可访问合约。
- 把`contract`看作一个类，部署就相当于一个实例化。
- 构造函数在部署合约时就会立刻执行，且仅执行一次。合约部署后就无法调用构造函数。
- 任何外部账户都可以发起对合约的函数调用。如果调用只读方法，因为不改变合约状态，所以任何时刻都可以调用，且不需要签名，也不需要消耗Gas。但如果调用写入方法，就需要签名提交一个交易，并消耗一定的Gas。

## 验证
- 最常用的require()可以断言一个条件，如果断言失败，将抛出错误并中断执行。
- 以太坊合约具备类似数据库事务的特点，如果中途执行失败，则整个合约的状态保持不变。
- 合约如果执行失败，其状态不会发生任何变化，也不会有任何事件发生，仅仅是调用方白白消耗了一定的Gas。
- 检查都必须在合约的函数内部完成。

## 部署
- 测试地址:faucet.egorfine.com或faucet.dimensions.network获取一些测试网的Ether。

## 调用合约
- 页面的JavaScript代码无法直接访问以太坊网络的P2P节点，只能间接通过MetaMask钱包访问；
- 钱包之所以能访问以太坊网络的节点，是因为它们内置了某些公共节点的域名信息；
- 如果用户的浏览器没有安装MetaMask钱包，则页面无法通过钱包读取合约或写入合约。

## Dapp架构如下：

 ┌───────┐     ┌─────────┐     ┌───────┐
 │Wallet │◀────│Web Page │────▶│Server │
 └───────┘     └─────────┘     └───────┘
     │                             │
 read│write                        │read
     │                             │
┌ ─ ─│─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│─ ─ ┐
     ▼                             ▼
│ ┌─────┐        ┌─────┐        ┌─────┐ │
  │Node │────────│Node │────────│Node │
│ └─────┘        └─────┘        └─────┘ │
     │              │              │
│    │    ┌─────┐   │   ┌─────┐    │    │
     └────│Node │───┴───│Node │────┘
│         └─────┘       └─────┘         │
           Ethereum Blockchain
└ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
为Dapp搭建后端服务器时要严格遵循以下规范：
- 后端服务器只读取合约，不存储任何私钥，因此无法写入合约，保证了安全性；
- 后端服务器要读取合约，就必须连接到P2P节点，要么选择公共的节点服务（例如Infura），要么自己搭建一个以太坊节点（维护的工作量较大）；
- 后端服务器应该通过合约产生的日志（即合约运行时触发的event）监听合约的状态变化，而不是定期扫描。监听日志需要通过P2P节点创建Filter并获取Filter返回的日志；
- 后端服务器应该将从日志获取的数据做聚合、缓存，以便前端页面能快速展示相关数据。
因此，设计Dapp时，既要考虑将关键业务逻辑写入合约，又要考虑日志输出有足够的信息让后端服务器能聚合历史数据。前端、后端和合约三方开发必须紧密配合。

## 托管后端服务
- [graph](https://thegraph.com/zh/)
The Graph可以让我们部署一个Graph查询服务，如何定义表结构以及如何更新则由我们提供一个预编译的WASM。整个配置、WASM代码以及查询服务都托管在The Graph中，无需自己搭建服务器，非常方便。

因此，使用Graph的一个完整的DApp架构如下：

                ┌───────┐
    ┌───────────│ DApp  │───────────┐
    │           └───────┘           │
    │ read/write              query │
    │ contract                 data │
    ▼                               ▼
┌───────┐                       ┌───────┐
│Wallet │                       │ Graph │
└───────┘                       └───────┘
    │                               ▲
    │ sign                    index │
    │ broadcast                data │
    │                               │
    │  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
    │    ┌────┐ ┌────┐     ┌────┐ │ │
    └──┼▶│Node│ │Node│ ... │Node│───┘
         └────┘ └────┘     └────┘ │
       │         Ethereum
        ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘

## 安全性
- 加减导致的溢出
  - 从Solidity 0.8版本开始，编译器默认就会检查运算溢出，因此，不要使用早期的Solidity编译即可避免溢出问题。
- 条件不满足必须抛出异常回滚交易
- 重入攻击
  - 防止重入攻击的方法是一定要在校验通过后立刻更新数据，不要在校验-更新中插入任何可能执行外部代码的逻辑。
  - 
  ```solidity
  // 先回调再更新的方式会导致重入攻击，即如果callback()调用了外部合约，外部合约回调transfer()，会导致重复转账
  function transfer(address recipient, uint256 amount) public returns (bool) {
    require(recipient != address(0), "ERC20: transfer to the zero address");
    uint256 senderBalance = balanceOf[msg.sender];
    require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
    // 此处调用另一个回调:
    callback(msg.sender);
    // 更新转账后的额度:
    balanceOf[msg.sender] = senderBalance - amount;
    balanceOf[recipient] += amount;
    emit Transfer(sender, recipient, amount);
    return true;
    }
 ```