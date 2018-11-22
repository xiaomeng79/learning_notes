## Spark

### RDD

RDD叫做弹性分布式数据集(Resilient Distributed Datasets)，它是一种分布式的内存抽象，表示一个只读的记录分区的集合，它只能通过其他RDD转换而创建，为此，RDD支持丰富的转换操作(如map, join, filter, groupBy等)，通过这种转换操作，新的RDD则包含了如何从其他RDDs衍生所必需的信息，所以说RDDs之间是有依赖关系的

RDD不了解其中存储的数据的具体结构，数据的结构对它而言是黑盒

[文章](http://sharkdtu.com/posts/spark-rdd.html)

基于RDD实现的Spark相比于传统的Hadoop MapReduce有什么优势呢？总结起来应该至少有三点：1）RDD提供了丰富的操作算子，不再是只有map和reduce两个操作了，对于描述应用程序来说更加方便；2）通过RDDs之间的转换构建DAG，中间结果不用落地；3）RDD支持缓存，可以在内存中快速完成计算。

##### 何时使用:

1. 您希望对数据集进行低级转换以及操作和控制
2. 您的数据是非结构化的，例如媒体流或文本流
3. 您希望使用函数式编程结构来操作数据，而不是使用特定于域的表达式
4. 在处理或按名称或列访问数据属性时，您不关心强制使用模式，例如列式格式;

### RDD DataFrame DataSet

DataFrame就是组织成有名字的列的分布式数据集合，概念上等同于关系型数据库的表

DataSet是强制类型的,用来替换DataFrame

![qubie](https://pic3.zhimg.com/b4fc63a85f4bbe9a91e7649e73f56622_b.png)

![rdd](https://databricks.com/wp-content/uploads/2018/05/rdd-1024x595.png)


rdd的优点：1.强大，内置很多函数操作，group，map，filter等，方便处理结构化或非结构化数据2.面向对象编程，直接存储的java对象，类型转化也安全rdd的缺点：1.由于它基本和hadoop一样万能的，因此没有针对特殊场景的优化，比如对于结构化数据处理相对于sql来比非常麻烦2.默认采用的是java序列号方式，序列化结果比较大，而且数据存储在java堆内存中，导致gc比较频繁dataframe的优点：1.结构化数据处理非常方便，支持Avro, CSV, elastic search, and Cassandra等kv数据，也支持HIVE tables, MySQL等传统数据表2.有针对性的优化，由于数据结构元信息spark已经保存，序列化时不需要带上元信息，大大的减少了序列化大小，而且数据保存在堆外内存中，减少了gc次数。3.hive兼容，支持hql，udf等dataframe的缺点：1.编译时不能类型转化安全检查，运行时才能确定是否有问题2.对于对象支持不友好，rdd内部数据直接以java对象存储，dataframe内存存储的是row对象而不能是自定义对象dataset的优点：1.dataset整合了rdd和dataframe的优点，支持结构化和非结构化数据2.和rdd一样，支持自定义对象存储3.和dataframe一样，支持结构化数据的sql查询4.采用堆外内存存储，gc友好5.类型转化安全，代码友好6.官方建议使用dataset


[区别和何时使用](https://databricks.com/blog/2016/07/14/a-tale-of-three-apache-spark-apis-rdds-dataframes-and-datasets.html)

#### 何时使用DataFrame和DataSet

1. 如果您需要丰富的语义，高级抽象和特定于域的API，请使用DataFrame或Dataset
2. 如果您的处理需要高级表达式，过滤器，映射，聚合，平均值，求和，SQL查询，列式访问以及对半结构化数据使用lambda函数，请使用DataFrame或Dataset
3. 如果您希望在编译时具有更高的类型安全性
4. Python和R用户使用DataFrame


### Spark Streaming

Spark Streaming 是 Spark Core API 的扩展，它支持弹性的，高吞吐的，容错的实时数据流的处理。数据可以通过多种数据源获取，例如 Kafka，Flume，Kinesis 以及 TCP sockets，也可以通过例如 map，reduce，join，window 等的高阶函数组成的复杂算法处理。最终，处理后的数据可以输出到文件系统，数据库以及实时仪表盘中。事实上，你还可以在数据流上使用 Spark机器学习 以及 图形处理算法 。

![Spark Streaming](http://spark.apache.org/docs/latest/img/streaming-arch.png)

在内部，它工作原理如下，Spark Streaming 接收实时输入数据流并将数据切分成多个批数据，然后交由 Spark 引擎处理并分批的生成结果数据流。

![](http://spark.apache.org/docs/latest/img/streaming-flow.png)

### Spark SQL

查询结果将以 Dataset / DataFrame 的形式返回

Spark SQL 也能够被用于从已存在的 Hive 环境中读取数据

```go
//连接mysql
val jdbcDF = spark.read.format("jdbc").option("url","jdbc:mysql://localhost:3306/test_data").option("dbtable","emp").option("user","root").option("password","root").option("driver","com.mysql.cj.jdbc.Driver").load()

```







