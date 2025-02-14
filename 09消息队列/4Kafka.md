## Kafka

#### 架构图

![架构图2](https://images2015.cnblogs.com/blog/512650/201611/512650-20161103135336861-18609635.png)

### 1. Kafka 的核心组件有哪些？
- **Producer**：负责将消息发送到 Kafka。
- **Consumer**：从 Kafka 消费消息。
- **Broker**：Kafka 服务器，负责存储消息和处理消息请求。
- **Zookeeper**：用于管理和协调 Kafka 集群（存储元数据、Leader 选举等）。
- **Topic**：消息的类别，Producer 将消息发送到特定的 Topic。
- **Partition**：Topic 被划分为多个 Partition，分布在多个 Broker 上。
- **Consumer Group**：消费者组，允许多个消费者并行消费一个 Topic。

### 2. Kafka 的工作流程是怎样的？
- Producer 生产消息，并将消息写入到指定的 Topic。
- Kafka Broker 将消息存储在 Topic 的 Partition 中。
- Consumer 从 Kafka Broker 读取消息。消费者可以根据 Consumer Group 来划分不同的消费任务。

### 3. Kafka 是如何保证高吞吐量的？
- **分区（Partition）**：消息被分布到多个分区，允许并行处理。
- **顺序写入（Sequential Writes）**：消息按顺序写入磁盘，避免了随机写入的性能瓶颈。
- **批量处理**：Kafka 支持生产者端和消费者端的批量消息发送和消费，减少了 I/O 操作。
- **压缩（Compression）**：Kafka 支持压缩消息，减少了存储和传输的带宽占用。

### 4. Kafka 的存储机制是怎样的？
Kafka 采用顺序写入日志的方式存储消息，每个消息都有一个唯一的 Offset，消息会被持久化到磁盘。Kafka 使用了基于分区的存储方式，消息以分区为单位存储，可以轻松扩展和负载均衡。

### 5. Kafka 的生产者（Producer）和消费者（Consumer）如何交互？
- 生产者将消息发送到 Kafka 的某个 Topic。
- 消费者订阅一个或多个 Topic，拉取消息。
- 消费者在消费时基于消息的 Offset 进行读取，可以选择提交（commit）或不提交（acknowledge）消息的 Offset。

### 6. Kafka 是如何保证消息的顺序性的？
Kafka 保证的是在同一个 Partition 中消息的顺序性。由于每个 Partition 中的消息是顺序写入的，所以消息的顺序在 Partition 内是有保证的。多个消费者组中的消费者之间不保证顺序。

### 7. Kafka 是如何处理消息丢失问题的？
- 每个 Partition 有多个副本，其中一个副本为 Leader，其他为 Follower。
- 消息写入时会写入所有副本（可配置），确保数据的高可靠性。
- 消息的持久化和副本机制保证即使部分 Broker 宕机，消息仍然不会丢失。

### 8. Kafka 是如何实现分区（Partition）的？
Kafka 将 Topic 分为多个 Partition，每个 Partition 可以在不同的 Broker 上。分区的数目可以根据需要进行配置，Partition 的划分使得 Kafka 可以横向扩展，支持高并发。

### 9. Kafka 是如何进行 Leader 选举的？
Kafka 使用 Zookeeper 来进行 Leader 选举。当一个 Partition 的 Leader 宕机时，Zookeeper 会检测到并触发选举，选举一个新的 Broker 来作为该 Partition 的 Leader。

### 11. Kafka 副本（Replica）机制是如何工作的？
每个 Partition 会有多个副本，其中一个副本为 Leader，负责读写操作；其他副本为 Follower，只负责同步数据。副本之间的同步是异步的，但 Kafka 会保证在 Leader 宕机时自动选举出新的 Leader。

### 12. Kafka 的 Zookeeper 作用是什么？可以去掉 Zookeeper 吗？
Zookeeper 在 Kafka 中主要用于：
- 存储元数据（例如 Topic、Partition 的信息）。
- 进行 Broker 的管理和负载均衡。
- 进行 Leader 选举。
  
Kafka 在 2.8 版本引入了 KRaft 模式（Kafka Raft Metadata Mode），逐步去除 Zookeeper，实现了更加简化和高效的架构。

### 14. Kafka 为什么比传统消息队列（RabbitMQ、ActiveMQ）快？
Kafka 通过顺序写入、分区机制和批量处理的方式极大地提升了吞吐量，同时 Kafka 适合大规模分布式环境，并且能够高效地处理大量的消息。

### 15. Kafka 生产者端如何优化消息发送？
- **批量发送**：将多条消息打包成一批发送。
- **压缩**：启用压缩算法（如 GZIP、Snappy）减少消息大小。
- **异步发送**：生产者可以异步发送消息，避免等待响应，提高吞吐量。

### 16. Kafka 是如何保证消息不丢失的？
Kafka 通过副本机制和持久化存储来保证消息不丢失。消息写入时，会写入多个副本，确保数据的高可靠性。在消费者消费时，如果消息未被确认，消息可以重新投递。

### 20. Kafka 如何扩容和缩容？
扩容：通过增加新的 Broker 节点并将 Partition 副本分布到新的节点上。
缩容：移除 Broker 后，调整 Partition 副本的分布，确保不会丢失数据。


### 21. Kafka 发生 Leader 选举时会有哪些影响？
在发生 Leader 选举时，该 Partition 会暂时无法进行读写操作，直到新的 Leader 被选举出来并恢复服务。

### 22. 在 Kafka 中如何设计一个高可用、高吞吐的消息系统？
- 配置多个 Partition 和副本，以确保高并发和容错能力。
- 使用合适的生产者和消费者配置（如批量处理、压缩、异步等）。
- 配置合理的消息过期时间，避免消息积压。
- 使用合理的消息存储和清理策略。





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
2) Broker端使用zookeeper用来注册broker信息,以及监测partition leader存活性.
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

15. 消费
- 一个消费组，下面可以有多个消费者，策略(如：轮询)消费不同分区数据。
- 多个消费组，每组都可以消费同样的topic下的全部数据。

### **如何优化 Kafka 的性能？**
1. **优化生产者**
   - **批量发送**（`batch.size` 调大）
   - **压缩消息**（`compression.type` 设置为 `snappy`）
   - **异步发送**（`acks=1` 或 `acks=0` 提高吞吐）
2. **优化 Broker**
   - **增加分区数**（`num.partitions`）
   - **副本异步刷盘**（`unclean.leader.election.enable=true`）
3. **优化消费者**
   - **多线程消费**（`poll()` 处理更多数据）
   - **手动提交偏移量**（避免重复消费）

16. 如何观察 Kafka 负载变化
```shell
GROUP                TOPIC         PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG        CONSUMER-ID
my-consumer-group    my-topic      0          1000           1100            100        consumer-1
my-consumer-group    my-topic      1          950            1050            100        consumer-2

```
- LAG（Log Append Gap）=最新的 Log End Offset−当前消费的 Offset。
- PARTITION 列表：如果增加了新的分区，消费者会自动负载均衡。
- LAG 值：表示未消费的消息量，若 LAG 过大，说明消费速度跟不上生产速度。




      