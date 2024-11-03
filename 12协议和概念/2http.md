# HTTP

## HTTP 1.0

- 无状态、无连接

## HTTP 1.1

- 持久连接
- 请求管道化
- 增加缓存处理（新的字段如cache-control）
- 增加Host字段、支持断点传输等

### 为了解决性能做的努力（浏览器限制））

- 多张小图合并成一张大图
- 图片内联到css或者html中
- webpack打包，将多个js文件合并成一个大的js文件
- 分片，使用不同的域名加载资源

## HTTP 2.0

[参考](https://blog.csdn.net/zhuyiquan/article/details/69257126)

- 二进制分帧
- 多路复用（或连接共享）
- 头部压缩
- 服务器推送
- 请求优先级

## HTTPS

[参考](https://www.jianshu.com/p/b0b6b88fe9fe)

![图片](https://upload-images.jianshu.io/upload_images/2829175-9385a8c5e94ad1da.png)

### tls1.2 tls1.3

[区别](http://www.ituring.com.cn/article/444159)

tls1.3解决的问题

1. 减少握手延迟
2. 加密更多的握手
3. 删除一些有安全性的功能
