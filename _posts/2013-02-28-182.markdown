---
author: pandao
comments: false
date: 2013-02-28 11:12:08+00:00
layout: post
slug: '182'
title: '[转]Cacti安装详细步骤'
thread: 182
categories:
- linux
---

### 一、cacti概述


1. cacti是用php语言实现的一个软件，它的主要功能是用snmp服务获取数据，然后用rrdtool储存和更新数据，当用户需要查看数据的时候用rrdtool生成图表呈现给用户。因此，snmp和rrdtool是cacti的关键。Snmp关系着数据的收集，rrdtool关系着数据存储和图表的生成。

2. Mysql配合PHP程序存储一些变量数据并对变量数据进行调用，如：主机名、主机ip、snmp团体名、端口号、模板信息等变量。

3. snmp抓到数据不是存储在mysql中，而是存在rrdtool生成的rrd文件中（在cacti根目录的rra文件夹下）。rrdtool对数据的更新和存储就是对rrd文件的处理，rrd文件是大小固定的档案文件（Round Robin Archive），它能够存储的数据笔数在创建时就已经定义。


### 二、安装rrdtool


CentOS-5:
32位：






	
  1. rpm -ivh http://apt.sw.be/redhat/el5/en/i386/rpmforge/RPMS/rpmforge-release-0.5.2-2.el5.rf.i386.rpm





64位:






	
  1. rpm -ivh http://apt.sw.be/redhat/el5/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.2-2.el5.rf.x86_64.rpm











	
  1. yum install rrdtool -y





CentOS-6:
32位：






	
  1. rpm -ivh http://apt.sw.be/redhat/el6/en/i386/rpmforge/RPMS/rpmforge-release-0.5.2-2.el6.rf.i686.rpm





64位：






	
  1. rpm -ivh http://apt.sw.be/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm











	
  1. yum install rrdtool -y







### 三、安装配置net-snmp


1、安装net-snmp






	
  1. yum install net-snmp net-snmp-libs net-snmp-utils





2、配置net-snmp
在/etc/snmp/snmpd.conf中修改：






	
  1. view    systemview    included   .1.3.6.1.2.1.1





为：






	
  1. view    systemview    included   .1.3.6.1.2.1





3、测试net-snmp






	
  1. # service snmpd start

	
  2. # snmpwalk -v 1 -c public localhost .1.3.6.1.2.1.1.1.0

	
  3. SNMPv2-MIB::sysDescr.0 = STRING: Linux cronos 2.4.28 #2 SMP ven jan 14 14:12:01 CET 2005 i686







### 五、安装LAMP








	
  1. yum install httpd php php-mysql php-snmp php-xml php-gd mysql mysql-server

	
  2. service httpd start

	
  3. service mysqld start

	
  4. mysqladmin -uroot password yourpassword

	
  5. mysqladmin --user=root --password reload







### 四、安装cacti


1、下载cacti






	
  1. cd /tmp

	
  2. wget http://www.cacti.net/downloads/cacti-0.8.8a.tar.gz

	
  3. tar xzf cacti-0.8.8a.tar.gz

	
  4. mv cacti-0.8.8a /var/www/html/cacti

	
  5. cd /var/www/html/cacti





2、创建数据库






	
  1. mysqladmin --user=root -p create cacti





3、导入数据库






	
  1. mysql -uroot -p cacti < cacti.sql





4、创建数据库用户






	
  1. shell> mysql -uroot -p mysql

	
  2. mysql> GRANT ALL ON cacti.* TO cactiuser@localhost IDENTIFIED BY 'cactipassword';

	
  3. mysql> flush privileges;





5、配置include/config.php






	
  1. $database_type = "mysql";

	
  2. $database_default = "cacti";

	
  3. $database_hostname = "localhost";

	
  4. $database_username = "cactiuser";

	
  5. $database_password = "cactipassword";

	
  6. 
	
  7. /* load up old style plugins here */

	
  8. $plugins = array();

	
  9. //$plugins[] = 'thold';

	
  10. 
	
  11. /*

	
  12.    Edit this to point to the default URL of your Cacti install

	
  13.    ex: if your cacti install as at http://serverip/cacti/ this

	
  14.    would be set to /cacti/

	
  15. */

	
  16. $url_path = "/cacti/";

	
  17. 
	
  18. /* Default session name - Session name must contain alpha characters */

	
  19. #$cacti_session_name = "Cacti";





6、设置目录权限






	
  1. useradd cactiuser

	
  2. chown -R cactiuser rra/ log/





7、配置计划任务






	
  1. echo "*/5 * * * * cactiuser php /var/www/html/cacti/poller.php > /dev/null 2>&1">>/etc/crontab

	
  2. service crond restart





8、完成cacti的安装
1) 在浏览器中输入：http://www.yourdomain.com/cacti/
默认用户名：admin 密码：admin
2) 更改密码
3）设置cacti用到的命令路径
[![](http://www.centos.bz/wp-content/uploads/2012/01/cacti.jpg)](http://www.centos.bz/wp-content/uploads/2012/01/cacti.jpg)
至此，cacti的安装已经完成，服务器流量监控设置可以参考[http://www.centos.bz/2012/06/cacti-monitor-traffic/](http://www.centos.bz/2012/06/cacti-monitor-traffic/)。
参考：[http://docs.cacti.net/manual:087:1_installation.1_install_unix](http://docs.cacti.net/manual:087:1_installation.1_install_unix)
