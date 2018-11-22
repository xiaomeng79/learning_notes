## Hive

[教程](https://www.yiibai.com/hive/hive_installation.html)

### 配置mysql数据库存储

1. 根据官网下载安装 [官方手册](https://cwiki.apache.org/confluence/display/Hive/GettingStarted#GettingStarted-InstallationandConfiguration)

2. 下载mysql j包 [官方地址](https://dev.mysql.com/downloads/connector/j/)

```go
cp mysql-connector-java-8.0.13.jar $HIVE_HOME/lib
```

3. 修改配置文件

```go
cd $HIVE_HOME/conf
$ cp hive-default.xml.template hive-site.xml
```

配置如下
```go
<configuration>
<property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:mysql://127.0.0.1:3306/hive_data?createDatabaseIfNotExist=true</value>
</property>
<property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>com.mysql.cj.jdbc.Driver</value>
</property>
<property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>hive</value>
</property>
<property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>hive</value>
</property>
<property>    
        <name>hive.querylog.location</name>   
        <value>/home/hive2.1/tmp</value> 
</property>  
<property>    
        <name>hive.exec.local.scratchdir</name>   
        <value>/home/hive2.1/tmp</value> 
</property> 
<property> 
        <name>hive.downloaded.resources.dir</name>   
        <value>/home/hive2.1/tmp</value> 
</property>
</configuration>

```

```go
cd $HIVE_HOME/conf
$ cp hive-env.sh.template hive-env.xml
添加hadoop目录地址:   HADOOP_HOME=/usr/local/hadoop-2.8.5

```

4. 初始化数据

```go
$HIVE_HOME/bin/schematool -dbType mysql -initSchema
```

5. 进入客户端

```go
$HIVE_HOME/bin/hive
```
