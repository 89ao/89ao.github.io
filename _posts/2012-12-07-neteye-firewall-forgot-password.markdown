---
author: pandao
comments: false
date: 2012-12-07 09:43:27+00:00
layout: post
slug: neteye-firewall-forgot-password
title: NetEye防火墙忘记密码
thread: 170
categories:
- firewall
tags:
- firewall
---

手上有2个NetEye FW5120，但是由于很久之前配置过，忘记密码了，打过neusoft客服电话之后他们的工程师告诉我，这样可以清除密码：

一，由于root用户没有编辑设置的权限，只有修改用户账户信息的权限，那么如果root用户没有被修改密码，直接登录root用户，密码为neteye，修改需要的用户的密码就行。

二，如果连root用户的密码也被改掉了，那么防火墙重置root用户密码方法如下：


1、开机后按2，进入bootmanager模式







2、执行sh命令，进入bash下




3、恢复密码的文件保存在hda6中，把它挂载上来到mnt目录下 \\注意:不同的防火墙存储的位置有可能不同，可以df -h 看看都有哪个盘。一般是hda6或者sda6。




4、mount /dev/hda6 /mnt/ 将hda6挂载到mnt目录中




5、cd /mnt/NetEye_FW_4_2_build_200300/ \\注意：NetEye_FW_4_2_build_200300/ 这个目录是防火墙版本不同而定，cd mnt后，ls查看




6、执行恢复密码的文件./ne_reset_passwd




7、reboot，重启后，root的密码就恢复成了neteye







主要是找到ne_reset_passwd这个脚本
