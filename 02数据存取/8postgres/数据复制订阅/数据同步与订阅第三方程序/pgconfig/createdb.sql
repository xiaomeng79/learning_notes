-- 创建数据库
create database test with template template0 lc_collate "zh_CN.UTF8" lc_ctype "zh_CN.UTF8" encoding 'UTF8';
\c test

-- 增加
CREATE TABLE public.student
(
    id serial PRIMARY KEY NOT NULL,
    name varchar(50) DEFAULT '' NOT NULL,
    version varchar(20) DEFAULT '0.0.0' NOT NULL
);
COMMENT ON COLUMN public.sys_info.name IS '名称';
COMMENT ON COLUMN public.sys_info.version IS '版本号';
COMMENT ON TABLE public.sys_info IS '学生信息表';

-- 添加
INSERT INTO public.student(name,version) values('student01','0.0.0');
