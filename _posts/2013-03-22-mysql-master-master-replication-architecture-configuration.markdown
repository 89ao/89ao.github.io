---
author: pandao
comments: false
date: 2013-03-22 08:51:10+00:00
layout: post
slug: mysql-master-master-replication-architecture-configuration
title: Mysql主主复制构架配置
thread: 189
categories:
- database
---

# 









　　MySQL主主复制结构区别于主从复制结构。在主主复制结构中，两台服务器的任何一台上面的数据库存发生了改变都会同步到另一台服务器上，这样两台服务器互为主从，并且都能向外提供服务。 这就比使用主从复制具有更好的性能。
接下来我将使用两个同样的服务器来实现这个效果：
具体Mysql的安装我就省略了，在上一篇的Mysql的主从架构的配置中有详细介绍
server1_mysql：192.168.1.108
server2_mysql: 192.168.1.110
拓扑结构：
server1_mysql-------server2_mysql
**1.创建用户并授权**
server1:




















`　　mysql> GRANT REPLICATION SLAVE ON *.* TO ``'server2'``@``'192.168.1.110'` `IDENTIFIED BY ``'server2'``;`














server2:




















`　　mysql> GRANT REPLICATION SLAVE ON *.* TO ``'server1'``@``'192.168.1.108'` `IDENTIFIED BY ``'server1'``;`














**2.修改Mysql的主配置文件**
server1:




















`　　[mysqld] `




`　　server-id = 10 `




`　　log-bin = mysql-bin `




`　　replicate-``do``-db = mydb `




`　　auto-increment-increment = 2   ``//每次增长2 `




`　　auto-increment-offset = 1  ``//设置自动增长的字段的偏移量，即初始值为1`














启动Mysql服务：
# service mysqld restart
server2:




















`　　[mysqld] `




`　　server-id = 20 `




`　　log-bin = mysql-bin `




`　　replicate-``do``-db = mydb `




`　　auto-increment-increment = 2  ``//每次增长2 `




`　　auto-increment-offset = 2 ``//设置自动增长的字段的偏移量，即初始值为2`














启动Mysql服务：
# service mysqld restart
注：二都只有server-id不同和 auto-increment- offset不同
auto-increment-increment的值应设为整个结构中服务器的总数，本案例用到两
台服务器，所以值设为2。
**3.重新启动两个服务器**
# service mysqld restart
4.为了让两个数据库一样，我们备份其中一个数据库，然后在另一个数据库上恢
复，这样是两个数据库一开始都是一样的。
在server1上操作：




















`　　# mysqldump --databases luowei > /tmp/luowei.sql`














在server2上操作：
创建一个与mydb同名的空数据库




















`　　# mysql `




`　　> CREATE DATABASE mydb; `




`　　>\q `




`　　# scp 192.168.1.108:/tmp/mydb.sql  ./ `




`　　# mysql -uroot -p mydb < /tmp/luowei.sql`














**5.然后两个服务器相互通告二进制日志的位置并启动复制功能**：
在server1上：




















`　　# mysql `




`　　> CHANGE MASTER TO `




`　　> MASTER_HOST=``'192.168.1.110'``, `




`　　> MASTER_USER=``'server2'``, `




`　　> MASTER_PASSWORD=``'server2'``; `




`　　mysql > START SLAVE;`














在server2上：




















`　　# mysql `




`　　> CHANGE MASTER TO `




`　　> MASTER_HOST=``'192.168.1.108'``, `




`　　> MASTER_USER=``'server1'``, `




`　　> MASTER_PASSWORD=``'server1'``; `




`　　mysql > START SLAVE;`














**　6.查看，并验证：**
分别在两个数据库服务器上查看
mysql > START SLAVE;
然后查看数据库和表，你会发现内容是一样的，这样就是整个主主Mysql的架构的配置过程。





