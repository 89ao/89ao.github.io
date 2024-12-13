---
author: pandao
comments: false
date: 2012-12-08 02:05:26+00:00
layout: post
slug: neteye-study-notes-three-working-modes
title: NetEye学习笔记--三种工作模式
thread: 171
categories:
- firewall
tags:
- firewall
---

NetEye有三种工作模式：透明模式、路由模式和混合模式。NetEye的工作模式是通过设置接口的工作模式来实现的。当NetEye工作在透明模式时，需要将接口设置为二层接口；当NetEye工作在路由模式时，需要将接口设置为三层接口；当NetEye工作在混合模式时，则需要将相关接口分别设置为二层接口和三层接口。

透明模式主要用于数据流的二层转发，如图所示。此时NetEye的作用就和交换机样，对于用户来说是透明的。在透明模式下不需要为NetEye 的接口设置IP 地址。




![]({{ site.url }}/assets/TransparentMode.jpg)




路由模式是指NetEye可以让工作在不同网段之间的主机以三层路由的方式进行通信。NetEye处于路由工作模式时，NetEye各接口所连接的网络必须处于不同的网段，需要为NetEye的接口设置IP 地址，如图所示：




![]({{ site.url }}/assets/RouterMode.jpg)



混合模式是指NetEye同时工作在透明模式和路由模式两种模式下，能够同时实现数据流的二层转发和三层路由功能，如图所示：
![]({{ site.url }}/assets/MixedMode.jpg)
