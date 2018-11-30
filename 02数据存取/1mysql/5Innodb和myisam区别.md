## Innodb myisam

[Innodb](https://mp.weixin.qq.com/s?__biz=MjM5ODYxMDA5OQ==&mid=2651961428&idx=1&sn=31a9eb967941d888fbd4bb2112e9602b&chksm=bd2d0d888a5a849e7ebaa7756a8bc1b3d4e2f493f3a76383fc80f7e9ce7657e4ed2f6c01777d&scene=21#wechat_redirect)

- Count(*)

MyISAM会直接存储总行数，InnoDB则不会，需要按行扫描,只有查询全表的总行数，MyISAM才会直接返回结果，当加了where条件后，两种存储引擎的处理方式类似

- 全文索引

MyISAM支持全文索引，InnoDB5.6之前不支持全文索引,不管哪种存储引擎，在数据量大并发量大的情况下,而要使用《[索引外置](https://mp.weixin.qq.com/s?__biz=MjM5ODYxMDA5OQ==&mid=2651959917&idx=1&sn=8faeae7419a756b0c355af2b30c255df&chksm=bd2d07b18a5a8ea75f16f7e98ea897c7e7f47a0441c64bdaef8445a2100e0bdd2a7de99786c0&scene=21#wechat_redirect)》的架构设计方法

- 事务

MyISAM不支持事务，InnoDB支持事务,事务是选择InnoDB非常诱人的原因之一，它提供了commit，rollback，崩溃修复等能力,在系统异常崩溃时，MyISAM有一定几率造成文件损坏，这是非常烦的。但是，事务也非常耗性能，会影响吞吐量，建议只对一致性要求较高的业务使用复杂事务

- 外键

MyISAM不支持外键，InnoDB支持外键,不管哪种存储引擎，在数据量大并发量大的情况下，都不应该使用外键，而建议由应用程序保证完整性。

- 关于行锁与表锁

MyISAM只支持表锁，InnoDB可以支持行锁,InnoDB：细粒度行锁，在数据量大，并发量高时，性能比较优异

>| 注意: InnoDB的行锁是实现在索引上的，而不是锁在物理行记录上。潜台词是，如果访问没有命中索引，也无法使用行锁，将要退化为表锁


