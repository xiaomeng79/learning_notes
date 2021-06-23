## Service

### type

[k8s四种port解析](https://blog.csdn.net/a772304419/article/details/113447005)

- nodePort:


### kube-proxy模式

- ip-tables模式：当service或者endpoints、pod发生变化时，kube-proxy会创建对应的iptables规则。
- Userspace模式：这种模式时最早的，不过已经不推荐使用了，效率低，因为需要在内核态和用户态多次转换。
- IPVS代理模式：当service有成千上万个的时候速度上会更占优势。而且有更多的lb策略。

