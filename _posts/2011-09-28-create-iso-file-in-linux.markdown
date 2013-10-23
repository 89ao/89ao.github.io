---
author: pandao
comments: false
date: 2011-09-28 04:27:25+00:00
layout: post
slug: create-iso-file-in-linux
title: 在linux中创建iso文件
thread: 79
categories:
- linux
---

在Linux系统中，我们可以通过拷贝命令，将光驱上的内容拷贝到一个ISO文件中，如：cp /dev/cdrom xxx.iso	
在Windows系统下，制作ISO必须要一个专用软件如WINISO之类的，没想到在LINUX下这么简单，LINUX果然是好东西。	
在LINUX下，还可以用dd命令制作ISO：`dd if=/dev/cdrom of=/root/rh9-1.iso bs=512`	

在linux制作ISO文件命令:

	1.dd if=/dev/cdrom f=/root/rh1.iso
	2.mkisofs -r -o myiso.iso /dev/cdrom
	3.cp -r /home/user name.iso
	dd if=/dev/cdrom f=/root/rh1.iso
	cat /dev/cdrom >;/root/1.iso
	cp -r /home/user name.iso
	cp /dev/cdrom xxx.iso
	mkisofs	-a -l -J -L -r -o filename.iso /directory

###mkisofs (make iso filesystem)
　　功能说明：建立ISO 9660映像文件。
	　　语　　法：mkisofs [-adDfhJlLNrRTvz][-print-size][-quiet][-A][-abstract ][-b ][-biblio ][-c][-C ][-copyright ][-hide][-hide-joliet ][-log-file ][-m][-M ][-o ][-p][-P ][-sysid ][-V ][-volset ][-volset-size ][-volset-seqno][-x ][目录或文件]
	　　补充说明：mkisofs可将指定的目录与文件做成ISO 9660格式的映像文件，以供刻录光盘。
	　　参　　数：
	　　-a或–all mkisofs通常不处理备份文件。使用此参数可以把备份文件加到映像文件中。
	　　-A或-appid 指定光盘的应用程序ID。
	　　-abstract 指定摘要文件的文件名。
	　　-b或-eltorito-boot 指定在制作可开机光盘时所需的开机映像文件。
	　　-biblio 指定ISBN文件的文件名，ISBN文件位于光盘根目录下，记录光盘的ISBN。
	　　-c 制作可开机光盘时，mkisofs会将开机映像文件中的全-eltorito-catalog全部内容作成一个文件。
	　　-C 将许多节区合成一个映像文件时，必须使用此参数。
	　　-copyright 指定版权信息文件的文件名。
	　　-d或-omit-period 省略文件后的句号。
	　　-D或-disable-deep-relocation ISO 9660最多只能处理8层的目录，超过8层的部分，RRIP会自动将它们设置成ISO 9660兼容的格式。使用-D参数可关闭此功能。
	　　-f或-follow-links 忽略符号连接。
	　　-h 显示帮助。
	　　-hide 使指定的目录或文件在ISO 9660或Rock RidgeExtensions的系统中隐藏。
	　　-hide-joliet 使指定的目录或文件在Joliet系统中隐藏。
	　　-J或-joliet 使用Joliet格式的目录与文件名称。
	　　-l或-full-iso9660-filenames 使用ISO 9660 32字符长度的文件名。
	　　-L或-allow-leading-dots 允许文件名的第一个字符为句号。
	　　-log-file 在执行过程中若有错误信息，预设会显示在屏幕上。
	　　-m或-exclude 指定的目录或文件名将不会房入映像文件中。
	　　-M或-prev-session 与指定的映像文件合并。
	　　-N或-omit-version-number 省略ISO 9660文件中的版本信息。
	　　-o或-output 指定映像文件的名称。
	　　-p或-preparer 记录光盘的数据处理人。
	　　-print-size 显示预估的文件系统大小。
	　　-quiet 执行时不显示任何信息。
	　　-r或-rational-rock 使用Rock Ridge Extensions，并开放全部文件的读取权限。
	　　-R或-rock 使用Rock Ridge Extensions。
	　　-sysid 指定光盘的系统ID。
	　　-T或-translation-table 建立文件名的转换表，适用于不支持Rock Ridge Extensions的系统上。
	　　-v或-verbose 执行时显示详细的信息。
	　　-V

