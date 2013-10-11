---
author: pandao
comments: false
date: 2013-07-21 09:07:56+00:00
layout: post
slug: how-to-verify-whether-a-service-supports-tcpwrapper
title: 如何来验证一个服务是否支持tcpwrapper
thread: 215
categories:
- linux
---

方法1：使用ldd进行查询

【例子】

#ldd `which vsftpd` | grep  libwrap

只要结果有出现  libwrap.so.0 则表示该服务支持tcpwrapper

方法2：使用strings 进行查询

【例子】

#strings  `which portmap` | grep hosts

结果有：

/etc/hosts.allow

/etc/hosts.deny

则表示该服务是支持tcpwrapper的。

我们来检测一个服务是否支持tcpwrapper时，只要以上两上方法有任意一个满足则表示该服务是支持tcpwrapper的。
