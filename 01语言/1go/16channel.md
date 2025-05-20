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

| **死锁场景**               | **关键原因**                            | **解决方案**                                                                         |
| -------------------------- | --------------------------------------- | ------------------------------------------------------------------------------------ |
| **同步操作顺序错误**       | 无缓冲通道的发送/接收未配对或未异步执行 | 使用缓冲通道，或确保发送/接收操作异步执行（用 `go` 启动协程）                        |
| **未关闭通道导致循环阻塞** | 接收方在 `for range` 中等待未关闭的通道 | 发送完成后显式关闭通道（`close(ch)`），或通过其他逻辑退出循环                        |
| **缓冲通道已满**           | 发送数据超过缓冲区且无接收方消费        | 增大缓冲区，或启动接收协程及时消费数据                                               |
| **`select` 永久阻塞**      | 所有 `case` 分支阻塞且无 `default` 分支 | 添加 `default` 分支（非阻塞模式）或设置超时（`time.After`）                          |
| **协程间循环等待**         | 多个协程互相等待对方发送数据            | 重构逻辑避免循环依赖，或引入超时机制（`context`/`time.After`）强制退出               |
| **未处理通道关闭**         | 接收方未检测通道关闭，导致死循环        | 使用 `val, ok := <-ch` 检测通道状态，或通过 `for range` 自动退出（需发送方关闭通道） |


#### select case
select 语句用于处理多个 channel 的并发操作，其底层实现基于 ​​轮询检查（polling）​​ 和 ​​随机选择（randomized selection）​​ 机制。
```go
type scase struct {
    c    *hchan         // 操作的 channel 指针
    elem unsafe.Pointer // 发送/接收的数据指针（发送时指向数据，接收时指向目标内存）
    kind uint16         // 操作类型：caseSend（发送）、caseRecv（接收）、caseDefault（默认）
    ...
}
```
select 语句在编译时会被转换为对 runtime.selectgo 函数的调用，该函数负责处理所有 case 的逻辑
```go
func selectgo(cas0 *scase, order0 *uint16, ncases int) (int, bool) {
    // cas0: scase 数组的指针
    // order0: 轮询顺序数组的指针（用于随机化选择顺序）
    // ncases: case 总数（包括 default）
    ...
}
```