#### 准备

```
1.安装jmeter
```
> 参考:[jmeter使用](./jmeter使用.md)

#### 1.新建测试计划

```
默认打开jmeter会自动创建一个测试计划，然后在该测试计划中，新建一个线程组，线程数为50，Ramp-Up Period为1，循环次数为1

```
#### 2.配置JDBC

##### 配置
```
右击线程组，在弹出的快捷菜单中选择 添加 -> 配置元件 -> JDBC Connection Configuration

配置各项参数:
Variable Name :mysql
Database URL：JDBC格式的数据库连接，每种数据库的URL都有所区别。MySQL数据库的写法为 jdbc:mysql://127.0.0.1:3306/test，test为数据库的名称。
JDBC Driver class：JDBC驱动的名称，com.mysql.jdbc.Driver。
Username:test
Password:test
其他的配置项保持默认值即可。

```
##### 参数

```
Variable Name： 变量名称，需要变量名绑定到池。需要唯一标识。与JDBC取样器中的相对应，决定JDBC取样的配置。简单理解就是在JDBC request的时候确定去哪个绑定的配置。
MaxNumber of Connection： 数据库最大链接数
PoolTimeout： 数据库链接超时，单位ms
Idle Cleanup Interval （ms）： 数据库空闲清理的间隔时间，单位ms
Auto Commit：自动提交。有三个选项，true、false、编辑（自己通过jmeter提供的函数设置）
Transaction Isolation：   事务间隔级别设置，主要有如下几个选项：（对JMX加解密） 
TRANSACTION_REPEATABLE_READ事务重复读、
TRANSACTION_READ_COMMITTED事务已提交读 
TRANSACTION_SERIALIZABLE事务序列
TRANSACTION_READ_UNCOMMITTED事务未提交读、
TRANSACTION_NODE  事务节点 、
DEFAULT默认、
编辑
Keep-Alive： 是否保持连接
Max  Connection age （ms）：最大连接时长，超过时长的会被拒绝
Validation Query：验证查询，检验连接是否有效（数据库重启后之前的连接都失效，需要验证查询）
Database URL：如jdbc:mysql://localhost:3306/test，表示本地数据库，3306端口，请求访问的数据库名称为test，如果是远程数据库，例如数据库所在服务器IP为：192.168.11.120，请求的数据库名称为UserInfo，URL为dbc:mysql://192.168.11.120:3306/UserInfo
JDBCDriver Class： JDBC的类，如com.mysql.jdbc.Driver  
  
```

#### 3.添加MySQL的JDBC的驱动

#### 下载驱动

```
  因为JMeter没有自带JAR包，故需要到MySQL官方网站下载MySQL的JDBC驱动。
  官方下载地址：http://dev.mysql.com/downloads/file/?id=462850
  网盘下载地址：http://pan.baidu.com/s/1miIvNBE
  
```

#### 配置

```  
下载后，解压，然后将里面的 mysql-connector-java-5.1.39-bin.jar 文件拷贝至JMeter的bin目录，以便快速找到该驱动文件。
单击测试计划，在Add directory or jar to classpath处，点击浏览，选择mysql-connector-java-5.1.39-bin.jar文件，确定即可

```

#### 4.添加JDBC请求

```  
右击线程组，添加 -> Sampler -> JDBC Request，需要修改的参数包括以下几个：
Variable Name：和刚刚填写的名称一致即可，如MySQL。表示建立一个名称MySQL的连接池，之后其他的JDBC Request都共用这个连接池

Query Type：这里我们选择Update Statement，表示SQL语句的类型为写操作。
Query：所要测试的SQL语句。如 INSERT user(username,password,age) VALUES('jack','123456',17);

```

#### 5.添加监听器

```  
右击线程组，添加 -> 监听器，凭个人的喜好和需求任意添加几个监听器（如：图形结果、Summary Report和察看结果树）。

```

#### 6.启动查看

```  
最后，选中线程组后，点击主菜单栏里面的启动按钮执行测试计划中的线程组,点击察看结果树，可看到线程组的执行结果
```

