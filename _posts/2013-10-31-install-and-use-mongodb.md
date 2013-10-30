---
layout: post
title: "mongodb安装以及简单使用"
categories:
- MongoDB
tags:
- MongoDB


---

##下载

MongoDB的官网是http://www.mongodb.org/

生产环境中当然要使用stable，在[这里](http://www.mongodb.org/downloads)下载stable版本即可。

本次安装操作系统为rhel6.4，32位。

##开始安装
下载安装包

	cd /usr/local/src  
	wget http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.2.6.tgz  
	tar zxvf mongodb-linux-i686-2.2.6.tgz  
	mv mongodb-linux-i686-2.2.6 /usr/local/mongodb  

##运行

首先创建数据目录和日志目录，实验环境为了方便，我们就安装在本地mongodb目录下。

	[root@localhost src]# cd /usr/local/mongodb/
	[root@localhost mongodb]# ls
	bin  GNU-AGPL-3.0  README  THIRD-PARTY-NOTICES
	[root@localhost mongodb]# mkdir -p data/mongodb_data
	[root@localhost mongodb]# mkdir -p data/mongodb_log
	[root@localhost mongodb]# ls data/
	mongodb_data  mongodb_log

**运行**

	/usr/local/mongodb/bin/mongod --dbpath=data/mongodb_data/ --logpath=data/mongodb_log/mongodb.log &

这时我们发现日志里面有这一行报警：	

>Thu Oct 31 02:45:36 warning: 32-bit servers don't have journaling enabled by default. Please use --journal if you want durability.
>大意是，32位的mongo服务器默认未开启日志，如果想要开启日志，请加上--journal选项。

所以我们加上--journal选项，命令如下：

	/usr/local/mongodb/bin/mongod --dbpath=data/mongodb_data/ --logpath=data/mongodb_log/mongodb.log --journal &

这时还有一个警告：

>Thu Oct 31 02:47:22 [initandlisten] ** NOTE: when using MongoDB 32 bit, you are limited to about 2 gigabytes of data    
>Thu Oct 31 02:47:22 [initandlisten] **       see http://blog.mongodb.org/post/137788967/32-bit-limitations   
>Thu Oct 31 02:47:22 [initandlisten] **       with --journal, the limit is lower    

大致意思是：32位系统的MongoDB服务器每一个Mongod实例只能使用2G的数据文件。这是由于地址指针只能支持32位。	
所以在生产环境中，尽量使用`64位`的系统。 

在这里检测mongodb是否已经正常运行：

	[root@localhost mongodb]# netstat -nuptl|grep mongo
	tcp        0      0 0.0.0.0:27017               0.0.0.0:*                   LISTEN      1455/mongod         
	tcp        0      0 0.0.0.0:28017               0.0.0.0:*                   LISTEN      1455/mongod

**IPTABLES**

开启mongodb的27017和28017访问：

	iptables -A INPUT -p tcp --dport 27017 -j ACCEPT
	iptables -A INPUT -p tcp --dport 28017 -j ACCEPT
	service iptables save
	

##简单使用examples：

到这里我们的mongodb已经安装完成了，装完了不使用当然没有任何意义，简单的使用范例如下：

**系统操作命令**

切换/创建数据库

	use testDB;  当创建一个集合(table)的时候会自动创建当前数据库

查询所有数据库

	show dbs;

删除当前使用数据库

	db.dropDatabase();

从指定主机上克隆数据库

	db.cloneDatabase(“127.0.0.1”); 将指定机器上的数据库的数据克隆到当前数据库

从指定的机器上复制指定数据库数据到某个数据库

	db.copyDatabase("mydb", "temp", "127.0.0.1");将本机的mydb的数据复制到temp数据库中

查看当前使用的数据库

	db.getName();

显示当前db状态

	db.stats();

当前db版本

	db.version();

查看当前db的链接机器地址

	db.getMongo();

**Collection聚集集合**

创建一个聚集集合（table）

	db.createCollection(“collName”, {size: 20, capped: 5, max: 100});

得到指定名称的聚集集合（table）

	db.getCollection("account");

得到当前db的所有聚集集合

	db.getCollectionNames();

显示当前db所有聚集索引的状态

	db.printCollectionStats();

**用户相关**

添加一个用户

	db.addUser("name");
	db.addUser("userName", "pwd123", true); 添加设置是否只读

数据库安全模式

	db.auth("userName", "123123");

显示当前所有用户

	show users;

删除用户

	db.removeUser("userName");

**记录操作**

查询所有记录

	db.userInfo.find();

查询age = 22的记录

	db.userInfo.find({"age": 22});
	相当于： select * from userInfo where age = 22;

查询age > 22的记录

	db.userInfo.find({age: {$gt: 22}});
	相当于：select * from userInfo where age >22;

查询age < 22的记录

	db.userInfo.find({age: {$lt: 22}});
	相当于：select * from userInfo where age <22;

查询age >= 25的记录

	db.userInfo.find({age: {$gte: 25}});
	相当于：select * from userInfo where age >= 25;

查询age <= 25的记录

	db.userInfo.find({age: {$lte: 25}});

查询age >= 23 并且 age <= 26

	db.userInfo.find({age: {$gte: 23, $lte: 26}});

查询name中包含 mongo的数据

	db.userInfo.find({name: /mongo/});
	//相当于%%
	select * from userInfo where name like ‘%mongo%’;

查询name中以mongo开头的

	db.userInfo.find({name: /^mongo/});
	select * from userInfo where name like ‘mongo%’;

查询指定列naage数据

	db.userInfo.find({}, {name: 1, age: 1});
	相当于：select name, age from userInfo;
	当然name也可以用true或false,当用ture的情况下河name:1效果一样，如果用false就是排除name，显示name以外的列信息。

查询指定列naage数据, age > 25

	db.userInfo.find({age: {$gt: 25}}, {name: 1, age: 1});
	相当于：select name, age from userInfo where age >25;

按照年龄排序

	升序：db.userInfo.find().sort({age: 1});
	降序：db.userInfo.find().sort({age: -1});

查询在5-10之间的数据

	db.userInfo.find().limit(10).skip(5);
	可用于分页，limit是pageSize，skip是第几页pageSize

**集合数据**

添加

	db.users.save({name: ‘zhangsan’, age: 25, sex: true});
	添加的数据的数据列，没有固定，根据添加的数据为准

修改

	db.users.update({age: 25}, {$set: {name: 'changeName'}}, false, true);
	相当于：update users set name = ‘changeName’ where age = 25;

	db.users.update({name: 'Lisi'}, {$inc: {age: 50}}, false, true);
	相当于：update users set age = age + 50 where name = ‘Lisi’;

	db.users.update({name: 'Lisi'}, {$inc: {age: 50}, $set: {name: 'hoho'}}, false, true);
	相当于：update users set age = age + 50, name = ‘hoho’ where name = ‘Lisi’;

删除

	db.users.remove({age: 132});


**索引**

创建索引

	db.userInfo.ensureIndex({name: 1});
	db.userInfo.ensureIndex({name: 1, ts: -1});

查询当前聚集集合所有索引

	db.userInfo.getIndexes();

查看总索引记录大小

	db.userInfo.totalIndexSize();

读取当前集合的所有index信息

	db.users.reIndex();

删除指定索引

	db.users.dropIndex("name_1");

删除所有索引索引

	db.users.dropIndexes();

