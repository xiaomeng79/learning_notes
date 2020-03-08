-- 创建数据库
create database test with template template0 lc_collate "zh_CN.UTF8" lc_ctype "zh_CN.UTF8" encoding 'UTF8';
\c test

-- 增加表
CREATE TABLE public.info
(
    id serial PRIMARY KEY NOT NULL,
    name varchar(50) DEFAULT '' NOT NULL
);

