## Hbase

[原理介绍](https://www.cnblogs.com/ajianbeyourself/p/7790044.html)
[原理及架构](https://www.cnblogs.com/steven-note/p/7209398.html) 看这篇就够了


### 使用的算法

[LSM](https://github.com/xiaomeng79/go-algorithm/tree/master/data-structures/binaryTree)

### 访问HBase Table中的行，只有三种方式：
- 通过单个rowkey访问
- 通过rowkey的range
- 全表扫描

所有
### 物理架构


### 存储架构

从HBase的架构图上可以看出，HBase中的存储包括HMaster、HRegionSever、HRegion、HLog、Store、MemStore、StoreFile、HFile等，以下是HBase存储架构图：
![](https://images2015.cnblogs.com/blog/1123009/201703/1123009-20170313151717557-1227474615.png)

HBase中的每张表都通过键按照一定的范围被分割成多个子表（HRegion），默认一个HRegion超过256M就要被分割成两个，这个过程由HRegionServer管理，而HRegion的分配由HMaster管理

1. HMaster的作用：

- 为HRegionServer分配HRegion
- 负责HRegionServer的负载均衡
- 发现失效的HRegionServer并重新分配
- HDFS上的垃圾文件回收
- 处理Schema更新请求

2. HRegionServer的作用：

- 维护HMaster分配给它的HRegion，处理对这些HRegion的IO请求
- 负责切分正在运行过程中变得过大的HRegion

#####  概念

1. HMaster

对Region进行负载均衡，分配到合适的HRegionServer

2. ZooKeeper

选举HMaster，对HMaster，HRegionServer进行心跳检测（貌似是这些机器节点向ZooKeeper上报心跳）

3. HRegionServer

数据库的分片，HRegionServer上的组成部分如下:

- Region：
HBase中的数据都是按row-key进行排序的，对这些按row-key排序的数据进行**水平切分**，每一片称为一个Region，它有startkey和endkey，Region的大小可以配置，一台RegionServer中可以放多个Region

- CF：
列族。一个列族中的所有列存储在相同的HFile文件中

- Store:
每一个HRegion由一个或多个Store组成，至少是一个Store，HBase会把一起访问的数据放在一个Store里面，即为每个ColumnFamily建一个Store，
如果有几个ColumnFamily，也就有几个Store。一个Store由一个MemStore和0或者多个StoreFile组成。 HBase以Store的大小来判断是否需要切分HRegion。
        
- MemStore：
HFile在内存中的体现。当我们update/delete/create时，会先写MemStore，写完后就给客户端response了，当Memstore达到一定大小后，会将其写入磁盘，保存为一个新的HFile。HBase后台会对多个HFile文件进行merge，合并成一个大的HFile

- StoreFile:
MemStore内存中的数据写到文件后就是StoreFile，StoreFile底层是以HFile的格式保存。

- HFile：
HFile就是Hadoop磁盘文件，一个列族中的数据保存在一个或多个HFile中，这些HFile是对列族的数据进行水平切分后得到的。

- HLog: 
HLog(WAL log)：WAL意为write ahead log，用来做灾难恢复使用，HLog记录数据的所有变更，一旦region server 宕机，就可以从log中进行恢复


#### 应用场景

应用在离线的大数据分析和统计场景中,列操作,数据写入后无须更新和删除

