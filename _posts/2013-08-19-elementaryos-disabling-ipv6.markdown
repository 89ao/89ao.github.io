---
author: pandao
comments: false
date: 2013-08-19 02:40:13+00:00
layout: post
slug: elementaryos-disabling-ipv6
title: elementaryOS禁用ipv6
thread: 245
categories:
- linux
- elementaryOS

tags:
- elementaryOS

---



  sudo vi /etc/sysctl.conf
  
在最底增加一行：`net.ipv6.conf.all.disable_ipv6 = 1`  
保存退出

  sudo sysctl -p

最后用：`ip a | grep inet6`验证，如没有任何输出则禁用成功

  sudo vim /etc/default/grub  
  
>GRUB\_CMDLINE_LINUX_DEFAULT="quiet splash"     
>修改成GRUB\_CMDLINE_LINUX_DEFAULT="ipv6.disable=1 quiet splash"

保存退出

  sudo update-grub
  
重启之后用：ip a | grep inet6验证，如没有任何输出则禁用成功
