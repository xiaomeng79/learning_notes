package main

import (
	"net/rpc"
	"log"
	"fmt"
)

func main() {
	conn, err := rpc.Dial("tcp","localhost:1234")
	if err != nil {
		log.Fatal("dialing:",err)
	}
	//client := rpc.NewClientWithCodec(jsonrpc.NewClientCodec(conn)) //使用json编码的客户端
	var reply string
	err = conn.Call("HelloService.Hello","hello",&reply)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(reply)
}
