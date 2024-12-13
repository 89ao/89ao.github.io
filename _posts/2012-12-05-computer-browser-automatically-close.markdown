---
author: pandao
comments: false
date: 2012-12-05 06:05:52+00:00
layout: post
slug: computer-browser-automatically-close
title: computer browser自动关闭解决方案
thread: 168
categories:
- 杂七杂八
---

最近Vsphere里面给同事开的用来开发的win2003一直说无法访问共享，第一次检查的时候发现computer browser和server服务没开，开启了之后就解决了，第二次检查发现computer browser服务不知道为什么关闭了，问他们也没人手动关。查了一下，发现关掉2003的防火墙服务（ICS）之后会导致computer browser服务自动关闭，这是2003的一个bug，也可以通过补丁解决（kb958644），由于内网机器没上网，所以直接启动ICS服务，打开防火墙设置，勾上例外里的“文件和打印机共享”，问题解决。
