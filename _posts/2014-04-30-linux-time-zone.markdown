---
layout: post
title: "Linux查看和修改当前时区"
categories:
- Linux
tags:
- timezone


---


 ##查看/修改Linux时区和时间

##一、时区

1、查看当前时区

	date -R

2、修改设置时区

方法(1)

	tzselect
方法(2) 仅限于RedHat Linux 和 CentOS

	timeconfig
方法(3) 适用于Debian

	dpkg-reconfigure tzdata

3、复制相应的时区文件，替换系统时区文件；或者创建链接文件

	cp /usr/share/zoneinfo/$主时区/$次时区 /etc/localtime
在中国可以使用：

	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

##二、时间

1、查看时间和日期

	date
2、设置时间和日期

将系统日期设定成1996年6月10日的命令

	date -s 06/22/96
将系统时间设定成下午1点52分0秒的命令

	date -s 13:52:00
3、将当前时间和日期写入BIOS，避免重启后失效

	hwclock -w

##三、定时同步时间

	* * * * * /usr/sbin/ntpdate 210.72.145.44 > /dev/null 2>&1

　在Linux中，用于时钟查看和设置的命令主要有date、hwclock和clock。其中，clock和hwclock用法相近，只用一个就行，只不过clock命令除了支持x86硬件体系外，还支持Alpha硬件体系。

查看Linux硬件时间：

	`hwclock`或`clock`或`hwclock –show`或clock –show`

修改Linux硬件时间：

	`hwclock –set –date`或`clock –set –date`

让系统时间与硬件时钟同步，用：

	`hwclock –hctosys`或`clock –hctosys`

相反地，让硬件时钟与系统时间同步：

	`hwclock –systohc`或`clock –systohc`

让系统时间每隔十分钟去同步一下硬件时间。

	[hqw@localhost root]$ vi /etc/crontab    
	SHELL=/bin/bash
	PATH=/sbin:/bin:/usr/sbin:/usr/bin
	MAILTO=root
	HOME=/
	
	# For details see man 4 crontabs
	
	# Example of job definition:
	# .---------------- minute (0 - 59)
	# |  .------------- hour (0 - 23)
	# |  |  .---------- day of month (1 - 31)
	# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
	# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
	# |  |  |  |  |
	# *  *  *  *  * user-name command to be executed
	*/10 * * * * /usr/sbin/ntpdate 210.72.145.44 > /dev/null 2>&1
