## mysql


### 协成不能使用事务

>| [Golang+MySQL 事务](https://www.tuicool.com/articles/7feY3mB)

1. tx会从连接池中取一个空闲的连接，直至调用 commit 或者 rollback 才会释放

2. 事务只有 一个连接 ，事务内的操作是 串行 的

3. tx执行完 Query 方法之后，连接转移到 rows 上，在 Next 方法中， tx.QueryRow 将尝试获取该连接进行操作。因为还没有调用 rows.Close() ，因此连接还处于 busy 状态， tx 无法进行 QueryRow 操作。这时候使用 JOIN 语句可以规避这个问题。

```mysql
rows, _ := tx.Query("SELECT id FROM tt_users")

for rows.Next(){
    var (
        user_id int
        openid string
    )
    rows.Scan(&user_id)
    tx.QueryRow("SELECT openid FROM tt_users_third WHERE user_id = ?", user_id).Scan(&openid)
}
```

 *这个时候就会报错，buffer busy*


