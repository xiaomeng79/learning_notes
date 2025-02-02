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

表示OS线程，`它是由OS管理的可执行程序的一个线程`，而且工作起来特别像你的标准POSIX线程。在运行时代码里，它被成为M，即机器（machine）。

>| m0 是Go Runtime所创建的第一个系统线程，一个Go进程只有一个 m0，也叫主线程。

### P(process):处理器,调度上下文

表示用于调用的上下文。你可以把它看作在一个单线程上运行代码的调度器的一个本地化版本。它是让我们从N：1调度器转到M：N调度器的重要部分。在运行时代码里，它被叫做P，即处理器（processor）。

### GMP模型
M代表一个工作线程，在M上有一个P和G，P是绑定到M上的，G是通过P的调度获取的，在某一时刻，一个M上只有一个G（g0除外）。在P上拥有一个G队列，里面是已经就绪的G，是可以被调度到线程栈上执行的协程，称为运行队列。

### 为什么需要多个P

1. 因为当一个M0被阻塞,P可以转而投奔另外的M1
2. 当M0处理完返回时,它必须尝试取得一个context P来运行goroutine，一般情况下，它会从其他的OS线程那里steal偷一个context过来
3. 如果没有偷到的话，它就把goroutine放在一个global runqueue里，然后自己就去睡大觉了（放入线程缓存里）。Contexts们也会周期性的检查global runqueue，否则global runqueue上的goroutine永远无法执行。
4. P所分配的任务G很快就执行完了（分配不均），这就导致了一个上下文P闲着没事儿干而系统却任然忙碌。但是如果global runqueue没有任务G了，那么P就不得不从其他的上下文P那里拿一些G来执行。一般来说，如果上下文P从其他的上下文P那里要偷一个任务的话，一般就‘偷’run queue的一半，这就确保了每个OS线程都能充分的使用



### 总结
![搬砖](https://pic1.zhimg.com/80/v2-e368c077748ac049336b8efaf06753f8_hd.png)

地鼠(gopher)用小车运着一堆待加工的砖。M就可以看作图中的地鼠，P就是小车，G就是小车里装的砖。一图胜千言啊

Go程序中没有语言级的关键字让你去创建一个内核线程，你只能创建goroutine，内核线程只能由runtime根据实际情况去创建。runtime什么时候创建线程？以地鼠运砖图来讲，砖(G)太多了，地鼠(M)又太少了，实在忙不过来，刚好还有空闲的小车(P)没有使用，那就从别处再借些地鼠(M)过来直到把小车(p)用完为止。这里有一个地鼠(M)不够用，从别处借地鼠(M)的过程，这个过程就是创建一个内核线程(M)


