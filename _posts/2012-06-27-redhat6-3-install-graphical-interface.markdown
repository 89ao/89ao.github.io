---
author: pandao
comments: false
date: 2012-06-27 09:12:46+00:00
layout: post
slug: redhat6-3-install-graphical-interface
title: 在RedHat6.3上安装图形界面
thread: 94
categories:
- linux
tags:
- redhat
---

RHEL6在字符模式下安装图形界面

首页配置本地光盘为yum源。

第一步 挂载光盘

	mkdir /mnt/cdrom
	mount /dev/cdrom /mnt/cdrom

到/mnt/cdrom确认里面的内容

	ls /mnt/cdrom

现在我们来写yum的配置文件

用vim编辑器在/etc/yum.repos.d目录下直接编辑一个repo源文件
修改内容：

	baseurl=file:///mnt/cdrom             ------3个"/"
	enabled=1
	gpgcheck=0

保存并退出，下面我们来测试下本地yum源能否搜索到光盘上的软件包

	yum grouplist

能查询到结果说明挂载和源配置正确

下次要用到光盘里的东西的时候直接将光盘挂载到/mnt/cdrom目录就行啦！

然后我们要做的只是让yum来帮我们安装几个软件包

	yum groupinstall "X Window System"
	yum groupinstall "Desktop"
	yum groupinstall "Desktop Platform"

这里要注意大小写！

现在图形界面已经安装完成了，我们来启动看看！

	startx

这时候我们在终端里输入几条命令试试看，貌似现在终端里没有中文输入法，下面我们顺便来装下

	yum groupinstall "Chinese Support" "Fonts"

好的，现在我们重启后看看效果！

发现仍然是字符环境，我们用vim编辑器来打开/etc/inittab

	id:3:initdefault:
	将其中的3改成5

保存退出，再次重启即安装成功。
