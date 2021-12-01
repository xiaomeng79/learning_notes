# WebRTC

## 资料

- [webrtcforthecurious](https://webrtcforthecurious.com/)
- [webrtc.org](https://webrtc.org/)
- [samples](https://github.com/webrtc/samples) 示例代码
- [WebRTC-tutorial](https://github.com/Tinywan/WebRTC-tutorial) 示例代码
  
## 概念

Web Real Time Communication :网络实时通信

## 功能

- 获取音频和视频
- 进行音频和视频和任意数据的**点对点**通信

## 私有ip如何发现对方

- 使用 ICE (Interactive Connecctivity Establishment, 交互式连接建立) 机制建立网络连接，ICE 不是一种协议，而是整合了 STUN 和 TURN 两种协议的框架。
- STUN（Sesssion Traversal Utilities for NAT, NAT 会话穿越应用程序），它允许位于 NAT（或多重 NAT）后的客户端找出自己对应的公网 IP 地址和端口，也就是俗称的P2P“打洞”。
- 无法打洞成功。这时候 TURN 就派上用场了，TURN（Traversal USing Replays around NAT）是 STUN/RFC5389 的一个拓展协议在其基础上添加了 Replay(中继)功能。
  
## 数据安全传输

- 数据传输层加密协议(DTLS)：是TLS的兄弟，不过是使用UDP传输。
- 安全实时传输协议(SRTP)：专门为安全地交换媒体而设计的。

## 其他

- [pion](https://github.com/pion/pion) go实现的webrtc
- [coturn](https://github.com/coturn/coturn) stun和turn服务
- [janus-gateway](https://github.com/meetecho/janus-gateway) 通用webrtc服务器
