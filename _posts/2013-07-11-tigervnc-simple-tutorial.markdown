---
author: pandao
comments: false
date: 2013-07-11 22:38:48+00:00
layout: post
slug: tigervnc-simple-tutorial
title: tigerVNC的简单使用教程
thread: 205
categories:
- linux
---



1、环境和软件准备

(1) CentOS 6.3下









	
  1. [root@localhost ~]$ rpm –q tigervnc tigervnc-server

	
  2. tigervnc-1.0.90-0.17.20110314svn4359.el6.i686

	
  3. tigervnc-server-1.0.90-0.17.20110314svn4359.el6.i686







使用如下命令，进行安装









	
  1. yum install tigervnc

	
  2. yum install tigervnc-server





(2) Windows 7下

tigervnc-1.2.0.exe，在[http://sourceforge.net/projects/tigervnc/](http://sourceforge.net/projects/tigervnc/)下载



2、启动vncserver（服务器端）









	
  1. vncserver :n





这里的n是sessionnumber，不指定默认为1，也可以是2、3等等。第一次会提示输入密码，以后可以使用vncpasswd命令修改密码。



3、启动vncviewer（客户端）









	
  1. vncviewer localhost:n





这里的n对应vncserver指定的数字，如果使用Xmanager等工具，在Windows下就自动弹出CentOS的桌面，这里我们改用tigervnc-1.2.0.exe。



4、启动tigervnc的Windows版本（tigervnc-1.2.0.exe）

VNC的默认端口是5900，而远程桌面连接端口则是5900+n（n是vncserver命令指定的）。如果使用“vncserver :1”命令启动VNC Server，那么下面的端口应该是5901。

![](http://img.my.csdn.net/uploads/201211/18/1353231616_9342.jpg)

点击“OK”，提示输入密码后，就可以看到CentOS的桌面了。



5、关闭vncserver（服务器端）









	
  1. vncserver -kill :n





如果使用vncserver :n多次建立远程桌面，可以用









	
  1. vncserver –list





列出当前用户建立的所有远程桌面，例如









	
  1. [root@localhost ~]$ vncserver -list

	
  2. TigerVNC server sessions:

	
  3. X DISPLAY # PROCESS ID

	
  4. :1      14174







参考资料：

1、[http://heather.cs.ucdavis.edu/~matloff/vnc.html](http://heather.cs.ucdavis.edu/~matloff/vnc.html)

2、[http://blog.chinaunix.net/uid-26642180-id-3135447.html](http://blog.chinaunix.net/uid-26642180-id-3135447.html)
