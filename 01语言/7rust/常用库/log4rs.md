## log4rs

#### 配置文件

[参数解释](https://blog.csdn.net/wyansai/article/details/105186331)
[参数说明](https://segmentfault.com/a/1190000021681959)

```yaml
refresh_rate: 30 seconds

appenders:
  stdout:
    kind: console
  requests:
    kind: rolling_file
    path: "log/requests.log"
    encoder:
      kind: json
    policy:
      kind: compound
      trigger:
        kind: size
        limit: 10 mb
      roller:
        kind: fixed_window
        pattern: '{0}/requests.log.{{}}'
        base: 1
        count: 5

root:
  level: info
  appenders:
    - stdout
    - requests
```