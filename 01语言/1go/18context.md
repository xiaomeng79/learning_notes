# Context

## context 的核心作用
- ​传递取消信号：允许父协程或调用链上游主动取消子任务（如超时、用户中断）。
- ​设置截止时间（Deadline）​：为任务设置明确的超时时间。
- ​传递请求作用域数据：在调用链中安全传递与请求相关的数据（如 TraceID、认证信息）。
- ​控制协程生命周期：避免协程泄漏（Goroutine Leak）。

## context.Value 的查找过程是怎样的
- 因为查找方向是往上走的，所以，父节点没法获取子节点存储的值，子节点却可以获取父节点的值。
- 用 Value 方法的时候要判断结果是否为 nil。

## context.Value 的优缺点？
- ​优点：跨层级传递数据无需修改函数签名。
- ​缺点：
    - ​类型不安全：需要类型断言。
    - ​隐式依赖：数据来源不透明，增加维护成本。
    - ​建议：仅用于传递基础设施数据（如 TraceID），而非业务参数。
## 如何避免 context 泄漏？
- 始终调用 defer cancel() 确保资源释放。
- 在子协程中监听 ctx.Done() 信号，及时退出。

## 底层结构
```go
type Context interface {
    Deadline() (deadline time.Time, ok bool)  // 返回截止时间（如有）
    Done() <-chan struct{}                   // 返回取消信号通道
    Err() error                              // 返回取消原因
    Value(key any) any                       // 获取键值对
}

type emptyCtx int

func (*emptyCtx) Deadline() (deadline time.Time, ok bool) { return }
func (*emptyCtx) Done() <-chan struct{}    { return nil }
func (*emptyCtx) Err() error               { return nil }
func (*emptyCtx) Value(key any) any         { return nil }

var (
    background = new(emptyCtx) // context.Background()
    todo       = new(emptyCtx) // context.TODO()
)

type cancelCtx struct {
    Context                // 嵌入父上下文
    mu       sync.Mutex    // 保护以下字段
    done     atomic.Value  // 保存 chan struct{}（懒初始化）
    children map[canceler]struct{} // 子上下文集合
    err      error         // 取消原因（第一次调用 cancel 时设置）
}
type timerCtx struct {
    cancelCtx               // 内嵌 cancelCtx
    timer    *time.Timer    // 定时器
    deadline time.Time      // 绝对截止时间
}

```