---
author: pandao
comments: false
date: 2012-10-29 11:24:27+00:00
layout: post
slug: debian-ubuntu-modify-default-route
title: Debian/Ubuntu默认路由修改
thread: 160
categories:
- linux
---

添加默认路由：sudo route add default gw x.x.x.x

删除默认路由：sudo route del default gw x.x.x.x

查看路由表：netstate -tr

查看路由缓存：route -C

添加路由表：sudo route add -net x.x.x.x/24 gw x.x.x.x

容易出错的地方：网关不要写掩码，网段要。
