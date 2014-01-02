---
layout: post
title: "Linux踢出其他用户"
categories:
- Linux
tags:
- Shell


---

在一些生产平台或者做安全审计的时候往往看到一大堆的用户SSH连接到同一台服务器，或者连接后没有正常关闭进程还驻留在系统内。限制SSH连接数与手动断开空闲连接也有必要之举，这里写出Linux下手动剔出其他用户的过程。

##1、查看系统在线用户

	[root@linuxidc ~]# w

	14:30:26 up 38 days, 21:22,  3 users,  load average: 0.00, 0.01, 0.05
	USER    TTY      FROM              LOGIN@  IDLE  JCPU  PCPU WHAT
	root    pts/0    162.16.16.155    14:30    0.00s  0.07s  0.05s w
	root    pts/1    162.16.16.155    14:30  12.00s  0.01s  0.01s -bash
	root    tty1    :0              05Dec13 38days  2:16  2:16  /usr/bin/Xorg :0 -nr -verbose -audit 4 -auth /var/run/gdm/auth-for-gdm-LrK8wg/database -noliste

##2.查看哪个属于此时自己的终端

	[root@linuxidc ~]# who am i

	root    pts/0        2013-12-31 14:30 (162.16.16.155)

##3.pkill掉自己不适用的终端

	[root@linuxidc ~]#  pkill -kill -t pts/1

##4.查看当前终端情况

	[root@linuxidc ~]# w
	 14:31:04 up 38 days, 21:23,  2 users,  load average: 0.00, 0.01, 0.05
	USER    TTY      FROM              LOGIN@  IDLE  JCPU  PCPU WHAT
	root    pts/0    162.16.16.155    14:30    0.00s  0.04s  0.01s w
	root    tty1    :0              05Dec13 38days  2:16  2:16  /usr/bin/Xorg :0 -nr -verbose -audit 4 -auth /var/run/gdm/auth-for-gdm-LrK8wg/database -noliste
	[root@linuxidc ~]#

注意：

如果最后查看还是没有干掉，建议加上-9 强制杀死。

	[root@linuxidc ~]# pkill -9 -t pts/1
