---
author: pandao
comments: false
date: 2011-09-23 17:22:55+00:00
layout: post
slug: ubuntu-auto-power-off
title: UBUNTU自动关机的方法
thread: 74
categories:
- linux
---

为了不让电脑被闪机可以使用关机命令。其实Ubuntu Linux自身就有自动关机的命令，那就是利用shutdown命令(和Windows下的shutdown其实很相似)。

　　1. “shutdown”命令是在Linux文本模式(终端模式)下，使用最多的关机或重启命令。

　　其使用格式为：“[sudo] shutdown 参数 延迟时间

	　　在终端输入：
	　　sudo shutdown +100 就表示电脑在100分钟后关机。
	　　-k 并不真正关机而只是发出警告信息给所有用户
	　　-r now 现在立即重新启动
	　　-r +3 三分钟后重启
	　　-r 20:23 在20：23时将重启计算机
	　　-r 20:23 & 可以将在20：23时重启的任务放到后台去，用户可以继续操作终端
	　　-h now 现在立刻关机
	　　-h +3 三分钟后关机
	　　-h 12:00 在12点关机
	　　-f 快速关机重启动时跳过fsck
	　　-n 快速关机不经过init 程序，不鼓励使用这个选项﹐而且该选项所产生的后果往往不总是你所预期得到的。

　　2. 如果你此时手动关机是没用的，关机和重启都会变成登出，可以用 sudo shutdown -c来取消自动关机的命令。


