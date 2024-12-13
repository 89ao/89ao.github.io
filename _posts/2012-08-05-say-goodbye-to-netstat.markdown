---
author: pandao
comments: false
date: 2012-08-05 03:03:18+00:00
layout: post
slug: say-goodbye-to-netstat
title: '[转]和netstat说再见'
thread: 98
categories:
- linux
---

本原创文章属于《Linux大棚》博客。

博客地址为http://roclinux.cn。

文章作者为jy Liu。
【正文开始】

什么是netstat？

如果你手头有Linux系统，你直接输入man netstat，就可以得到帮助信息。man对于netstat的解释非常言简意赅，只有一句简短的描述：

“netstat – Print network connections, routing tables, interface statistics, masquerade connections, and multicast memberships”

中文意思是：netstat可以用来显示网络连接、路由表、接口统计、伪连接和组播成员。

从这段简短的描述中，我们可以看出，netstat有如上五大作用。

为什么要和netstat说再见？

如果你仔细阅读man netstat的内容，会发现有这样一句话：

“This program is obsolete.”

原来netstat已经是明日黄花了，官方已经不再更新了。它已经被ss命令和ip命令所取代，或许在不久的将来在Linux发行版中就将见不到netstat的身影了。所以，如果还有人在用netstat，你要建议他使用ss和ip。

具体的替代方案，我做了一张简单的示意图：

![]({{ site.url }}/assets/netstat_subsititute.jpg)
