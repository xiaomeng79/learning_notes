## Hbase

[原理介绍](https://www.cnblogs.com/ajianbeyourself/p/7790044.html)
[原理及架构](https://www.cnblogs.com/csyuan/p/6543018.html)

![](https://images2015.cnblogs.com/blog/1123009/201703/1123009-20170313151328104-1730195369.png)

### 使用的算法

[LSM](https://github.com/xiaomeng79/go-algorithm/tree/master/data-structures/binaryTree)

### 组成

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

- HFile：
HFile就是Hadoop磁盘文件，一个列族中的数据保存在一个或多个HFile中，这些HFile是对列族的数据进行水平切分后得到的。

- MemStore：
HFile在内存中的体现。当我们update/delete/create时，会先写MemStore，写完后就给客户端response了，当Memstore达到一定大小后，会将其写入磁盘，保存为一个新的HFile。HBase后台会对多个HFile文件进行merge，合并成一个大的HFile

