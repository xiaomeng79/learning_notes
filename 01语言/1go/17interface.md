# Interface

## iface 和 eface的区别
iface 和 eface 都是 Go 中描述接口的底层结构体，区别在于 iface 描述的接口包含方法，而 eface 则是不包含任何方法的空接口：interface{}

## iface
```go
type iface struct {
    tab  *itab           // 接口类型和方法表
    data unsafe.Pointer // 指向实际数据的指针
}
type itab struct {
    inter  *interfacetype // 接口的类型信息
    _type  *_type          // 动态类型（具体类型的元信息）
    link   *itab
    hash   uint32 // 类型哈希值（用于类型断言）
    bad    bool   // type does not implement interface
    inhash bool   // has this itab been added to hash?
    unused [2]byte
    fun    [1]uintptr // 方法地址数组（动态派发入口）
}
```
- iface包含两个字段：tab 是接口表指针，指向类型信息；data 是数据指针，则指向具体的数据。它们分别被称为动态类型和动态值。而接口值包括动态类型和动态值。
- 其中 itab 由具体类型 _type 以及 interfacetype 组成。_type 表示具体类型，而 interfacetype 则表示具体类型实现的接口类型。

## eface

```go
type eface struct {
    _type *_type
    data  unsafe.Pointer
}
```
- 只维护了一个 _type 字段，表示空接口所承载的具体的实体类型。data 描述了具体的值。

### 注意点
- ​​接口定义​​：明确方法签名，确保实现类型完全匹配
- ​​nil处理​​：区分接口变量为nil还是动态值为nil。
- ​​空接口慎用​​：优先使用具体类型，必要时配合类型断言。
- ​​类型安全​​：通过编译检查和运行时断言保障逻辑正确性。