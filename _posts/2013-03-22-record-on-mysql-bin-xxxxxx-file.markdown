---
author: pandao
comments: false
date: 2013-03-22 03:57:10+00:00
layout: post
slug: record-on-mysql-bin-xxxxxx-file
title: 关于mysql-bin.xxxxxx文件的记录
thread: 187
categories:
- database
---

昨天同事的业务监控平台全挂掉了，程序起来就卡死，经检查之后排除了网络和系统的原因，考虑可能是数据库问题，到数据库服务上重启mysql果然起不来，一直卡死在那里，由于库文件不大，所以本来准备备份数据然后换个机器先把服务起起来的，但是一看mysql的安装目录居然有1.2个T，进去之后发现有很多文件mysql-bin.000001  …  mysql-bin.000023   mysql-bin.index ，所以硬盘被塞满，导致mysql起不来，于是临时解决方案删除了部分文件解决，注意：mysql-bin.index不能删，会导致mysql起不来。

过了2天我又上服务器检查，发现又生成了3个mysql-bin.xxxx文件，这样老是人工来删除岂不是很蛋疼，搜索查询之后，找到一个方法可以修改配置文件解决：

编辑配置文件/etc/my.cnf，添加或修改如下配置

log-bin=/var/lib/mysql/binlogs/mysql-bin
max_binlog_size=100M
expire_logs_days=5
sync_binlog=1
binlog_cache_size=1M
binlog-format=ROW

关键参数是max_binlog_size指定日志最大大小，expire_log_days指定日志过期时间(天)，binlog_cache_size指定缓存文件大小。

当然，my.cnf中去掉log-bin就可不让生成这些日志文件了。

于是修改配置文件，观察一段时间吧。

关于my.cnf中各参数的作用可以查询相关文章找到，稍后我会转一个详解上来。

附，mysql中与日志有关的命令：

    
    1 查询musql-bin,mysql操作日志
    mysql> show master logs;
    2 删除,保留最新
    mysql>purge master logs to ‘mysql-bin.00001′;



    
    第二种技巧：
    清理mysql的日志文件
    mysql> reset master;
    可以清理这些文件。
