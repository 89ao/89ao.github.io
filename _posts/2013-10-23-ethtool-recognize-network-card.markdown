---
layout: post
title: "用ethtool判断网卡别名对应的是哪个网卡接口"
categories:
- Linux
tags:
- ethtool


---

在管理多网卡的服务器中，经常会发生配置文件与网口对应混乱的问题，为了解决这个问题，我们可以使用ethtool这个工具，这是一个linux网络驱动诊断和调整工具，支持Linux2.4.x或更高的内核版本。

1，我们最常用的需求是判断网卡别名和硬件的对应关系：

首先拔掉网卡上的网线，否则看不出来是否因ethtool引起的闪烁，然后执行：

	ethtool -p eth0 

执行这个命令时，eth0对应的网口的灯就会闪烁，可以分别调用ethtool判断eth1,eth2对应的网口，这样就可以判定其对应关系了。

2，查看网卡相关的驱动

	ethtool –i eth0  //查询ethX网卡的驱动相关的信息。

Example：

	kevin@kevin-Presario-V3700-Notebook-PC:/$ ethtool -i eth0
	driver: sky2                      //可以看出其驱动名称为sky2
	version: 1.28                    //版本号是1.28
	firmware-version: N/A
	bus-info: 0000:05:00.0
	supports-statistics: yes
	supports-test: no               // 是测试网卡是否可以自适应的,我的网卡不具备此功能，所以显示no。
	supports-eeprom-access: yes
	supports-register-dump: yes


