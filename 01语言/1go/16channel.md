# Channel

## 结构

通道是一个加锁的环形链表

## 底层结构
```go
type hchan struct {
    qcount   uint           // 当前队列中元素数量
    dataqsiz uint           // 缓冲区大小（容量）
    buf      unsafe.Pointer // 指向环形缓冲区的指针
    elemsize uint16         // 元素类型大小
    closed   uint32         // 关闭标记（0-未关闭，1-已关闭）
    sendx    uint           // 发送索引（缓冲区位置）
    recvx    uint           // 接收索引（缓冲区位置）
    recvq    waitq          // 接收等待队列（sudog 链表）
    sendq    waitq          // 发送等待队列（sudog 链表）
    lock     mutex          // 互斥锁（保护并发操作）
}
```

# 发送与接收流程

## 加锁
- 操作前获取 `hchan.lock` 互斥锁。

## 快速路径
- ​**发送**：缓冲区未满时直接写入 `buf`，更新索引。
- ​**接收**：缓冲区非空时直接读取 `buf`，更新索引。

## 阻塞路径
- ​**发送阻塞**：缓冲区满时，Goroutine 封装为 `sudog` 加入 `sendq` 队列，并进入等待状态。
- ​**接收阻塞**：缓冲区空时，Goroutine 封装为 `sudog` 加入 `recvq` 队列，并进入等待状态。

## 唤醒机制
- 当对端操作完成（如接收方读取数据），检查等待队列并唤醒对应的 Goroutine。

---

## 关闭

## 关闭标记
- 设置 `hchan.closed = 1`。

## 唤醒所有等待的 Goroutine
- ​**接收方**被唤醒后读取剩余数据，后续返回零值和 `false`。
- ​**发送方**被唤醒后触发 panic（向已关闭 Channel 发送数据）。

#### 通道死锁

- 当无缓存通道,不具备同时写入和读取就绪的情况下,写入数据或者读取数据
- 全部取出的管道，再取会出现死锁
- 已经塞满的管道，在塞也会死锁
- 重复关闭
