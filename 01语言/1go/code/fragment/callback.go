package main

import (
	"fmt"
	"sync"
)

//回调函数类型
type Callback func()

//客户端接口
type IClient interface {
	Register(cbs ...Callback)
	Run()
}

//客户端
type Client struct {
	cbs []Callback
	mu  sync.Mutex
}

//
func NewClient() *Client {
	return &Client{cbs: []Callback{}}
}

//实现注册
func (c *Client) Register(cbs ...Callback) {
	c.mu.Lock()
	c.cbs = append(c.cbs, cbs...)
	c.mu.Unlock()
}

//实现运行
func (c *Client) Run() {
	for _, _cb := range c.cbs {
		_cb()
	}
}

//实现回调类型函数
func a() {
	//fmt.Println("a")
}

func b() {
	//fmt.Println("b")
}

func main() {
	c := NewClient()
	wg := sync.WaitGroup{}
	wg.Add(2000)
	for i := 0; i < 1000; i++ {
		go func() {
			c.Register(a)
			wg.Done()
		}()
	}

	for i := 0; i < 1000; i++ {
		go func() {
			c.Register(b)
			wg.Done()
		}()
	}
	wg.Wait()
	fmt.Println(len(c.cbs))
	c.Run()
}
