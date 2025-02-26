# Map

- [map底层](https://zhuanlan.zhihu.com/p/616979764)

## 数据结构有两种：哈希查找表（Hash table）、搜索树（Search tree）
- 哈希查找表用一个哈希函数将 key 分配到不同的桶（bucket，也就是数组的不同 index）。这样，开销主要在哈希函数的计算以及数组的常数访问时间。在很多场景下，哈希查找表的性能很高。
- 哈希查找表一般会存在“碰撞”的问题，就是说不同的 key 被哈希到了同一个 bucket。一般有两种应对方法：链表法和开放地址法。链表法将一个 bucket 实现成一个链表，落在同一个 bucket 中的 key 都会插入这个链表。开放地址法则是碰撞发生后，通过一定的规律，在数组的后面挑选“空位”，用来放置新的 key。
- 搜索树法一般采用自平衡搜索树，包括：AVL 树，红黑树
- Go 语言采用的是哈希查找表，并且使用链表解决哈希冲突。

## 底层结构
​hmap：管理整个map的元数据
```go
type hmap struct {
  count     int              // 存储的键值对数目
  flags     uint8            // 状态标志（是否处于正在写入的状态等）
  B         uint8            // 桶的数目 2^B
  noverflow uint16           // 使用的溢出桶的数量
  hash0     uint32           // 生成hash的随机数种子

  buckets    unsafe.Pointer  // bucket数组指针，数组的大小为2^B（桶）
  oldbuckets unsafe.Pointer  // 扩容时保存旧桶的指针
  nevacuate  uintptr         // 扩容时下一个待迁移的旧桶索引
  extra *mapextra            // 指向mapextra结构体里边记录的都是溢出桶相关的信息
}
```

bmap（桶）​：每个桶存储最多8个键值对及溢出指针。实际结构中，键和值分开存储以优化内存：
```go
type bmap struct {
    topbits [8]uint8    // 哈希值的高8位，用于快速比对
    keys    [8]keytype  // 键数组
    values  [8]valuetype // 值数组（与键分开存储，减少填充）
    overflow *bmap      // 溢出桶指针
}
```
## 扩容

#### 触发条件
- 负载因子过高：元素数量 > 6.5 * 桶数量（默认负载因子为6.5）。
- 溢出桶过多：溢出桶数量 ≥ 桶数量时，触发等量扩容（不增加大小，仅整理溢出桶）。

#### 扩容类型
- 增量扩容：桶数量翻倍（B+1），重新分配元素。
- 等量扩容：桶数量不变，优化溢出桶分布。

#### map扩容时使用渐进式扩容
- 不会一次性搬迁完毕，每次搬迁 1-2 个 oldbucket。
- 只有在插入或修改、删除 key 的时候，迁移。

### 并发安全

- 非并发安全：`map` 内部无锁机制，并发读写会导致 `panic`。
- 解决方案：使用 `sync.RWMutex` 或 `sync.Map`（高并发读场景）。

### 性能优化
- 内存布局：键和值分开存储（如 `keys` 和 `values` 数组），减少内存填充。
- 快速比对：通过 `topbits` 快速过滤不匹配的键。
- 预分配优化：通过 `make(map, hint)` 预设大小，减少扩容次数。


## map 遍历无序
- 一个随机值序号的bucket，再从其中随机的cell开始遍历。
- map在扩容后，会发生key的搬迁。

## key 定位过程
key 经过哈希计算后得到哈希值，共 64 个 bit 位，计算它到底要落在哪个桶时，只会用到最后 B 个 bit 位。还记得前面提到过的 B 吗？如果 B = 5，那么桶的数量，也就是 buckets 数组的长度是 2^5 = 32。
```shell
# 最后的 5 个 bit 位,确定放到那个桶，哈希值的高 8 位，找到此 key 在 bucket 中的位置。
 10010111 | 000011110110110010001111001010100010010110010101010 │ 01010
```

## `sync.Map` 底层详解

### 核心数据结构
`sync.Map` 通过分离读写数据实现高效并发访问，主要结构如下：

```go
type Map struct {
    mu     sync.Mutex         // 保护 dirty 的互斥锁
    read   atomic.Value       // 存储只读数据（readOnly 结构）
    dirty  map[interface{}]*entry // 可读写数据，需加锁访问
    misses int                // read 未命中次数
}

type readOnly struct {
    m       map[interface{}]*entry // 只读键值对（无锁访问）
    amended bool                   // 标记 dirty 包含 read 中不存在的键
}

type entry struct {
    p unsafe.Pointer // 指向实际值（或标记为 expunged/nil）
}
```

### 核心设计思想

#### 分离读写操作
- ​**read**​  
  通过原子操作实现无锁读，存储高频访问的键值对。
- ​**dirty**​  
  存储低频或新增的键值对，访问时需要加锁。
- ​**amended 标记**​  
  当 dirty 包含 read 中没有的键时，标记为 true。

### entry 的状态管理
- ​**正常状态**​  
  `p` 指向实际值。
- ​**标记为删除**​  
  `p` 设置为 nil（逻辑删除）。
- ​**标记为已清除**​  
  `p` 设置为 expunged（防止重复写入）。
