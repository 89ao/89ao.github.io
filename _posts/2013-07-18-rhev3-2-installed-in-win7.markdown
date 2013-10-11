---
author: pandao
comments: false
date: 2013-07-18 06:16:04+00:00
layout: post
slug: rhev3-2-installed-in-win7
title: 在RHEV3.2中为安装Win7而加载VritIO驱动
thread: 209
categories:
- Virtualization
---

简单记录一下吧，为了更好的性能，我们在新建硬盘的时候选择VirtIO接口，这样也导致了win7在安装的时候认不到硬盘，解决步骤如下：

加载win7安装镜像，开机，到读取硬盘的界面时，此时读取不到分配的硬盘，结果为空；

在rhev管理界面选择ChangeISO，选择virtio-win-x.x.x.iso；

在虚拟机中点刷新，加载驱动，选择正确的驱动，加载成功之后可以看到分配的硬盘；

再次点击ChangeISO，选择回win7的镜像，在虚拟机中点击刷新，选择硬盘。正常安装即可。
