## 窗口函数和with语法


#### 窗口函数
[窗口函数](http://www.postgres.cn/docs/10/functions-window.html)
[网上例子](https://www.cnblogs.com/funnyzpc/p/9311281.html)

#### 自定义函数(存储过程)

1. 创建函数
```sql
CREATE [OR REPLACE] FUNCTION function_name (arguments) 
RETURNS return_datatype AS $variable_name$
  DECLARE
    declaration;
    [...]
  BEGIN
    < function_body >
    [...]
    RETURN { variable_name | value }
  END; LANGUAGE plpgsql;  
```

#### with语法

```sql

with recursive skip as (
select out_person_id,in_person_id,call_relation from person_relation where in_person_id=1 and call_relation in (2,4)
union  
select pr.out_person_id,pr.in_person_id,pr.call_relation from skip join person_relation pr on pr.in_person_id=skip.out_person_id and pr.call_relation in (2,4)
)
select * from skip;

select out_person_id,in_person_id,call_relation from person_relation where out_person_id=(select in_person_id from skip)


-- 加妻子
with recursive skip as (
select out_person_id,in_person_id,call_relation from person_relation where in_person_id=1 and call_relation in (2,3,5,4)
union  
select pr.out_person_id,pr.in_person_id,pr.call_relation from skip join person_relation pr on pr.in_person_id=skip.out_person_id and pr.call_relation in (2,3,5,4)
)
select * from skip;


insert into person_relation(out_person_id,in_person_id,call_relation) select ceil(random()*10000),ceil(random()*10000),ceil(random()*10) from generate_series(1,2000);
```


#### 窗口函数的测试
```sql
-- 创建表
CREATE TABLE public.mytest (
    user_id integer NOT NULL,
    name character varying(32) DEFAULT ''::character varying NOT NULL,
    account numeric(18,2) DEFAULT 0.00 NOT NULL,
    cat_id integer DEFAULT 0 NOT NULL
); 

-- 生成测试数据
insert into mytest (name,account,cat_id) select md5(random()::text),ceil(random()*1000),ceil(random()*10) from generate_series(1,1000000);


```

