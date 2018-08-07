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