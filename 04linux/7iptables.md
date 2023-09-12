# iptables

## 配置端口转发

- `ununtu`安装iptables`sudo apt-get install iptables`
- 打开包转发功能`echo 1 > /proc/sys/net/ipv4/ip_forward`
- 修改/etc/sysctl.conf文件，让包转发功能在系统启动时自动生效`net.ipv4.ip_forward = 1`
- 打开iptables的NAT功能`/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`,eth0是外网卡
- 查看路由表`netstat -rn 或 route -n`
- 查看iptables规则`iptables -t nat -nL --line`，不用 -t 指定表名默认的是指 filter 表
- 配置端口转发`iptables -t nat -A PREROUTING -p tcp --dport 30001:30100 -j REDIRECT --to-port 8080`
- 说明：PREROUTING链修改的是从外部连接过来时的转发，如果本机连接到本机的转发，需要修改 OUTPUT链。`iptables -t nat -A OUTPUT -p tcp --dport 7777 -j REDIRECT --to-port 6666`
- 保存`sudo iptables-save > /etc/iptables-rules`
- vim /etc/network/interfaces 找到 eth0 那一节，在对 eth0 的设置最末尾加上下面这句：`pre-up iptables-restore < /etc/iptables-rules`


## 不同网段跳转
A服务器：192.168.30.20/24
B服务器：192.168.30.1/24,eth0;  192.168.40.1/24,eth1
C服务器：192.168.40.20/24
目标：让A可以ping和ssh到c机器。这就需要通过B服务器来跳转。
操作过程：
- 在B服务器上开启内核路由转发参数
临时生效：echo "1" > /proc/sys/net/ipv4/ip_forward
永久生效的话，需要修改sysctl.conf：net.ipv4.ip_forward = 1
执行sysctl -p马上生效
- B服务器开启iptables nat转发
iptables  -t nat  -A POSTROUTING  -s 192.168.30.0/24 -d 192.168.40.0/24 -o eth1 -j  MASQUERADE
配置源地址30网段，目标地址40网段的地址转换，从eth1网卡出。
iptables -t nat -A POSTROUTING -s 192.168.40.0/24  -d 192.168.30.0/24 -o eth0 -j MASQUERADE
配置源地址40网段，目标地址30网段的地址转换，从eth0网卡出。
永久保存：iptables-save > /etc/sysconfig/iptables
TIP：注意对应网卡。
- 在A和C服务器上设置路由为B服务器IP
A:  route add -net 192.168.40.0 netmask 255.255.255.0 gw 192.168.30.1
C: route add -net 192.168.30.0 netmask 255.255.255.0 gw 192.168.40.1