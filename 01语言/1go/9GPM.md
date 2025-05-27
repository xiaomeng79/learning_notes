## GPM

[知乎](https://www.zhihu.com/question/20862617)

[goroutine与调度器](http://skoo.me/go/2013/11/29/golang-schedule?utm_campaign=studygolang.com&utm_medium=studygolang.com&utm_source=studygolang.com)

[参考](https://blog.csdn.net/heiyeshuwu/article/details/51178268?utm_campaign=studygolang.com&utm_medium=studygolang.com&utm_source=studygolang.com)

[简单参考](https://www.zhihu.com/question/20862617)

## go的运行时调度器

要想运行一个 goroutine - `G`，那么一个线程 `M`，就必须持有一个该 goroutine 的上下文 `P`


### G(goroutine):

表示一个goroutine。它包括栈、指令指针以及对于调用goroutines很重要的其它信息，比如阻塞它的任何channel。在可执行代码里，它被称为G。

#### G的分类

- 执行用户任务的叫做`g`，起始只有2KB，可扩容。
- 执行 runtime.main 的 main goroutine。
- 执行调度任务的叫`g0`，每一个`m`都仅只有一个`g0`，默认系统栈大小`8M`，不能扩缩容。

### M(machine):系统线程

表示OS线程。

>| m0 是Go Runtime所创建的第一个系统线程，一个Go进程只有一个 m0，也叫主线程。

### P(process):处理器,调度上下文

表示用于调用的上下文。你可以把它看作在一个单线程上运行代码的调度器的一个本地化版本。它是让我们从N：1调度器转到M：N调度器的重要部分。在运行时代码里，它被叫做P，即处理器（processor）。

### GMP模型
M代表一个工作线程，在M上有一个P和G，P是绑定到M上的，G是通过P的调度获取的，在某一时刻，一个M上只有一个G（g0除外）。在P上拥有一个G队列，里面是已经就绪的G，是可以被调度到线程栈上执行的协程，称为运行队列。

### 为什么需要多个P
>| 多个 P 使多个 M 可以同时执行 G​​，实现真正的并行（而不仅是并发）
>| 多个 P 将 Goroutine 分配到不同的逻辑处理器
1. 因为当一个M0被阻塞,P可以转而投奔另外的M1
2. 当M0处理完返回时,它必须尝试取得一个context P来运行goroutine，一般情况下，它会从其他的OS线程那里steal偷一个context过来
3. 如果没有偷到的话，它就把goroutine放在一个global runqueue里，然后自己就去睡大觉了（放入线程缓存里）。Contexts们也会周期性的检查global runqueue，否则global runqueue上的goroutine永远无法执行。
4. P所分配的任务G很快就执行完了（分配不均），这就导致了一个上下文P闲着没事儿干而系统却任然忙碌。但是如果global runqueue没有任务G了，那么P就不得不从其他的上下文P那里拿一些G来执行。一般来说，如果上下文P从其他的上下文P那里要偷一个任务的话，一般就‘偷’run queue的一半，这就确保了每个OS线程都能充分的使用



### 总结
![搬砖](https://pic1.zhimg.com/80/v2-e368c077748ac049336b8efaf06753f8_hd.png)

地鼠(gopher)用小车运着一堆待加工的砖。M就可以看作图中的地鼠，P就是小车，G就是小车里装的砖。

## **GMP模型核心组件**

| 组件              | 说明                     | 特点                                                |
| ----------------- | ------------------------ | --------------------------------------------------- |
| **G (Goroutine)** | 轻量级用户态线程         | 初始栈大小2KB，可动态扩展，由Go调度器管理，非OS线程 |
| **M (Machine)**   | 操作系统线程（内核线程） | OS线程， 与P绑定后执行G的代码                       |
| **P (Processor)** | 逻辑处理器（上下文）     | 维护本地G队列                                       |

---

## **GMP调度流程**
1. **创建Goroutine**  
   - 新G优先加入当前P的本地队列（LRQ）
   - 若LRQ已满，则将一半G转移到全局队列（GRQ）

2. **M获取P执行G**  
   - M必须绑定P才能执行G
   - 若本地队列无G，依次从以下位置获取：  
     a. 全局队列（GRQ）  
     b. 网络轮询器（netpoller）  
     c. 其他P的本地队列（work-stealing）

3. **阻塞处理**  
   - **系统调用阻塞**：M与P解绑，M进入阻塞状态，P寻找空闲M或创建新M
   - **IO/Channel阻塞**：G进入等待队列，M继续执行其他G

4. **抢占式调度**  
   - 监控线程`sysmon`检测运行超过10ms的G，触发抢占

---

## 抢占机制的核心流程
- sysmon 监控 goroutine 的运行时间 。
- 检测到超时后，发送抢占信号 。
- 线程（M）接收信号，暂停当前 goroutine 的执行 。
- 保存 goroutine 的执行上下文 。
- 调度器将 goroutine 放入队列，线程切换到其他 goroutine 。
- 抢占后的 goroutine 会在后续被重新调度执行 。


## **GMP设计优势**
| 特性              | 说明                                  | 收益               |
| ----------------- | ------------------------------------- | ------------------ |
| **复用线程（M）** | 通过P池管理M，避免频繁创建/销毁OS线程 | 减少内核态切换开销 |
| **Work-Stealing** | 空闲P从其他P偷取G                     | 提高CPU利用率      |
| **Hand Off机制**  | 当M阻塞时释放P给其他M使用             | 避免CPU空转        |
| **Netpoller集成** | 基于epoll/kqueue实现非阻塞IO          | 高并发IO处理能力   |

---

### 1. Goroutine和线程的区别？
- **资源消耗**：Goroutine初始栈2KB（可扩），线程MB级
- **调度方式**：Goroutine由Go运行时调度（用户态），线程由OS调度（内核态）
- **切换成本**：Goroutine切换约100ns，线程切换微秒级

### 2. 为什么需要P（Processor）？
- **降低锁竞争**：每个P维护本地G队列，减少全局队列的锁争用
- **资源控制**：通过`GOMAXPROCS`限制并行执行的M数量，避免过度消耗系统资源

### 3. 当Goroutine发生系统调用时，调度器如何处理？
- M与P解绑，M进入阻塞状态等待系统调用返回
- P会被分配给其他空闲M（或新建M），继续执行其他G
- 系统调用结束后，M尝试获取P，若失败则将G放回全局队列，自身进入休眠

### 4. 什么是Work-Stealing？
- 当P的本地队列为空时，优先从全局队列获取G
- 若全局队列为空，则随机从其他P的本地队列偷取一半的G




