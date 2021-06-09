## timer的使用

[timer的调度](https://mp.weixin.qq.com/s/iseiQ20eIUR9i02fy1tFhg)

### 如何存储

- Go 1.9 版本之前，所有的计时器由全局唯一的四叉堆维护，协程间竞争激烈。
- Go 1.10 - 1.13，全局使用 64 个四叉堆维护全部的计时器，没有本质解决 1.9 版本之前的问题。
- Go 1.14 版本之后，每个 P 单独维护一个四叉堆。

### 使用的问题

- 错误创建很多的 timer，导致资源浪费。
```go
func main() {
    for {
        // xxx 一些操作
        timeout := time.After(30 * time.Second) // timer.After 底层是调用的 timer.NewTimer
        select {
        case <- someDone:
            // do something
        case <-timeout:
            return
        }
    }
}
// 解决办法: 使用 time.Reset 重置 timer，重复利用 timer。
```
- 由于 Stop 时不会主动关闭 C，导致程序阻塞。
```go
func main() {
    timer1 := time.NewTimer(2 * time.Second)
    go func() {
        timer1.Stop()
    }()
    <-timer1.C //  goroutine 泄露，内存泄露

    println("done")
}
```

