---
layout: post
title: "如何修改网卡的udev设置"
categories:
- Linux
tags:
- udev


---

首先修改配置文件

  vim /etc/udev/rules.d/70-persistent-net.rules
  
修改完成之后：

  udevadmin trigger
  或者 start_udev

在虚拟机中可能没有生效，重启一下即可。
