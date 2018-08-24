#### unsafe包

参考资料:

**[unsafe包指针](https://www.cnblogs.com/golove/p/5909968.html)**

[unsafe包](https://studygolang.com/articles/6903)

##### 指针类型：

*类型：普通指针，用于传递对象地址，不能进行指针运算。

unsafe.Pointer：通用指针类型，用于转换不同类型的指针，不能进行指针运算。

uintptr：用于指针运算，GC 不把 uintptr 当指针，uintptr 无法持有对象。uintptr 类型的目标会被回收。

　　unsafe.Pointer 可以和 普通指针 进行相互转换。
　　unsafe.Pointer 可以和 uintptr 进行相互转换。

　　也就是说 unsafe.Pointer 是桥梁，可以让任意类型的指针实现相互转换，也可以将任意类型的指针转换为 uintptr 进行指针运算。


　　结构体成员的内存分配是连续的，第一个成员的地址就是结构体的地址，相对于结构体的偏移量为 0。其它成员都可以通过偏移量来计算其地址。

　　每种类型都有它的大小和对齐值，可以通过 unsafe.Sizeof 获取其大小，通过 unsafe.Alignof 获取其对齐值，通过 unsafe.Offsetof 获取其偏移量。不过 unsafe.Alignof 获取到的对齐值只是该类型单独使用时的对齐值，不是作为结构体字段时与其它对象间的对齐值，这里用不上，所以需要用 unsafe.Offsetof 来获取字段的偏移量，进而确定其内存地址。


```go
package main

import (
    "fmt"
    "unsafe"
)

func main() {
    a := [4]int{0, 1, 2, 3}
    p1 := unsafe.Pointer(&a[1])
    p3 := unsafe.Pointer(uintptr(p1) + 2 * unsafe.Sizeof(a[0]))
    *(*int)(p3) = 6
    fmt.Println("a =", a) // a = [0 1 2 6]

    // ...

    type Person struct {
        name   string
        age    int
        gender bool
    }

    who := Person{"John", 30, true}
    pp := unsafe.Pointer(&who)
    pname := (*string)(unsafe.Pointer(uintptr(pp) + unsafe.Offsetof(who.name)))
    page := (*int)(unsafe.Pointer(uintptr(pp) + unsafe.Offsetof(who.age)))
    pgender := (*bool)(unsafe.Pointer(uintptr(pp) + unsafe.Offsetof(who.gender)))
    *pname = "Alice"
    *page = 28
    *pgender = false
    fmt.Println(who) // {Alice 28 false}
}
```