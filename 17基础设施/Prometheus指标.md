## Prometheus 指标分类详解

### 一、Counter（计数器）

**核心概念：**
- 单调递增的数值，只能增加或重置为0
- 用于追踪累积发生的数量
- 重启后可能重置为0

**典型应用场景：**
- 请求总数（`http_requests_total`）
- 错误发生次数（`errors_total`）
- 处理的任务数量（`tasks_processed_total`）
- 发送的字节数（`bytes_sent_total`）

**指标结构示例：**
```go
type Counter interface {
    Inc()    // +1
    Add(float64) // 增加指定值
}
```
```promql
http_requests_total{method="POST", endpoint="/api"} 1234
http_requests_total{method="GET", endpoint="/home"} 567

// 计算速率（最常用）：
rate(http_requests_total[5m])
// 计算增长量
increase(http_requests_total[1h])
// 检测计数器复位
resets(http_requests_total[24h])
```
**最佳实践：​**
- 为计数器指标名称添加_total后缀
- 配合标签(label)区分不同维度（方法、路径、状态码等）
- 避免用于可能减少的数值（如当前连接数）

### 二、Gauge（仪表盘）
**核心概念：**​​
- 任意变化的瞬时数值
- 代表某个时间点的状态快照
- 可以增加或减少

**典型应用场景：**​​
- 内存使用量（node_memory_used_bytes）
- CPU使用率（node_cpu_utilization）
- 活跃连接数（active_connections）
- 队列大小（queue_size）
- 温度读数（temperature_celsius）

**指标结构示例**
```go
type Gauge interface {
    Set(float64)  // 设置绝对值
    Inc()
    Dec()
    Add(float64)
    Sub(float64)
}
```
```
node_memory_used_bytes 15325589504
node_cpu_seconds_total{mode="idle"} 38245.43
```

**关键查询方法：​**
```
// 查看当前值：
node_memory_used_bytes
// 计算变化趋势
changes(node_disk_io_time_seconds[5m])
// 聚合计算
avg by (instance) (node_cpu_seconds_total)
// 预测未来值
predict_linear(node_filesystem_free_bytes[1h], 3600)
```
**最佳实践：​​**
- 使用有明确单位的指标名称（如_bytes、_seconds）
- 配合min()、max()、avg()等聚合函数
- 适用于需要查看当前状态的指标

### 三、Histogram（直方图）
**核心概念：**​​
- 通过分桶(buckets)统计数值分布
- 自动将观测值分配到预定义桶中
- 提供总值(_sum)和计数(_count)

​**​典型应用场景：​​**
- 请求延迟分布（http_request_duration_seconds）
- 响应大小分布（http_response_size_bytes）
- API调用时间分布

**指标结构示例**
```go
histogram := prometheus.NewHistogram(prometheus.HistogramOpts{
    Name:    "http_request_duration_seconds",
    Buckets: []float64{0.05, 0.1, 0.2, 0.5, 1, 2}, // 自定义桶边界
})
```
```
http_request_duration_seconds_bucket{le="0.1"} 125
http_request_duration_seconds_bucket{le="0.5"} 325
http_request_duration_seconds_bucket{le="1.0"} 812
http_request_duration_seconds_bucket{le="+Inf"} 1000
http_request_duration_seconds_sum 478.23
http_request_duration_seconds_count 1000
```

**关键查询方法：**
```
// 计算百分位数
histogram_quantile(0.95, 
  rate(http_request_duration_seconds_bucket[5m]))
// 计算平均响应时间
rate(http_request_duration_seconds_sum[5m]) / 
rate(http_request_duration_seconds_count[5m])
// 统计各桶请求占比
http_request_duration_seconds_bucket{le="0.5"} / 
http_request_duration_seconds_count

```
**最佳实践：​**
- 自定义桶边界以适应具体场景
- 使用合适的单位（如秒或毫秒）
- 桶边界应覆盖期望的范围
- 适用于需要分析数据分布的场景

### 四、Summary（摘要）
**核心概念：**​​
- 在客户端计算的百分位数
- 提供总观测值数量(_count)和总和(_sum)
- 预先计算并报告特定分位数

**典型应用场景：**​​
- 服务级延迟监控（P99，P95）
- 业务关键指标的分位数
- 当需要准确百分位但不需要聚合时

**指标结构示例**
```go
summary := prometheus.NewSummary(prometheus.SummaryOpts{
    Name:       "rpc_call_duration_seconds",
    Objectives: map[float64]float64{0.5: 0.05, 0.9: 0.01, 0.99: 0.001},
})
```

```
api_request_duration_seconds{quantile="0.5"} 0.032
api_request_duration_seconds{quantile="0.9"} 0.125
api_request_duration_seconds{quantile="0.99"} 0.543
api_request_duration_seconds_sum 12345.67
api_request_duration_seconds_count 9876
```

**关键查询方法**
```
// 直接查看特定百分位
api_request_duration_seconds{quantile="0.99"}
// 计算平均响应时间
api_request_duration_seconds_sum / 
api_request_duration_seconds_count

```
**最佳实践**
- 明确定义要追踪的百分位
- 适用于客户端计算百分位更可行的场景
- 当不需要跨实例聚合时
- 为不同环境配置不同的百分位目标


