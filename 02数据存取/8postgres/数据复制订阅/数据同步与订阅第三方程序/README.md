## 数据同步与订阅

>| 本机ip:192.168.10.128

#### 数据库数据订阅的原理
[postgres的逻辑复制原理](https://blog.csdn.net/a615549958/article/details/105221629)

- 当Subscriber创建时会在对应的Publisher上创建一个slot，因为每一个订阅，都要消耗掉一个replication slot，需要消耗一个wal sender。 
- Publisher发生的改变都保存为wal文件，由walsender进程发送，然后Subscriber的apply进程应用后，才会删除对应的wal文件。所以断网恢复后可以自动同步。

#### 数据同步与订阅优势
数据通过逻辑订阅进入消息队列后，可以和其他系统之间解耦、消除不同系统之间吞吐量差异，达到削峰填谷作用

- 相比于http接口查询
	- 服务端压力小
	- 数据同步及时
	- 异构系统之间根据自己的处理能力处理数据

#### PostgreSQL的同步订阅机制和实现(实践)
- 发布端配置(表info初始化的时候自动生成)

```
# 启动服务
docker-compose -f docker-compose.yaml up -d
# 进入发布端容器
docker exec -ti 发布端容器ID /bin/bash
# 进入数据库
psql -U postgres
# 创建发布(针对表student)
test=# create publication testpub1 for table student;
CREATE PUBLICATION
# 查看数据库有那些发布
test=# select * from pg_publication;
 pubname  | pubowner | puballtables | pubinsert | pubupdate | pubdelete | pubtruncate 
----------+----------+--------------+-----------+-----------+-----------+-------------
 testpub1 |       10 | f            | t         | t         | t         | t
(1 row)
# 查看发布端的信息
select * from pg_stat_replication;
select * from pg_replication_slots;

```

- 订阅端配置(表student初始化的时候自动生成)
[订阅端配置参数](http://postgres.cn/docs/11/sql-createsubscription.html)

```
# 进入订阅端
docker exec -ti 订阅端容器ID /bin/bash
# 创建订阅端
create subscription testsub1 connection 'host=192.168.10.128 port=5432 user=postgres dbname=test password=meng' publication testpub1 with (enabled, create_slot, slot_name='sub1_from_pub1');

# 查看订阅者信息
select * from pg_subscription;
select * from pg_stat_subscription;

```

- 同步数据

```
# 查看数据
select * from student;

# 发布端插入数据
insert into student(name) values('test01');

# 订阅端查看数据
select * from student;
```

- 冲突的解决方法
1.修改订阅端的数据,删除造成冲突的主键,执行`ALTER SUBSCRIPTION testsub1 ENABLE`继续


#### Postgres通过逻辑订阅方式，同步数据到消息队列kafka
- 启动docker-compose
```
docker-compose -f docker-compose.yaml up -d
```

- kafka启动一个消费端
```
docker exec -ti kafka容器ID /bin/bash
# 创建主题
kafka-topics.sh --create -zookeeper zookeeper --replication-factor 1 --partitions 3 --topic student_name_logs
# 消费消息
kafka-console-consumer.sh --bootstrap-server 192.168.10.128:9092 --topic student_name_logs --from-beginning
```

- 启动逻辑订阅第三方组件
[amazonriver](https://github.com/hellobike/amazonriver)

```
./syncdb -config config.json
```

- 数据库插入数据
```
# 批量插入100万数据
insert into student(name,version) select 'aaaa','00000' from generate_series(1,1000000);
# 更新数据
update student set name='test' where id=10;
# 删除数据
delete from student where id=10;
```

- 查看监控`http://192.168.10.128:9090`

- 查看消费端
```
bash-4.4# kafka-console-consumer.sh --bootstrap-server 192.168.10.128:9092 --topic student_name_logs --from-beginning
{"schema":"public","table":"student","operation":"INSERT","data":{"version":"0.0.0","id":1,"name":"student01"},"operateTime":1592455096933}
{"schema":"public","table":"student","operation":"UPDATE","data":{"id":1,"name":"test","version":"0.0.0"},"operateTime":1592455528456}
```

- 测试第三方组件断开，重新连接后还可以继续同步数据


#### 常见问题
- 订阅端故障恢复后，从那个位置继续处理？机制是什么？
```
在上一次槽订阅记录的LSN位置开始，机制是WAL日志会记录一个事务开始的日志全局序列号，根据这个序列号就可以知道订阅端数据订阅到什么位置，只需要从这里开始即可
```
- 如何监控同步是否异常？
```
可以监控同步成功了多少条，失败了多少条？通过一些监控软件，比如：prometheus
```
- 异常数据如何检查?
```
可以通过PG的fdw机制，来检查订阅端数据和发送端有那些差异
```




#### 辅助命令

- docker操作
```
# 删除全部容器
 docker ps -a | awk '{print $1}' | xargs  docker rm
# 删除全部数据卷
 docker volume ls | awk  '{ print $2 }' | xargs  docker volume rm
```

- kafka操作
```
# 创建主题
kafka-topics.sh --create -zookeeper zookeeper --replication-factor 2 --partitions 3 --topic student_name_logs
# 查看topic详细信息
kafka-topics.sh --zookeeper zookeeper --describe --topic student_name_logs
# 消费消息
kafka-console-consumer.sh --bootstrap-server 192.168.10.128:9092 --topic student_name_logs --from-beginning
# 生产消息
kafka-console-producer.sh --broker-list 192.168.10.128:9092 --topic student_name_logs
```
