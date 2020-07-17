## nfs安装

#### ubuntu18.04安装
[安装教程](https://www.linuxidc.com/Linux/2018-11/155331.htm)
[选项说明](https://www.cnblogs.com/lykyl/archive/2013/06/14/3136921.html)
```bash
# 安装服务
sudo apt install nfs-kernel-server
# 创建共享目录
sudo mkdir -p /mnt/linuxidc
# 设置目录权限(所有客户端都能访问该目录)
sudo chown nobody:nogroup /mnt/linuxidc
sudo chmod 777 /mnt/linuxidc
# 设置导出
sudo vim /etc/exports
# /mnt/linuxidc   *(rw,sync,no_subtree_check,no_root_squash) # *号代表任意客户端
# /mnt/linuxidc   192.168.10.0/24(rw,sync,no_subtree_check,no_root_squash) # *号代表任意客户端
# 重启服务
sudo systemctl restart nfs-kernel-server
# 开启访问防火墙
sudo ufw allow from 192.168.182.0/24 to any port nfs
# 查看服务状态
nfsstat
# 查询nfs共享目录信息 -a 显示已经于客户端连接上的目录信息 -e IP或者hostname 显示此IP地址分享出来的目录
showmount
```