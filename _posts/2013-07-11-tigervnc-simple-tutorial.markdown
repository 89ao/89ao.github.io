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

(1) CentOS 6.3 下

    [root@localhost ~]$ rpm –q tigervnc tigervnc-server
    tigervnc-1.0.90-0.17.20110314svn4359.el6.i686
    tigervnc-server-1.0.90-0.17.20110314svn4359.el6.i686

使用如下命令，进行安装

    yum install tigervnc
    yum install tigervnc-server

(2) Windows 7 下
tigervnc-1.2.0.exe，在[http://sourceforge.net/projects/tigervnc/](http://sourceforge.net/projects/tigervnc/)下载

2、启动 vncserver（服务器端）

    vncserver :n

这里的 n 是 sessionnumber，不指定默认为 1，也可以是 2、3 等等。第一次会提示输入密码，以后可以使用 vncpasswd 命令修改密码。

3、启动 vncviewer（客户端）

    vncviewer localhost:n

这里的 n 对应 vncserver 指定的数字，如果使用 Xmanager 等工具，在 Windows 下就自动弹出 CentOS 的桌面，这里我们改用 tigervnc-1.2.0.exe。

4、启动 tigervnc 的 Windows 版本（tigervnc-1.2.0.exe）

VNC 的默认端口是 5900，而远程桌面连接端口则是 5900+n（n 是 vncserver 命令指定的）。如果使用“vncserver :1”命令启动 VNC Server，那么下面的端口应该是 5901。

![](http://img.my.csdn.net/uploads/201211/18/1353231616_9342.jpg)

点击“OK”，提示输入密码后，就可以看到 CentOS 的桌面了。

5、关闭 vncserver（服务器端）

    vncserver -kill :n

如果使用 vncserver :n 多次建立远程桌面，可以用

    vncserver –list

列出当前用户建立的所有远程桌面，例如

    [root@localhost ~]$ vncserver -list
    TigerVNC server sessions:
    X DISPLAY # PROCESS ID
    :1      14174

参考资料：
1、[http://heather.cs.ucdavis.edu/~matloff/vnc.html](http://heather.cs.ucdavis.edu/~matloff/vnc.html)
2、[http://blog.chinaunix.net/uid-26642180-id-3135447.html](http://blog.chinaunix.net/uid-26642180-id-3135447.html)
