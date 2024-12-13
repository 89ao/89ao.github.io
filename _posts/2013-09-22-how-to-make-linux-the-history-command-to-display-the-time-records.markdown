---
author: pandao
comments: false
date: 2013-09-22 03:29:32+00:00
layout: post
slug: how-to-make-linux-the-history-command-to-display-the-time-records
title: 如何让linux的history命令显示时间记录
thread: 258
categories:
- linux
- shell
tags:
- shell
---

注意：本方法只对bash-3.0以上版本有效
执行rpm -q bash即可显示bash的版本
对于常见的linux AS4、AS5，都是有效的

---------------------------------------------

编辑/etc/bashrc文件，加入如下三行：
>HISTFILESIZE=2000    
>HISTSIZE=2000    
>HISTTIMEFORMAT="%Y%m%d-%H%M%S: "    
>export HISTTIMEFORMAT    

保存后退出，关闭当前shell，并重新登录
这个时候，在~/.bash_history文件中，就有记录命令执行的时间了

用cat命令显示这个文件，但是却会看到这个时间不是年月日显示的
而是按照unix time来显示：

[root@vz ~]# cat ~/.bash_history    
\#1184649982    
touch 3    
\#1184649984    
exit
\#1184650148    
history     


这个时间叫做unix time，是从1970年1月1日临时起，到现在一共经过了多少秒
因为1969年是unix系统诞生，因此1970年1月1日被规定为unix系统诞生的时间的初始
linux系统因为和unix系统的相似性，也完全采用这种方式来记录时间

为了按照人类的年月日方式来显示时间，执行history命令来查看，就可以了，例如：    
[root@vz ~]# history | more    
1 20070717-132935: ll     
2 20070717-132935: w    
3 20070717-132935: rm -rf *    
4 20070717-132935: ll    
5 20070717-132935: w    
6 20070717-132935: cat /etc/redhat-release     
7 20070717-132935: rpm -ivh expect-5.42.1-1.i386.rpm     
8 20070717-132935: ll    
9 20070717-132935: vi /etc/sysconfig/i18n     
10 20070717-132935: ll    
11 20070717-132935: rpm -q expect    
[root@vz ~]#

这样即可查看到在什么时间执行了什么命令。

注意：本方法必须在服务器刚刚新安装好时候，就设置这个参数。
如果是已经运行了很久的服务器才添加这个参数，则以前的那些命令历史记录是不显示时间的。
