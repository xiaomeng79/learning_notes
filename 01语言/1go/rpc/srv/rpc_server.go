package main

import (
	"net/rpc"
	"net"
	"log"
)

type HelloService struct {

}

//其中Hello方法必须满足Go语言的RPC规则：方法只能有两个可序列化的参数，其中第二个参数是指针类型，并且返回一个error类型，同时必须是公开的方法。

func (p *HelloService) Hello(request string,reply *string) error {
	*reply = "hello:" + request
	return nil
}


func main() {
	//rpc.Register函数调用会将对象类型中所有满足RPC规则的对象方法注册为RPC函数，所有注册的方法会放在“HelloService”服务空间之下
	rpc.RegisterName("HelloService",new(HelloService))
	listener, err := net.Listen("tcp",":1234")
	if err != nil {
		log.Fatal("listener error:",err)
	}
	for {
		conn,err := listener.Accept()
		if err != nil {
			log.Fatal("accept error:",err)
		}
		go rpc.ServeConn(conn) //默认使用gob编码
		//go rpc.ServeCodec(jsonrpc.NewServerCodec(conn)) //使用json编解码器
	}
}


/*
//http 版本
//调用方法：
//curl localhost:1234/jsonrpc -X POST --data '{"method":"HelloService.Hello","params":["hello"],"id":0}'
func main() {
	rpc.RegisterName("HelloService", new(HelloService))
	http.HandleFunc("/jsonrpc", func(w http.ResponseWriter, r *http.Request) {
		var conn io.ReadWriteCloser = struct {
			io.Writer
			io.ReadCloser
		}{
			ReadCloser: r.Body,
			Writer:     w,
		}

		rpc.ServeRequest(jsonrpc.NewServerCodec(conn))
	})

	http.ListenAndServe(":1234", nil)
}
*/
