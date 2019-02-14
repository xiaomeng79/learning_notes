## Raft协议

#### 系统各个节点保证一致性的3个组件

1. 状态机
    - Leader(客户端请求处理者,数据同步到其他节点)
    - Follower(请求的被动更新者)
    - Candidate(超时时间没收到Leader心跳,判断Leader故障,变为此状态,参与竞选)
2. Log(保存数据的修改)

3. 一致性模块(XA二阶段提交)

#### Leader选举过程

1. Follower一定时间内接收不到Leader心跳变为Candidate状态
2. 先投给自己一票,然后向其他节点请求投票
3. 当得票超过半数,选举为Leader

#### 实现

- etcd实现raft协议
- zookeeper实现了ZAB协议,类似Raft协议

