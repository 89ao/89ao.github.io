---
author: pandao
comments: false
date: 2013-07-16 06:35:06+00:00
layout: post
slug: how-to-use-kickstart-to-create-logical-volume-management-lvm-partition
title: 如何使用 kickstart创建逻辑卷管理（LVM）分区
thread: 210
categories:
- linux
---

如果使用 kickstart创建逻辑卷管理（LVM）分区，要在ks.cfg文件的"Disk Partition Information"部分添加一下选项：
#Disk partitioning informationpart
pv.<id>
volgroup <name> <partition>
logvol <mountpoint> –vgname=<volume_group_name> –size=<size> –name=<name>
注意：
上 面提到的选项是有先后顺序的。物理卷将先被创建，然后是卷组和逻辑卷。
实例：我的ks脚本这一段如下：
# Partition clearing information
clearpart --all
#Disk partitioning information
part /boot --fstype ext4 --size=256
part swap --size=4096
part pv.01 --size=1 --grow
volgroup vg_root pv.01
logvol  / --fstype ext4  --vgname=vg_root  --size=5120  --name=lv_root
logvol  /home --fstype ext4 --vgname=vg_root  --size=5120  --name=lv_home
更多信息请阅读：
http://sources.redhat.com/lvm2/
Kickstart-List Archives at: http://www.redhat.com/archives/kickstart-list/
