# Channel

## 结构

通道是一个加锁的环形链表

## 底层结构
```go
type hchan struct {
    // chan 里元素数量
    qcount   uint
    // chan 底层循环数组的长度
    dataqsiz uint
    // 指向底层循环数组的指针
    // 只针对有缓冲的 channel
    buf      unsafe.Pointer
    // chan 中元素大小
    elemsize uint16
    // chan 是否被关闭的标志
    closed   uint32
    // chan 中元素类型
    elemtype *_type // element type
    // 已发送元素在循环数组中的索引
    sendx    uint   // send index
    // 已接收元素在循环数组中的索引
    recvx    uint   // receive index
    // 等待接收的 goroutine 队列
    recvq    waitq  // list of recv waiters
    // 等待发送的 goroutine 队列
    sendq    waitq  // list of send waiters
    // 保护 hchan 中所有字段
    lock mutex
}
```

#### 通道死锁

- 当无缓存通道,不具备同时写入和读取就绪的情况下,写入数据或者读取数据
- 全部取出的管道，再取会出现死锁
- 已经塞满的管道，在塞也会死锁
