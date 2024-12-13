---
author: pandao
comments: false
date: 2012-08-07 12:38:57+00:00
layout: post
slug: iptables-selinux-debrief
title: Iptables SElinux学习总结
thread: 103
categories:
- linux
- firewall
tags:
- firewall
---

Iptables：

	Firewall前端设置工具
	iptables -L：列出当前所有规则
	iptables -F：刷新系统生成的所有规则

配置:

	文本：vim /etc/sysconfig/iptables
	图形化：system-config-firewall(-gui)

SElinux

Kernel-level Security System（二进制定义）

所有资源都有上下文，上下文属于强制访问控制，优先级高于权限。

查看上下文：ls -Z

1，一个文件只能有一种规则

2，当一个文件无规则时，启用默认规则

默认策略：

/etc/selinux/config(软连接/etc/sysconfig/selinux)
：SELINUXTYPE=tartgeted —网络访问则受保护，本地访问不受保护。

SElinux相关命令由以下包提供：

policycoreutils-python提供semange等命令

policycoreulity-gui提供system-config-selinux（SElinux图形化设置前断）

查看/设置：getenforce|setenforce=1|0

开启/关闭：内核参数：selinux=1|0（是否启用selinux服务） 或 enforcing=1|0（启用selinux，但是是否启用防护）

上下文：

	显示上下文：文件：ls -Z；进程 ps -Z
	查看所有上下文：semange fcontext -l
	临时修改上下文（不需重置restorecon，重启失效）：chcon -R -t httpd_sys_content_t /myweb
	永久修改上下文（需重置restorecon，否则当前不生效，重启生效）：
	semanage fcontext -a -t httpd_sys_content_t ‘/myweb(/**.***)?’
	重置上下文：restorecon -vvFR /myweb
