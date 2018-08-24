#### 一个简单的文件系统

```  
    #使用默认的defaultServeMux
	http.Handle("/c/",http.StripPrefix("/c/",http.FileServer(http.Dir("/home/meng/a"))))
	log.Println("Listening...")
	http.ListenAndServe(":3000",nil)
	
```

#### 页面跳转

```  
	th := http.RedirectHandler("https://www.baidu.com",307)
	http.Handle("/r",th)
	log.Println("Listening...")
	http.ListenAndServe(":3000",nil)
	
```

#### http 库的 Handler，HandlerFunc 和 ServeHTTP 的关系

```go

type Handler interface {
    ServeHTTP(ResponseWriter, *Request)
}

type HandlerFunc func(ResponseWriter, *Request)

func (f HandlerFunc) ServeHTTP(w ResponseWriter, r *Request)
    f(w, r)
}

```