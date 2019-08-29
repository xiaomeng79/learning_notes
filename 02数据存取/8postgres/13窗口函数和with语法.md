## 窗口函数和with语法


#### 窗口函数


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

