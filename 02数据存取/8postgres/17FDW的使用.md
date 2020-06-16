## FDW的使用

[pgspider](https://github.com/pgspider/pgspider)

#### 一些镜像
[](./fdw_dockerfile/README.md)

- 查看可以使用的拓展
```sql
select * from pg_available_extensions
```

- 查看正在使用的拓展
```bash
postgres=# \dx
                   List of installed extensions
   Name    | Version |   Schema   |          Description           
-----------+---------+------------+--------------------------------
 plpgsql   | 1.0     | pg_catalog | PL/pgSQL procedural language
 redis_fdw | 1.0     | public     | foreign-data wrapper for Redis

```