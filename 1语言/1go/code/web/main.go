package main

import (
	"net/http"
	"log"
)

//实现一个httpHandleFunc
func test(w http.ResponseWriter,r *http.Request) {
	w.Write([]byte("hello"))
}

//实现一个日志中间件
func logMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter,r *http.Request) {
		log.Println("start request")
		next.ServeHTTP(w,r)
	})
}

//使用net/http实现web服务
func main() {

	//http.Handle("/test",http.HandlerFunc(test)) //将http.Handler 转换为http.HandlerFunc

	http.Handle("/test",logMiddleware(http.HandlerFunc(test)))//引用中间件
	http.ListenAndServe(":8889",nil)

}


//http 库的 Handler，HandlerFunc 和 ServeHTTP 的关系：

//type Handler interface {
//	ServeHTTP(ResponseWriter, *Request)
//}
//
//type HandlerFunc func(ResponseWriter, *Request)
//
//func (f HandlerFunc) ServeHTTP(w ResponseWriter, r *Request)
//f(w, r)
//}
