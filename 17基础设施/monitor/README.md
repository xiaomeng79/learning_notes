# 监控报警系统

## 主要组件
### prometheus

- [prometheus](https://prometheus.io/) 时序数据库 [prometheus-book](https://yunlzheng.gitbook.io/prometheus-book/) | [prometheus.wang](https://www.prometheus.wang/)
- 收集客户端
  - [node_exporter](https://github.com/prometheus/node_exporter)
  - [blackbox_exporter](https://github.com/prometheus/blackbox_exporter) | [dashboards: 9965-blackbox_exporter](https://grafana.com/grafana/dashboards/9965)

### grafana

- [grafana](https://grafana.com) 可视化 | [创建警报管理](https://grafana.com/docs/grafana/latest/alerting/alerting-rules/create-grafana-managed-rule/)
- [plugins](https://grafana.com/grafana/plugins/)
  - [clickhouse](https://grafana.com/grafana/plugins/vertamedia-clickhouse-datasource/)
- [dashboards](https://grafana.com/grafana/dashboards/)
  - [(8919) node_exporter](https://grafana.com/grafana/dashboards/8919)
  - [(9965) blackbox_exporter](https://grafana.com/grafana/dashboards/9965)
  - [(13606) clickhouse-performance](https://grafana.com/grafana/dashboards/13606/)

### PrometheusAlert

- [PrometheusAlert](https://github.com/feiyu563/PrometheusAlert) 告警中心

