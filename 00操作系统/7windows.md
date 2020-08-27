## windows

- 查看TCP连接数
```bash
# 查看ESTABLISHED数量
netstat -na -p tcp | find "ESTABLISHED" /c

# 查看TIME_WAIT数量
netstat -na -p tcp | find "TIME_WAIT" /c
```