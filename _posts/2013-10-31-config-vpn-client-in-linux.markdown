---
layout: post
title: "在linux中安装vpn客户端"
categories:
- Linux
tags:
- VPN


---


1.首先确定内核是否在2.6.15之后，如果早于该版本需要安装MPPE

2.安装客户端软件包[PPTP Client](http://pptpclient.sourceforge.net/#download)

这里需要说明，虽然源里面也有一个pptp包，但是这个编译之后的包里面包含pptpsetup命令，用这个命令可以很方便的配置vpn链接，所以我都使用这个。会配置的朋友也可以装源里的版本。

	make
	make install

如果有什么ssl错误，安装一个openssl-dev即可。

3.配置


	pptpsetup --create linkname --server xxx.xxx.xxx.xxx--username 用户名 --password 密码

4.连接


	pppd call linkname

5.路由

处理路由的时候才用client to lan的方式，所以需要增加对方lan的路由或者目标网络的路由。

	route add -net 192.168.39.0 netmask 255.255.255.0 dev ppp0

ppp0是pptp连接的名字， 如果不确定 可以使用ifconfig命令查看。	

6.断开


	killall pppd
