## oracle

### 执行计划

```bash
#生成执行计划
explain plan for
select * from table_name where id=123;
#查看执行计划
select * from table(dbms_xplan.display);
```

##### 几种常见的索引类型扫描：

第一种：index unique  scan

    索引唯一扫描，当可以优化器发现某个查询条件可以利用到主键、唯一键、具有外键约束的列，或者只是访问其中某行索引所在的数据的时候，优化器会选择这种扫描类型。

第二种：index range scan

    索引范围扫描，当优化器发现在UNIQUE列上使用了大于、小于、大于等于、小于等于以及BETWEEN等就会使用范围扫描，在组合列上只使用部分进行查询，导致查询出多行数据。对非唯一的索引列上进行任何活动都会使用index range scan。

第三种：index full scan

    全索引扫描，如果要查询的数据可以全部从索引中获取，则使用全索引扫描。

第四种：index fast full scan

    索引快速扫描，扫描索引中的全部的数据块，与全索引扫描的方式基本上类似。两者之间的明显的区别是，索引快速扫描对查询的数据不进行排序，数据返回的时候不是排序的。“在这种存取方法中，可以使用多块读功能，也可以使用并行读入，从而得到最大的吞吐量和缩短执行时间”。

order by、group by使用索引的前提条件:

1.order by、group by中所有的列必须包含在相同的索引中并保持在索引中的排列顺序;

2.order by、group by中所有的列必须定义为非空

##### 不走索引的几种情况：

1.where子句中使用 is null 和 is not null

2.where子句中使用函数

3.使用like ‘%T’ 进行模糊查询

4.where子句中使用不等于操作(包括：<>, !=, not colum >= ?, not colum <= ? ,可以使用or代替)

5.比较不匹配数据类型，例如：select * from tablewhere jlbh = 1；jlbh为varchar2类型字段


