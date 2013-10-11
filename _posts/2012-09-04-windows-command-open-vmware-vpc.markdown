---
author: pandao
comments: false
date: 2012-09-04 07:31:14+00:00
layout: post
slug: windows-command-open-vmware-vpc
title: Windows下命令行开启vmware虚拟机
thread: 119
categories:
- linux
---

由于本人习惯用vnc连接虚拟机进行操作（在不用ssh的时候），所以觉得vmware workstation的界面开在那里除了占用界面和资源之外没有任何作用，于是想到用命令行开启虚拟机，vnc上去操作这种方法。

主要用到的是vmware自带的一个工具，vmrun.exe，在vmware workstation的安装路径下可以找到，我这里是

C:\Program Files (x86)\VMware\VMware Workstation

格式为：vmrun.exe start *.vmx

.vmx为虚拟机配置文件。

比如我这里：

“C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe” start “F:\rhceVM\RServer\RServer.vmx” nogui

nogui为不开启图形界面，即完全后台运行，可不加此参数。

注：后台运行在右下角的vmware tray icon还是可以管理到的，所以不用害怕完全后台运行了无法找到虚拟机。
