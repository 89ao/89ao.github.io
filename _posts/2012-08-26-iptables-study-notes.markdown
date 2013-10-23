---
author: pandao
comments: false
date: 2012-08-26 15:16:26+00:00
layout: post
slug: iptables-study-notes
title: iptables学习笔记
thread: 109
categories:
- linux
- firewall
tags:
- firewall
---

常用命令

	service iptables [save|start|restart|stop]
	iptables -L -n

简单shell命令

	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT DROP
	iptables -A INPUT -p tcp –dport 22 -j ACCEPT
	iptables -A INPUT -p tcp -m multiport –destination-port 22,80,8081,10000,9000,3307 -j ACCEPT

重定向设置

    
    iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o eth2 -j SNAT --to A.B.C.D
    iptables -t nat -A POSTROUTING -s 192.168.168.0/24 -o eth2 -j SNAT --to A.B.C.D
    iptables -t nat -A PREROUTING -s 192.168.100.0/24 -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3128
    iptables -t nat -A PREROUTING -s 192.168.168.0/24 -i eth1 -p tcp --dport 80 -j REDIRECT --to-port 3128
    service iptables save

需要开80端口，指定IP和局域网

下面三行的意思：

先关闭所有的80端口

开启ip段192.168.1.0/24端的80口

开启ip段211.123.16.123/24端ip段的80口

	# iptables -I INPUT -p tcp --dport 80 -j DROP 
	# iptables -I INPUT -s 192.168.1.0/24 -p tcp --dport 80 -j ACCEPT
	# iptables -I INPUT -s 211.123.16.123/24 -p tcp --dport 80 -j ACCEPT

以上是临时设置。

1.先备份iptables

	# cp /etc/sysconfig/iptables /var/tmp

2.然后保存iptables

	# service iptables save

3.重启防火墙

	#service iptables restart

以下是端口，先全部封再开某些的IP

	iptables -I INPUT -p tcp --dport 9889 -j DROP 
	iptables -I INPUT -s 192.168.1.0/24 -p tcp --dport 9889 -j ACCEPT

如果用了NAT转发记得配合以下才能生效

	iptables -I FORWARD -p tcp --dport 80 -j DROP 
	iptables -I FORWARD -s 192.168.1.0/24 -p tcp --dport 80 -j ACCEPT

 

常用的IPTABLES规则如下：只能收发邮件，别的都关闭

	iptables -I Filter -m mac --mac-source 00:0F:EA:25:51:37 -j DROP
	iptables -I Filter -m mac --mac-source 00:0F:EA:25:51:37 -p udp --dport 53 -j ACCEPT
	iptables -I Filter -m mac --mac-source 00:0F:EA:25:51:37 -p tcp --dport 25 -j ACCEPT
	iptables -I Filter -m mac --mac-source 00:0F:EA:25:51:37 -p tcp --dport 110 -j ACCEPT

IPSEC NAT 策略

	iptables -I PFWanPriv -d 192.168.100.2 -j ACCEPT
	iptables -t nat -A PREROUTING -p tcp --dport 80 -d $INTERNET_ADDR -j DNAT --to-destination 192.168.100.2:80
	iptables -t nat -A PREROUTING -p tcp --dport 1723 -d $INTERNET_ADDR -j DNAT --to-destination 192.168.100.2:1723
	iptables -t nat -A PREROUTING -p udp --dport 1723 -d $INTERNET_ADDR -j DNAT --to-destination 192.168.100.2:1723
	iptables -t nat -A PREROUTING -p udp --dport 500 -d $INTERNET_ADDR -j DNAT --to-destination 192.168.100.2:500
	iptables -t nat -A PREROUTING -p udp --dport 4500 -d $INTERNET_ADDR -j DNAT --to-destination 192.168.100.2:4500


FTP服务器的NAT

	iptables -I PFWanPriv -p tcp --dport 21 -d 192.168.100.200 -j ACCEPT
	iptables -t nat -A PREROUTING -p tcp --dport 21 -d $INTERNET_ADDR -j DNAT --to-destination 192.168.100.200:21

只允许访问指定网址

	iptables -A Filter -p udp --dport 53 -j ACCEPT
	iptables -A Filter -p tcp --dport 53 -j ACCEPT
	iptables -A Filter -d www.3322.org -j ACCEPT
	iptables -A Filter -d img.cn99.com -j ACCEPT
	iptables -A Filter -j DROP

开放一个IP的一些端口，其它都封闭

	iptables -A Filter -p tcp --dport 80 -s 192.168.100.200 -d www.pconline.com.cn -j ACCEPT
	iptables -A Filter -p tcp --dport 25 -s 192.168.100.200 -j ACCEPT
	iptables -A Filter -p tcp --dport 109 -s 192.168.100.200 -j ACCEPT
	iptables -A Filter -p tcp --dport 110 -s 192.168.100.200 -j ACCEPT
	iptables -A Filter -p tcp --dport 53 -j ACCEPT
	iptables -A Filter -p udp --dport 53 -j ACCEPT
	iptables -A Filter -j DROP

多个端口

	iptables -A Filter -p tcp -m multiport --destination-port 22,53,80,110 -s 192.168.20.3 -j REJECT

连续端口

	iptables -A Filter -p tcp -m multiport --source-port 22,53,80,110 -s 192.168.20.3 -j REJECT iptables -A Filter -p tcp --source-port 2:80 -s 192.168.20.3 -j REJECT

指定时间上网

	iptables -A Filter -s 10.10.10.253 -m time --timestart 6:00 --timestop 11:00 --days Mon,Tue,Wed,Thu,Fri,Sat,Sun -j DROP
	iptables -A Filter -m time --timestart 12:00 --timestop 13:00 --days Mon,Tue,Wed,Thu,Fri,Sat,Sun -j ACCEPT
	iptables -A Filter -m time --timestart 17:30 --timestop 8:30 --days Mon,Tue,Wed,Thu,Fri,Sat,Sun -j ACCEPT

禁止多个端口服务

	iptables -A Filter -m multiport -p tcp --dport 21,23,80 -j ACCEPT

将WAN 口NAT到PC

	iptables -t nat -A PREROUTING -i $INTERNET_IF -d $INTERNET_ADDR -j DNAT --to-destination 192.168.0.1


将WAN口8000端口NAT到192。168。100。200的80端口

	iptables -t nat -A PREROUTING -p tcp --dport 8000 -d $INTERNET_ADDR -j DNAT --to-destination 192.168.100.200:80

MAIL服务器要转的端口

	iptables -t nat -A PREROUTING -p tcp --dport 110 -d $INTERNET_ADDR -j DNAT --to-destination 192.168.100.200:110
	iptables -t nat -A PREROUTING -p tcp --dport 25 -d $INTERNET_ADDR -j DNAT --to-destination 192.168.100.200:25

只允许PING 202。96。134。133,别的服务都禁止

	iptables -A Filter -p icmp -s 192.168.100.200 -d 202.96.134.133 -j ACCEPT
	iptables -A Filter -j DROP

禁用BT配置

	iptables –A Filter –p tcp –dport 6000:20000 –j DROP

禁用QQ防火墙配置

	iptables -A Filter -p udp --dport ! 53 -j DROP
	iptables -A Filter -d 218.17.209.0/24 -j DROP
	iptables -A Filter -d 218.18.95.0/24 -j DROP
	iptables -A Filter -d 219.133.40.177 -j DROP

基于MAC，只能收发邮件，其它都拒绝

	iptables -I Filter -m mac --mac-source 00:0A:EB:97:79:A1 -j DROP
	iptables -I Filter -m mac --mac-source 00:0A:EB:97:79:A1 -p tcp --dport 25 -j ACCEPT
	iptables -I Filter -m mac --mac-source 00:0A:EB:97:79:A1 -p tcp --dport 110 -j ACCEPT

禁用MSN配置

	iptables -A Filter -p udp --dport 9 -j DROP
	iptables -A Filter -p tcp --dport 1863 -j DROP
	iptables -A Filter -p tcp --dport 80 -d 207.68.178.238 -j DROP
	iptables -A Filter -p tcp --dport 80 -d 207.46.110.0/24 -j DROP

只允许PING 202。96。134。133 其它公网IP都不许PING

	iptables -A Filter -p icmp -s 192.168.100.200 -d 202.96.134.133 -j ACCEPT
	iptables -A Filter -p icmp -j DROP

禁止某个MAC地址访问internet:

	iptables -I Filter -m mac --mac-source 00:20:18:8F:72:F8 -j DROP

禁止某个IP地址的PING:

	iptables –A Filter –p icmp –s 192.168.0.1 –j DROP

禁止某个IP地址服务：

	iptables –A Filter -p tcp -s 192.168.0.1 --dport 80 -j DROP
	iptables –A Filter -p udp -s 192.168.0.1 --dport 53 -j DROP

只允许某些服务，其他都拒绝(2条规则)

	iptables -A Filter -p tcp -s 192.168.0.1 --dport 1000 -j ACCEPT
	iptables -A Filter -j DROP

禁止某个IP地址的某个端口服务

	iptables -A Filter -p tcp -s 10.10.10.253 --dport 80 -j ACCEPT
	iptables -A Filter -p tcp -s 10.10.10.253 --dport 80 -j DROP

禁止某个MAC地址的某个端口服务

	iptables -I Filter -p tcp -m mac --mac-source 00:20:18:8F:72:F8 --dport 80 -j DROP

禁止某个MAC地址访问internet:

	iptables -I Filter -m mac --mac-source 00:11:22:33:44:55 -j DROP

禁止某个IP地址的PING:

	iptables –A Filter –p icmp –s 192.168.0.1 –j DROP
