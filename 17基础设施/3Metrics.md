## Metrics

[产品选型](https://www.jianshu.com/p/0f9375661088)

[go-metrics](https://github.com/rcrowley/go-metrics)

### 五种 Metrics 类型

   [介绍](https://studygolang.com/articles/12874)
   
- Gauges ：值是什么就是什么
- Counters：计数类统计，可以进行加或减，也可以进行归零操作，所有的操作都是在旧值的基础上进行的．这里可以通过每天归零，然后新增注册用户时加1来统计每天的注册用户
- Meters：Meter度量一系列事件发生的速率(rate)，例如TPS。Meters会统计最近1分钟，5分钟，15分钟，还有全部时间的速率。
- Histograms：Histogram统计数据的分布情况。比如最小值，最大值，中间值，还有中位数，75百分位, 90百分位, 95百分位, 98百分位, 99百分位, 和 99.9百分位的值(percentiles)。
- Timer其实是 Histogram 和 Meter 的结合， histogram 某部分代码/调用的耗时， meter统计TPS。

### 产品介绍

1. 数据采集

[telegraf](https://github.com/influxdata/telegraf) influxdata

[cadvisor](https://github.com/google/cadvisor)

2. 数据存储

[influxdb](https://github.com/influxdata/influxdb) influxdata [教程](https://www.cnblogs.com/shhnwangjian/p/6897216.html?utm_source=itdadao&utm_medium=referral)

[prometheus](https://github.com/prometheus/prometheus) 全套解决方案 [教程](https://www.ibm.com/developerworks/cn/cloud/library/cl-lo-prometheus-getting-started-and-practice/index.html) [文档](https://songjiayang.gitbooks.io/prometheus/content/promql/sql.html)

[graphite](https://github.com/graphite-project)

[influxdb和prometheus比较](https://blog.csdn.net/u011537073/article/details/80305804)

InfluxDB 和 Prometheus 的区别是啥。目前主要区别在于：前者仅仅是一个数据库，它被动的接受客户的数据插入和查询请求。而后者是完整的监控系统，能抓取数据、查询数据、报警等功能

Prometheus 是基于 pull 模式获取数据，InfluxDB 是基于 push 模式获取数据

3. 数据可视化

[grafana](https://github.com/grafana/grafana)

[chronograf](https://github.com/influxdata/chronograf) influxdata

4. 报警

[kapacitor](https://github.com/influxdata/kapacitor) influxdata

### Telegraf+InfluxDB+Grafana 搭建服务器监控平台

[链接](https://wanghualong.cn/archives/22/)

