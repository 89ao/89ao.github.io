---
author: pandao
comments: false
date: 2013-08-15 06:42:27+00:00
layout: post
slug: testing-IO-speed-on-linux
title: linux下测试磁盘的读写IO速度
thread: 224
categories:
- linux
tags:
- 性能
---

time有计时作用，dd用于复制，从if读出，写到of。if=/dev/zero不产生IO，因此可以用来[测试](http://softtest.chinaitlab.com/)纯写速度。同理of=/dev/null不产生IO，可以用来[测试](http://softtest.chinaitlab.com/)纯读速度。bs是每次读或写的大小，即一个块的大小，count是读写块的数量。

1.测/目录所在磁盘的纯写速度：

time dd if=/dev/zero bs=1024 count=1000000 of=/1Gb.file

2.测/目录所在磁盘的纯读速度：

time dd if=/1Gb.file bs=64k |dd of=/dev/null

3.测读写速度：

time dd if=/1Gb.file of=/data0/2.Gb.file bs=64k

理论上复制量越大测试越准确。



有时候我们在做维护的时候，总会遇到类似于IO特别高，但不能判定是IO瓶颈还是软件参数设置不当导致热盘的问题.这时候通常希望能知道[磁盘](http://www.chinabyte.com/keyword/%E7%A3%81%E7%9B%98/)的读写速度，来进行下一步的决策。

下面是两种测试方法：

**　　(1)使用hdparm命令**

这是一个是用来获取ATA/IDE硬盘的参数的命令，是由早期[Linux](http://www.chinabyte.com/keyword/Linux/) IDE驱动的开发和维护人员 Mark Lord开发编写的( hdparm has been written by Mark Lord ， the primary[ developer](http://www.chinabyte.com/keyword/Developer/) and maintainer of the (E)IDE driver for Linux， with suggestions from many netfolk).该命令应该也是仅用于Linux系统，对于[UNIX](http://www.chinabyte.com/keyword/unix/)系统，ATA/IDE硬盘用的可能比较少，一般大型的系统都是使用[磁盘阵列](http://www.chinabyte.com/keyword/%E7%A3%81%E7%9B%98%E9%98%B5%E5%88%97/)的.

使用方法很简单

# hdparm -Tt /dev/sda

/dev/sda：

Timing cached reads： 6676 MB in 2.00 seconds = 3340.18 MB/sec

Timing buffered disk reads： 218 MB in 3.11 seconds = 70.11 MB/sec

可以看到，2秒钟读取了6676MB的缓存，约合3340.18 MB/sec;

在3.11秒中读取了218MB磁盘(物理读)，读取速度约合70.11 MB/sec

**　　(2)使用dd命令**

这不是一个专业的测试工具，不过如果对于测试结果的要求不是很苛刻的话，平时可以使用来对磁盘的读写速度作一个简单的评估.

另外由于这是一个免费软件，基本上×NIX系统上都有安装，对于[Oracle](http://com.chinabyte.com/oracle/)裸设备的复制迁移，dd工具一般都是首选.

在使用前首先了解两个特殊设备

/dev/null 伪设备，回收站.写该文件不会产生IO

/dev/zero 伪设备，会产生空字符流，对它不会产生IO

测试方法：

a.测试磁盘的IO写速度

# time dd if=/dev/zero of=/test.dbf bs=8k count=300000

300000+0 records in

300000+0 records out

10.59s real 0.43s user 9.40s system

# du -sm /test.dbf

2347 /test.dbf

可以看到，在10.59秒的时间里，生成2347M的一个文件，IO写的速度约为221.6MB/sec;

当然这个速度可以多测试几遍取一个平均值，符合概率统计.

b.测试磁盘的IO读速度

# df -m

Filesystem 1M-blocks Used Available Use% Mounted on

/dev/mapper/VolGroup00-LogVol00

19214 9545 8693 53% /

/dev/sda1 99 13 82 14% /boot

none 506 0 506 0% /dev/shm

# time dd if=/dev/mapper/VolGroup00-LogVol00 of=/dev/null bs=8k

2498560+0 records in

2498560+0 records out

247.99s real 1.92s user 48.64s system

上面的试验在247.99秒的时间里读取了19214MB的文件，计算下来平均速度为77.48MB/sec

c.测试IO同时读和写的速度

# time dd if=/dev/sda1 of=test.dbf bs=8k

13048+1 records in

13048+1 records out

3.73s real 0.04s user 2.39s system

# du -sm test.dbf

103 test.dbf

上面测试的数据量比较小，仅作为参考.

相比两种方法：

前者是linux上专业的测试IDE/ATA磁盘的工具，但是使用范围有局限性;(此试验仅仅使用了测试磁盘IO的参数，对于其他参数及解释参考man手册)

后者可以通用，但不够专业，也没有考虑到缓存和物理读的区分，测试的数据也是仅作参考，不能算是权威。
