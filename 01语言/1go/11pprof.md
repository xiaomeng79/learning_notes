## pprof

### pprof采样数据获取方式

- runtime/pprof:手动调用
- net/http/pprof: 通过http服务获取采样数据,适用于对应用程序的整体监控
- go test:通过go test -bench . -cpuprofile prof.cpu生成采样文件,适合对函数进行针对性测试

### 采集项:

- goroutine: 获取程序当前所有 goroutine 的堆栈信息
- heap: 包含每个 goroutine 分配大小，分配堆栈等。每分配 runtime.MemProfileRate(默认为512K) 个字节进行一次数据采样
- threadcreate: 获取导致创建 OS 线程的 goroutine 堆栈
- block: 获取导致阻塞的 goroutine 堆栈(如 channel, mutex 等)

```go
      flat  flat%   sum%        cum   cum%
  514.38kB 33.39% 33.39%   514.38kB 33.39%  compress/flate.NewReader
     514kB 33.37% 66.76%      514kB 33.37%  bufio.NewReaderSize (inline)
  512.02kB 33.24%   100%   512.02kB 33.24%  net.sockaddrToTCP
         0     0%   100%   514.38kB 33.39%  bufio.(*Reader).WriteTo
         0     0%   100%      514kB 33.37%  bufio.NewReader

```
### go tool pprof 常用命令:
    
- topN: 输入 top 命令，默认显示 flat 前10的函数调用，可使用 -cum 以 cum 排序
- list Func: 显示函数名以及每行代码的采样分析
- web: 生成 svg 热点图片，可在浏览器中打开，可使用 web Func 来过滤指定函数相关调用树

总的思路就是通过top 和web 找出关键函数，再通过list Func 查看函数代码，找到关键代码行并确认优化方案(辅以 go test Benchmark)。

##### 详细信息描述

```go
type MemStats struct {
    // 一般统计
    Alloc      uint64 // 已申请且仍在使用的字节数
    TotalAlloc uint64 // 已申请的总字节数（已释放的部分也算在内）
    Sys        uint64 // 从系统中获取的字节数（下面XxxSys之和）
    Lookups    uint64 // 指针查找的次数
    Mallocs    uint64 // 申请内存的次数
    Frees      uint64 // 释放内存的次数
    // 主分配堆统计
    HeapAlloc    uint64 // 已申请且仍在使用的字节数
    HeapSys      uint64 // 从系统中获取的字节数
    HeapIdle     uint64 // 闲置span中的字节数
    HeapInuse    uint64 // 非闲置span中的字节数
    HeapReleased uint64 // 释放到系统的字节数
    HeapObjects  uint64 // 已分配对象的总个数
    // L低层次、大小固定的结构体分配器统计，Inuse为正在使用的字节数，Sys为从系统获取的字节数
    StackInuse  uint64 // 引导程序的堆栈
    StackSys    uint64
    MSpanInuse  uint64 // mspan结构体
    MSpanSys    uint64
    MCacheInuse uint64 // mcache结构体
    MCacheSys   uint64
    BuckHashSys uint64 // profile桶散列表
    GCSys       uint64 // GC元数据
    OtherSys    uint64 // 其他系统申请
    // 垃圾收集器统计
    NextGC       uint64 // 会在HeapAlloc字段到达该值（字节数）时运行下次GC
    LastGC       uint64 // 上次运行的绝对时间（纳秒）
    PauseTotalNs uint64
    PauseNs      [256]uint64 // 近期GC暂停时间的循环缓冲，最近一次在[(NumGC+255)%256]
    NumGC        uint32
    EnableGC     bool
    DebugGC      bool
    // 每次申请的字节数的统计，61是C代码中的尺寸分级数
    BySize [61]struct {
        Size    uint32
        Mallocs uint64
        Frees   uint64
    }
}
```