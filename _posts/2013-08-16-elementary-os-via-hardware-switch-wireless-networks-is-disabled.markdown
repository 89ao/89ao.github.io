---
author: pandao
comments: false
date: 2013-08-16 08:18:47+00:00
layout: post
slug: elementary-os-via-hardware-switch-wireless-networks-is-disabled
title: elementary os 无线网络已通过硬件开关禁用
thread: 227
categories:
- linux
- elementaryOS
tags:
- elementaryOS

---

ubuntu 12.04 无线网络已通过硬件开关禁用 而我电脑上的无线开关是打开的 灯也是亮着的 在win7 下无线能用



    
输入如下命令，稍等即可解决。

    rfkill unblock all
