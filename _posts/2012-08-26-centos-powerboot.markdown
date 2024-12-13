---
author: pandao
comments: false
date: 2012-08-26 06:27:03+00:00
layout: post
slug: centos-powerboot
title: CentOS开机自启动
thread: 112
categories:
- linux
---

今天用CentOS做goagent代理服务器，这里附上设置自定义的脚本为自动启动的方法：

在CentOS系统下，主要有两种方法设置自己安装的程序开机启动。
1、把启动程序的命令添加到/etc/rc.d/rc.local文件中，此处例为/root/goagent。

vim /etc/rc.d/rc.local






	
  1. #!/bin/sh

	
  2. #

	
  3. # This script will be executed *after* all the other init scripts.

	
  4. # You can put your own initialization stuff in here if you don’t

	
  5. # want to do the full Sys V style init stuff.

	
  6. touch /var/lock/subsys/local

	
  7. /root/goagent&





这里有一点需要注意，开始的时候我直接写的是/root/goagent，开机之后发现进度条读完了之后无法进入系统，一直停留在进度条的界面，看不到启动信息也无法诊断错误在哪里。

于是ssh上去修改grub选项，删掉rhgbl，这样下次启动的时候就可以显示详细启动信息。

[root@Slyar ~]# vim /boot/grub/grub.conf

找到下面的部分，将”rhgb”去掉，保存即可。其中”rhgb”表示”redhat graphics boot”，就是图形进度条模式。而”quiet”表示在启动过程中只显示重要启动信息，类似硬件自检之类的消息不会显示，可以有选择地选用。

重启之后发现系统初始化在运行了前面那个脚本之后，就一直卡在我们前面设置的脚本那里，不进行后续操作，于是知道了是因为这个脚本是前台执行的，要放在后台执行，只要在脚本后面加上一个&就可以了，修改重启，问题解决。



2、把写好的启动脚本添加到目录/etc/rc.d/init.d/，然后使用命令chkconfig设置开机启动。
例如：我们把httpd的脚本写好后放进/etc/rc.d/init.d/目录，使用






	
  1. chkconfig –add goagent

	
  2. chkconfig httpd on





命令即设置好了开机启动。
