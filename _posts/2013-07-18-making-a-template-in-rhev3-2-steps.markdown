---
author: pandao
comments: false
date: 2013-07-18 05:55:12+00:00
layout: post
slug: making-a-template-in-rhev3-2-steps
title: 在RHEV3.2中制作模板的步骤
thread: 208
categories:
  - linux
  - Virtualization
---

可能我们会觉得制作模板很简单，不就安装一个虚拟机，关机，Make Template 就完了吗？其实不是的，这样转化出的模板，其 hostname，网卡的 MAC 地址，还有一些其他的系统信息是没有改变的，这在之后的使用中会造成很大的问题。而在 RedHat 官方查看了文档之后，我发现其实正规的流程是这样的(我们分 Linux 和 Windows 分别来说)：

1：Linux：

对于 linux 机器还是比较简单的，比如 RedHat，我这里是 RHEL6.4，在安装了一个虚拟机之后，如果要以它作为模板，官方的视频里是首先修改 hostname，然后删除 ifcfg-ethX 中的 MAC 地址，然后删除多个 Udev 文件等等，但是这些操作可以简单的用一个命令来完成，就是 sys-unconfig，这个命令的详细执行过程请点击[这里](http://ihalt.sinaapp.com/2013/07/sys-unconfig-command-execution-order.html)。执行完 sys-unconfig 之后系统会关机，然后点击 MakeTemplate 正常制作模板。

2：Windows：

前言：先说虚拟机，经实际使用中显示，win server 2003 在虚拟化中使用经常会出现跳电的现象，最后询问了 Windows 和 Vmware 的工程师之后了解到，原来是 2003 的问题，导致在虚拟化的环境中会出现跳电的问题，而 XP 频临淘汰，所以我们在 Windows 虚拟化中采用的系统为服务器：Win2008，桌面：Win7.这里便以 win7 为例子来说明制作模板的过程。

1，登陆系统，编辑注册表，定位到 HEKY_LOCAL_MACHINE/System/Setup/，新建 String Value，键名为 UnattendFile，值为 a:\sysprep.inf;

2，执行程序 c:\windows\system32\sysprep\sysprep.exe，在选项上打钩，下拉菜单中选择 shutdown，确定关机。

3，此时可以在 RHEV 管理界面中选择 Make Template 制作 win7 模板。

4，关于 KEY：根据官方文档，通过如下操作可以让 RHEVM 自动分配 win7 虚拟机的 KEY：在 RHEVM 上执行：rhevm-config -s ProduchKeyWindows7="XXX" && service ovirt-engine restart.
