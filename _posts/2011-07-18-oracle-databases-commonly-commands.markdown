---
author: pandao
comments: false
date: 2011-07-18 05:21:40+00:00
layout: post
slug: oracle-databases-commonly-commands
title: oracle数据库时常用的操作命令
thread: 54
categories:
- database
---

最近遇到一个使用了oracle数据库的服务器,我发现oracle操作起来真是太麻烦,为了兄弟们以后少走些弯路,我把入侵当中必需的命令整理出来。

	1、su – oracle 不是必需，适合于没有DBA密码时使用，可以不用密码来进入sqlplus界面。
	2、sqlplus /nolog 或sqlplus system/manager 或./sqlplus system/manager@ora9i;
	3、SQL>connect / as sysdba ;（as sysoper）或
	connect internal/oracle AS SYSDBA ;(scott/tiger)
	conn sys/change_on_install as sysdba;
	4、SQL>startup; 启动数据库实例
	5、 查看当前的所有数据库: select * from v$database;
	select name from v$database;
	desc v$databases; 查看数据库结构字段
	7、怎样查看哪些用户拥有SYSDBA、SYSOPER权限:
	SQL>select * from V_$PWFILE_USERS;
	Show user;查看当前数据库连接用户
	8、进入test数据库：database test;
	9、查看所有的数据库实例：select * from v$instance；
	如：ora9i
	10、查看当前库的所有数据表：
	SQL> select TABLE_NAME from all_tables;
	select * from all_tables;
	SQL> select table_name from all_tables where table_name like ‘u’;
	TABLE_NAME———————————————default_auditing_options
	11、查看表结构：desc all_tables;
	12、显示CQI.T_BBS_XUSER的所有字段结构：
	desc CQI.T_BBS_XUSER;
	13、获得CQI.T_BBS_XUSER表中的记录：
	select * from CQI.T_BBS_XUSER;
	14、增加数据库用户：(test11/test)
	create user test11 identified by test default tablespace users Temporary TABLESPACE Temp;
	15、用户授权:
	grant connect,resource,dba to test11;
	grant sysdba to test11;
	commit;
	16、更改数据库用户的密码：(将sys与system的密码改为test.)
	alter user sys indentified by test;
	alter user system indentified by test;
