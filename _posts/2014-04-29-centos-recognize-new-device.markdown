---
layout: post
title: "CentOS6.4下识别添加的新硬件"
categories:
- Linux
tags:
- udev


---


在CentOS 6 中,默认的 kudzu 这个识别硬件的服务不存在了，基本上所有的硬件管理都通过Udev来管理了，什么是udev可以查我的其它的文章。如果你在 Centos 6 中加了一个新的硬件，如网卡只需要重新启动udev就行了。 

	start_udev 

这个会重新扫描新加的硬件并做相关的处理。如果我们加的是网卡，识别不对和有时我们想更新网卡的名字，我们并不需要编辑 `/etc/sysconfig/network-scripts/`下的内容，向上面运行完后不正常，我们直接修改udev有关网络的配置就行了。 
有关网络的udev的具体网卡序号的配置文件是 `/etc/udev/rules.d/70-persistent-net.rules` 这个文件。 

	# PCI device 0x1af4:0x1000 (virtio-pci) 
	SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="54:52:00:78:e8:2e", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1" 
	SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="54:52:00:04:19:6c", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"  

向上面这样最多修改一下 MAC 地址和 NAME 大多都能达到我们的需求。修改完了，我们可以使用udev的命令来测试一下。 

	udevadm test /sys/class/net/eth0/ 

这个可以很详细的显示udev的识别和处理的过程。 
另外需要注意一点：新加的硬件如果在 `setup` 和 `system-config-network-tui` 中添加了网卡，但 `/etc/sysconfig/network-scripts/` 找不到配置文件时。其实是因为这些命令默认会给生成的配置文件放到`/etc/sysconfig/networking/devices/`，所以这时只要给这下面的这二个配置文件放到 `/etc/sysconfig/network-scripts/`，在使用 `system-config-network-tui`来配置就正常了。 

	cp /etc/sysconfig/networking/devices/* /etc/sysconfig/network-scripts/ 

重新启动后就可以了。 