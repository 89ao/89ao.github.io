---
author: pandao
comments: false
date: 2012-12-19 06:46:43+00:00
layout: post
slug: linux-task-scheduling-jobs-and-run-in-the-background
title: Linux任务调度(jobs)以及后台运行命令
thread: 178
categories:
- linux
---

Linux Jobs等前后台运行命令解

fg、bg、jobs、&、ctrl + z都是跟系统任务有关的，虽然现在基本上不怎么需要用到这些命令，但学会了也是很实用的
一。& 最经常被用到
这个用在一个命令的最后，可以把这个命令放到后台：command& 让进程在后台运行。
二。ctrl + z
可以将一个正在前台执行的命令放到后台，并且暂停
三。jobs
查看当前有多少在后台运行
四。fg
将后台中的命令调至前台继续运行
如果后台中有多个命令，可以用 fg %jobid将选中的命令调出，%jobid是通过jobs命令查到的后台正在执行的命令的序号(不是pid)
五。bg
将一个在后台暂停的命令，变成继续执行
如果后台中有多个命令，可以用bg %jobid将选中的命令调出，%jobid是通过jobs命令查到的后台正在执行的命令的序号(不是pid)

更常用也更好用的命令为 nohup 。

一句话解释：普通进程用&符号放到后台运行，如果启动该程序的控制台logout，则该进程随即终止,要实现终端推出后程序继续运行，需使用nohup命令启动程序：nohup <程序名> & ，则控制台logout后，进程仍然继续运行使用nohup命令后，原程序的的标准输出被自动改向到当前目录下的nohup.out文件，起到了log的作用。

如果想要监控标准输出可以使用：tail -f nohup.out。

举例：如果要将当前正在运行的进程放在后台，使用CTRL+Z暂停任务并放到后台，然后再bg后台运行当前进程。

             如果要某程序在当前终端退出后还能继续运行，则使用nohup xxx & 。
