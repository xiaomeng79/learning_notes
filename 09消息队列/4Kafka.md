## Kafka

[小白也懂](http://www.sohu.com/a/144225753_236714)

[详细原理](https://blog.csdn.net/ychenfeng/article/details/74980531)

[深入研究](https://www.cnblogs.com/xifenglou/p/7251112.html)

#### 架构图

![架构图1](http://www.uml.org.cn/bigdata/images/2017072521.png)

![架构图2](https://images2015.cnblogs.com/blog/512650/201611/512650-20161103135336861-18609635.png)

#### 概念

Kafka是一个开源的、分布式的、可分区的、可复制的基于日志提交的发布订阅消息系统

特点: 消息持久化  高吞吐量  分布式  多Client支持  实时

1. kafka管理

所有的broker都去zk上注册一个临时节点，只有一个可以注册成功，这个就是leader(controller)，其他就是broker follower
leader会watch broker follower ,一旦有宕机的，就会读取zk上这个broker的partition，并选举ISR中replica作为partition leader

2. 为什么kafka只能同一个组中的一个consumer去消费数据

因为不想使用悲观锁来控制并发，这样吞吐量会下降,如果觉得效率不高的时候，加partition的数量来横向拓展，如果想多个不同的业务消费同样的数据
就启动多个consumer group，最优的设计就是，consumer group下的consumer thread的数量等于partition数量，这样效率是最高的


3. producer将数据push给broker，consumer将数据pull进行处理，这样的好处是，broker设计简单，不需要感知consumer
的存在，consumer也不会有较大的压力，处理多少拿多少

4. 获取broker list
    producer发送信息给broker不通，会刷新broker的元信息，或定期刷新
    consumer 会连接zookeeper 获取元信息
    
5. topic 下会有**多个partition** ，partiton leader会提供消息的读写，replica只会备份消息，待leader crash，恢复使用 ，还有ISR中的选举leader
   
   
6. 数据只能写入leader，然后follower周期性的拉数据，if leader crash，no commit，data missing

7. ISR(in-sync Replica) : leader与follower基本保持同步
    当follower落后太多或者超过一定时间未发起数据复制，移除,只有数据拉取差不多，才会进入ISR
    当isr中所有replica都向leader发送ack，leader commit
    
8. 为了数据一致性，即使leader存在此消息，follower还未同步，leader未commit，consumer读不到，consumer只能读到commit的数据

9. partitions replica会均匀的分配到broker上面

10. zookeeper在kafka中的作用：

1) Producer端使用zookeeper用来"发现"broker列表,以及和Topic下每个partition leader建立socket连接并发送消息.
2) Broker端使用zookeeper用来注册broker信息,已经监测partition leader存活性.
3) Consumer端使用zookeeper用来注册consumer信息,其中包括consumer消费的partition列表等,同时也用来发现broker列表,并和partition leader建立socket连接,并获取消息。

11. 3种消息传输一致
at most once：消费者fetch消息，保存offset,不管处理  成功没
at least once： 消费者fetch消息,处理消息,保存offset,保存阶段出问题，consumer或者zookeeper
execfy once：最少1次+已处理消息的最大编号

12. kafka将topic分布在不同的partition上，不同的partition下存在index和log segment,index为稀疏索引，记录offset区间，leader partition  每次commit时候，产生一个segment，当达到
一定的时间或者空间限制的时候，segment才会被删除，不会立马消费就删除,所有也可以达到消息重放的效果

13. kafka的消息是否会丢失
kafka发送消息的方式(producer.type属性进行配置):同步(直接发送),异步(**在客户端缓存到一定数量发送**)
kafka保证消息被安全生产, 通过request.required.acks属性进行配置: 0(不确认) 1(leader接收成功) -1(leader,follower都接收成功)
想要更高的吞吐量就设置：异步、ack=0；想要不丢失消息数据就选：同步、ack=-1策略

    - 网络异常 ,消息不需要确认
    - 客户端异常,消息异步发送
    - 缓存区满了,消息丢失
    - 确认属性为1,消息未同步给follower,leader挂了
    
14. controller

kafka在所有broker中选出一个controller，所有Partition的Leader选举都由controller决定。controller会将Leader的改变直接通过RPC的方式（比Zookeeper Queue的方式更高效）通知需为此作出响应的Broker。同时controller也负责增删Topic以及Replica的重新分配





      