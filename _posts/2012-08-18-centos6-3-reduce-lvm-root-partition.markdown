---
author: pandao
comments: false
date: 2012-08-18 16:00:56+00:00
layout: post
slug: centos6-3-reduce-lvm-root-partition
title: CentOS6.3缩小LVM根分区
thread: 127
categories:
- linux
---

今天做新建swap分区实验，结果一看，虚拟机里的硬盘已经全部做成LVM了，然后LVM的空间又全部用掉，只做了一个swap一个根，这下囧了，没法新建分区啊。诚然可以在虚拟机里面新建一块虚拟硬盘添加到虚拟机里面去，但是这样貌似在生产环境中意义不大，而且没什么好学习的，于是来做做缩小根分区的实验吧。	
首先装一下高端：警告：缩减LVM 可能会造成数据丢失。因此，应当做好数据备份。红帽不能帮助您做大量的数据恢复。	

缩减根分区只能在救援模式下进行（rescue mode），首先，使用rhel光盘启动系统，在引导菜单中选择rescue intalled system，或者按tab，输入linux rescue，回车进入救援模式。选择相关的语言，键盘模式。当系统提示启用网络设备时，选择“No”。最后，在提示允许救援模式挂载红帽企业版 Linux 系统到/mnt/sysimage 下时，选择“Skip”（LVM修改时文件系统必须不被挂载），这时，成功进入了救援模式。		
接下来，运行以下命令扫描所有硬盘上的物理卷，卷组和逻辑卷： 请确认救援系统检测到硬盘正确的 lvm 结构。	

	lvm pvscan
	lvm vgscan
	lvm lvscan

有的时候不需要运行以上命令就能读出LVM信息来（比如我这里），这里为了稳妥，也相当于是检查，所以挨个运行下以保证没有错误。		
接下来，在救援模式激活需要操作的卷	

	lvm lvchange -ay /dev/VolGroup/lv_root

经过这一步之后，使用lvm命令集就能正确的操作到root这个lv了。

下一步是缩减LV大小，请确认根文件系统文件系统和该逻辑卷有足够的空间存放之前所有的数据，简单的说，就是缩小之后的目标大小要大于现在的已用空间。否则无法缩小倒是小问题，损坏了文件系统丢失了数据就是大问题了。

在改变文件系统大小之前，首先运行命令e2fsck检查文件系统：

	e2fsck -f /dev/VolGroup/lv_root
	resize2fs /dev/VolGroup/lv_root 3000M
	lvm lvreduce -L 3000M /dev/VolGroup/lv_root

注意，这是针对/dev/VolGroup/lv_root的操作。这里标明的数字（3000M）是文件系统的目标大小，而不是要减小的大小。
最后，核对修改生效，重启系统。

	lvm vgdisplay VolGroup00
	reboot
