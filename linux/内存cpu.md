- 查看进程使用内存

```
ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' | grep dist_game |  sort -nrk5
#其中rsz为实际内存，上例实现按内存排序，由大到小
```
