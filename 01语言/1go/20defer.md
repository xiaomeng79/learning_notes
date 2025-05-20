# defer

## 核心结构
每个函数的 defer 语句都会存储在 _defer 结构体 中，并且与 goroutine 绑定。
```go
// _defer 结构体本质上是一个 单向链表
type _defer struct {
    sp    uintptr  // 栈指针（保存 `defer` 发生时的栈状态）
    pc    uintptr  // 程序计数器（用于执行 `defer` 时的跳转）
    fn    *funcval // `defer` 指向的函数
    link  *_defer  // 链接下一个 `defer` 形成链表
}
```

## 执行
后进先出
defer 在 return 后执行 ，但函数的最终返回发生在所有 defer 执行完毕之后。

## 性能影响
- 高频调用、循环中的 defer 可能影响性能，需谨慎使用。
- Go 1.14+ 优化了 defer，一般情况下性能影响较小。