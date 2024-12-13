---
author: pandao
comments: false
date: 2013-07-18 05:43:19+00:00
layout: post
slug: sys-unconfig-command-execution-order
title: sys-unconfig命令的执行顺序
thread: 207
categories:
- linux
---

sys-unconfig大家都很熟悉吧，方便，缺点就是需要把所有配置都改一次，还得重启机器，也许还得去机房：



1，把当前的/etc/inet/hosts文件备份到/etc/inet/hosts.save;

2，如果当前/etc/vfstab文件包含NFS的挂载点的话，复制该文件到/etc/vfstab.orig；

3，恢复系统默认的/etc/inet/hosts文件；

4，把所有已经配置的网络接口的文件，/etc/hostname.×××的文件删除；

5，删除/etc/defaultdomain文件中的默认域名；

6，把/etc/TIMEZONE文件的时区恢复为PST8PDT；

7，恢复/etc/nsswitch.conf文件为系统默认；

8，删除/etc/net/ti*/hosts文件中本主机使用的条目；

9，删除名称服务使用的/etc/inet/netmasks文件；

10，删除/etc/defaultrouter文件；

11，删除/etc/shadow文件中root用户的密码；

12，删除NIS+使用/etc/.rootkey文件；

13，删除DNS服务使用的/etc/resolv.conf文件；

14，删除LDAP服务需要的配置文件：

/etc/ldap/ldap_client_cache;

/etc/ldap/ldap_clent_file;

/etc/ldap/ldap_client_cred;

/etc/ldap/cachemgr.log

15，重新生成sshd的密钥。




