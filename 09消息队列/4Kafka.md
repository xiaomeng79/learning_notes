## Kafka

[概念](https://www.cnblogs.com/likehua/p/3999538.html)

1. producer将数据push给broker，consumer将数据pull进行处理，这样的好处是，broker设计简单，不需要感知consumer
的存在，consumer也不会有较大的压力，处理多少拿多少

2. 获取broker list 
    producer发送信息给broker不通，会刷新broker的元信息，或定期刷新
    consumer 会连接zookeeper 获取元信息
    
3. topic
   
   
4. 数据只能写入leader，然后follower周期性的拉数据，if leader crash，no commit，data miss

5. ISR(in-sync Replica) : leader与follower基本保持同步
    当follower落后太多或者超过一定时间未发起数据复制，移除,只有数据拉取差不多，才会进入ISR
    当isr中所有replica都向leader发送ack，leader commit
    
6. 为了数据一致性，即使leader存在此消息，follower还未同步，leader未commit，consumer读不到，consumer只能读到commit的数据

7. leader提供读写，replica不提供读写，只提供备份，选举leader

8. partitions replica会均匀的分配到broker上面



      