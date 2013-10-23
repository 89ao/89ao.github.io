---
author: pandao
comments: false
date: 2012-08-18 16:00:41+00:00
layout: post
slug: redhatcentos-network-configuration
title: REDHAT/CENTOS网络配置
thread: 129
categories:
- linux
---

大家可能都觉得网络配置已经很熟练了，但是其中的细节还是请注意，有一些需要理清的东西。这里梳理一下，如果错误欢迎联系本人一起讨论，共同学习。

1.网卡配置

要使主机接入网络必须正确配置网卡，网卡配置存放在/etc/sysconfig/network-script/目录中。

目录里面存放了很多关于网络配置的脚本，其中网卡配置使用了ifcfg-eth0的形式编号。

修改指定网卡配置文件ifcfg-eth0。

修改网卡配置后需要重启network服务。

注意：如果想要备份网卡配置，不能向往常一样使用cp ifcfg-eth0 ifcfg-eth0.bak来做，因为这个目录中，系统会默认认为ifcfg开头的为网卡设备配置文件，所以，如果你那么做了，用NetworkManager（或者setup中的tui界面）打开的时候会显示有一个叫eth0.bak的新网卡。如果这里备份，最好改名为bak.ifcfg-eth0,当然，bak.ifcfg-eth0.bak更加保险。

例如:

	/etc/sysconfig/network-scripts/ifcfg-eth0
	DEVICE=eth0 #设备名称
	BOOTPROTO=static|dhcp #使用静态配置还是使用dhcp分配的ip地址
	HWADDR=00:0C:29:26:A2:A6 #网卡的物理地址mac
	ONBOOT=yes
	DHCP_HOSTNAME=192.168.1.1 #dhcp地址（可以不配，但是貌似可以用来解决教室被抢走dhcp的情况）
	IPADDR=192.168.1.9 #网卡ip
	NETMASK=255.255.255.0 #子网掩码
	GATEWAY=192.168.1.1 #网关ip
	BROADCAST=192.168.1.255 #广播ip
	DNS1=8.8.8.8#这里需要注意，我们在后面配置DNS中再详细说。
	
2.network网络配置

/etc/sysconfig/network文件记录了一些网络配置信息。

例如(结合网络收集)：

	NETWORKING=YES|NO #YES表示需要配置网络。 NO：表示不需要配置网络。
	HOSTNAME=viao.cent#主机的hostname，建议采用FQDN的形式。
	GATEWAY=gw-ip #网络网关的IP地址
	NISDOMAIN=dom-name #表示NIS（名称信息服务）域（如果有的话）
	FORWARD_IPV4=”NO” #配置路由器时，是否转发IPV4。
	NETWORKING_IPV6=yes #ipv6网络协议

注意：1.我们知道hostname value可以设置hostname，有的说法用命令设置是保存在缓存里的，重启失效。但是我这边测试，是重启也能生效的，当然为了保险起见，还是修改network文件。2.GATEWAY：我们看到这个配置文件中是有GATEWAY值的，目前尚不知道优先级如何，推测应该是优先ifcfg-ethx，为了针对多网段配置不同的网关，若该文件中未设置，则检查network文件。日后用到的时候再测试。

3.配置DNS

保存DNS配置的文件是/etc/resolv.conf

	nameserver最多可以有3个DNS服务器.
	search最多可以指定6个域名
	
	nameserver   #定义DNS服务器的IP地址
	domain       #定义本地域名
	search       #定义域名的搜索列表
	sortlist     #对返回的域名进行排序


	格式：
	domain a.example.com
	search b.example.com c.example.com
	nameserver 192.168.1.1
	nameserver 8.8.8.8

注意：此处设置的dns会被NetworkManager覆盖，实际中设置了之后最好重启network和networkmanager服务然后查看确认，或者直接重启。如果真被NetworkManager覆盖，可以干掉NetworkManager（chkconfig  networkmanager off），或者打开，在对应接口下拉菜单中选择Automatic（Address Only）。

4.配置本地解析，或者说本地hosts

主要是/etc/hosts配置文件 。
文件记录了IP地址和主机名的映射关系，作用和WindowsXp下的C:\WINDOWS\system32\drivers\etc\hosts相仿。
格式:

	192.168.1.9 www.yezee.org(Hostname主机名) yezee（Alias别名）

5.配置DNS解析顺序

/etc/host.conf文件配置决定了/etc/resolv.conf和/etc/hosts的配置解析顺序。

一般系统中会同时存在DNS域名解析和静态/etc/hosts配置，/etc/host.conf则确定这些配置的解析顺序。

格式：

	order hosts,bind #DNS解析顺序
	multi on|off #允许或禁止/etc/hosts配置中一个主机是否能拥有多个IP地址
	nospoof on #禁止(检查)IP地址欺骗
	alert on #若检查出有IP欺骗，则把警告信息通过syslog记录

order关键字定义了DNS的解析顺序，先使用本机hosts表解析域名，如果不能解析，再使用指定的DNS服务器。(默认就是这样的。)

6.服务端口配置

配置文件/etc/services 记录了端口号和服务之间的端口对应关系。

通过配置这个文件，服务器和客户端的程序便能够把服务的名字转成端口号。

7.ifconfig命令

使用ifconfig命令来检查网络配置,直接输入ifconfig回车即可.

格式:ifconfig 或者 ifconfig eth0 #查看指定网卡配置

使用ifconfig来激活和禁止网卡(网络设备)

格式:ifconfig eth0 up|down

up为激活网卡eth0；down为禁止网卡eth0。

更多命令：ifup/ifdown eth0，启用/禁用接口。

使用ifconfig来修改网卡配置（缓存生效，保险起见还是修改配置文件）

格式:Ifconfig eth0 192.168.1.9 netmask 255.255.255.0

网卡ip被修改为192.168.1.9，子网掩码为255.255.255.0

使用ifconfig来让网卡获取dhcp动态分配的地址

格式:ifconfig eth0 -dynamic

8.更多常用CentOS检查网络的命令:

ping **ihalt.sinaapp.com** #ping,简单连通性测试

traceroute **ihalt.sinaapp.com** #查看路由测试情况

netstat –t #查看tcp连接情况，netstat还有很多好用的参数，具体可参考帮助

hostname server.example.com #更改主机名为xxx

arp #查看arp缓存

arp –s IP MAC #网arp缓存中添加ip和mac映射

arp –d IP #从arp缓存中删除映射
