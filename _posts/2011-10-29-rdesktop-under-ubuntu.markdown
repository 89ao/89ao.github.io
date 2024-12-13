---
author: pandao
comments: false
date: 2011-10-29 03:52:19+00:00
layout: post
slug: rdesktop-under-ubuntu
title: Ubuntu下rdesktop实验（只是想在Ubuntu跑windows程序不必装虚拟机）
thread: 83
categories:
- linux
---

配置虚拟机网络：

如果使用VMware，请将host-only作为虚拟机与主机的网络连接方式，VMware弄这个很方便，就不多说了；

如果使用VBox，同样将Host-interface作为网络连接，不过配置稍微有些麻烦，还好先人OceanBoo早已写了一篇详细文章了，请看这里；

总结：简单地说，就是让虚拟机和物理机之间购成桥接网络，能根据IP直接访问；

配置XP：

打开虚拟机进入Windows XP； “开始”“控制面版”，“用户帐户”“更改用户登录或注销的方式”，确认“使用欢迎屏幕”和“使用快速用户切换”都已勾上； 然后打开远程桌面：在“控制面版”的“系统”，“远程”，勾上“允许用户远程连接到此计算机”； 下载 http://www.cendio.se/files/thinlinc/seamlessrdp/seamlessrdp.zip，并解压到C盘根目录下，C:\seamlessrdp，然后就登出吧； 

配置Ubuntu：
安装rdesktop，执行`sudo apt-get install rdesktop`
然后在终端下执行以下命令，运行Windows程序：

	rdesktop -A -s “c:\seamlessrdp\seamlessrdpshell.exe C:\Program Files\Internet Explorer\iexplore.exe” 虚拟机的IP:3389 -u administrator -p password。

以我为例，就是执行：

	rdesktop -A -s “c:\seamlessrdp\seamlessrdpshell.exe C:\Program Files\Internet Explorer\iexplore.exe” 192.168.0.10:3389 -u administrator -p 123456；

然后IE就打开了……相信大家能看懂以上参数吧？就是通过rdesktop，用帐户Administrator和密码123456，连接到192.168.0.10这台机子的3389（即终端），然后用seamlessrdpshell.exe这个东西调用虚拟机上的软件，只把软件界面搞到本地来用。大概是这样吧。具体原理就不晓得了。所以说，虚拟机只是本地的方法，你可以把同在一个局域网的其他机子的软件调用过来！

Enjoy！

这样做有什么好处呢？直接虚拟机不就行了？好处是显而意见的。你不必从虚拟机和物理机里切换来切换去，直接把虚拟机的软件放在物理机里完美运行，交互式运行，方便就两个字！
