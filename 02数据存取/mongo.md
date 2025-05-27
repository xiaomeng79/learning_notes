# Mongo

## 数据同步

### 必须项
- 启用副本集（必需）：Checkpoint 依赖 MongoDB 的 ​​Change Streams​​ 功能，而 Change Streams 仅在副本集或分片集群中可用。
- 调整 Oplog 大小（关键）​：记录所有数据变更操作，Checkpoint 依赖 Oplog 中的操作日志恢复同步进度。
```shell
mongo -u sync_user -p secure_password --authenticationDatabase admin
use your_database
db.getCollection("target_collection").watch()  # 测试能否监听变更流
```
- 同步工具配置示例（以 SeaTunnel 为例）
```yaml
execution:
  checkpoint:
    interval: 3000    # Checkpoint间隔（毫秒）
    timeout: 60000    # Checkpoint超时时间
    storage:
      type: filesystem
      path: "hdfs:///seatunnel/checkpoints"  # 推荐使用HDFS或S3等可靠存储
```
- MongoDB Source 配置​
```yaml
source:
  MongoDB:
    uri: "mongodb://sync_user:secure_password@host1:27017,host2:27017/?replicaSet=rs0&authSource=admin"
    database: "your_database"
    collection: "target_collection"
    # 自动使用 Checkpoint 中的 Resume Token 恢复进度
```

### 可选同步模式
| 配置项                       | 用途                   | 依赖条件                                    |
| ---------------------------- | ---------------------- | ------------------------------------------- |
| `start_after_operation_time` | 从指定时间戳开始监听   | MongoDB ≥4.0，足够的 Oplog 容量，副本集模式 |
| `resume_token`               | 从精确断点恢复监听     | 需记录上一次的 Resume Token                 |
| `Checkpoint`                 | 自动记录和恢复同步进度 | 需配置可靠的 Checkpoint 存储（如 HDFS）     |