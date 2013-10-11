---
author: pandao
comments: false
date: 2013-07-26 01:16:31+00:00
layout: post
slug: discussion-on-linux-performance-tuning-of-network-connection-binding
title: 浅谈linux性能调优之网卡绑定
thread: 217
categories:
- linux
---

在生产环境下，防止单点故障是经常要考虑的因素，像数据库的异地备份，集群调度端的热备，挂载存储的多路经，路由器的冗余。对于数据大多都有复制，同步手 段。对于数据传输链路也是要考虑的，多路经便是其中的一种。一般服务器连接交换机，路由器，存储都是采用多条链路来防止单点故障的，linux下可以采用 网卡绑定的方式来实现，网卡绑定就是将两块以上的物理网卡抽象成一个逻辑的网卡像bond0，管理员不再考虑ethN这样的物理网卡，呵呵，这里的道理和 逻辑卷相似!不过这种绑定不仅可以以轮循的方式工作，也可以以主备的方式工作。

>Linux 以太网绑定常见工作模式
模式 0 (平衡轮循) - 轮循策略,所有接口都使用。采用轮循方式在所有 Slave 中传输封包;任何 Slave 都可以接收。
模式 1 (主动备份) - 容错。一次只能使用一个 Slave 接口,但是如果该接口出现故障,另一个 Slave 将 接替它。
模式 3 (广播) - 容错。所有封包都通过所有 Slave 接口广播。

一个关于网卡绑定的详细资料：http://blog.csdn.net/xrb66/article/details/7863285

下面我给出简单的配置方法：
1. vi /etc/sysconfig/network-scripts/ifcfg-bond0  #用户以后要用到的逻辑接口，配置dns,gateway正对此接口就行
DEVICE="bond0"
BOOTPROTO="none"

IPADDR=192.168.0.60
NETMASK=255.255.255.0
USERCTL=no
BONDING_OPTS="mode=1 miimon=50"    #选择工作模式，检测时间间隔
2. vi /etc/sysconfig/network-scripts/ifcfg-eth0  #eth0,eth1隶属于bond0,绑定配置好后，用户不再担心其配置，
DEVICE="eth0"                                    #只需要在发生故障时，替换新的网卡即可！
BOOTPROTO="none"

MASTER=bond0
SLAVE=yes
USERCTL=no
3. vi /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE="eth1"
BOOTPROTO="none"

MASTER=bond0
SLAVE=yes
USERCTL=no
4. 配置系统加载 binding 模块:
vi /etc/modprobe.d/bonding.conf
alias bond0 bonding
5.附加 Slave 接口到 bond0 :
vi /etc/rc.d/rc.local
ifenslave bond0 eth0 eth1
6.重启主机测试：
cat /proc/net/bonding/bond0
关掉活动的网卡，再
cat /proc/net/bonding/bond0
