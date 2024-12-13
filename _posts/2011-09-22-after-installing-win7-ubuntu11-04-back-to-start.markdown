---
author: pandao
comments: false
date: 2011-09-22 04:47:45+00:00
layout: post
slug: after-installing-win7-ubuntu11-04-back-to-start
title: 安装win7之后找回ubuntu11.04启动
thread: 70
categories:
- linux
---

最近装了ubuntu但是由于在U下游戏性能不佳的原因，想想还是装个双系统好啦，XP在我的EA48上面安装蓝屏，懒得折腾啦，就直接装WIN7，毕竟驱动简单，结果安装之后ubuntu11.04无法启动啦，想了好多办法都不行，最后在网上搜了好多帖子，全部备份了准备一个一个的试试看，结果第一个方法就搞定了。。。果然高端牛逼威武娴熟啊～具体方法如下：

从ubuntu desktop光盘启动之后，进入终端输入命令：sudo fdisk -l (注意是小写的L，不是数字的1，此步用于确定电脑中安装Ubuntu的所在分区的位置，输入以后会输出类似如下信息，找到ID为83的那行，记住/dev/sdaX的情况，比如本人的电脑是/dev/sda3，具体的自己更改)

Disk /dev/sda: 320.1 GB, 320072933376 bytes
255 heads, 63 sectors/track, 38913 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0×30c230c1

Device Boot Start End Blocks Id System

/dev/sda1 * 1 2432 19535008+ 7 HPFS/NTFS

/dev/sda2 2433 35371 264581921+ f W95 Ext’d (LBA)

/dev/sda3 35371 38914 28453888 83 Linux

/dev/sda5 2433 7296 39070048+ b W95 FAT32

/dev/sda6 7297 19455 97667136 b W95 FAT32

/dev/sda7 19456 32641 105916513+ 7 HPFS/NTFS

/dev/sda8 32642 35122 19928601 7 HPFS/NTFS

/dev/sda9 35123 35371 1998848 82 Linux swap / Solaris

然后再输入sudo -i （获得root权限，无需输入密码，方便以下操作）
接着输入mkdir /media/tempdir （创建一个文件夹tempdir，用于挂载刚才的sda3，文件夹名称自定，下面的命令中保持一致即可）

再输入 mount /dev/sda3 /media/tempdir （将sda3挂载于tempdir文件夹下）

下面进入了本次恢复最为关键和激动人心的时刻，在终端输入以下命令：

grub-install –root-directory=/media/tempdir /dev/sda （注意最后，这里是sda，意指硬盘，而不是分区，本步骤用于来重新安装grub2到硬盘的主引导记录【MBR】里面，十分关键！）

输入以后如果出现“Installation finished.No Error Reported.”字符的时候，就表示操作成功。但是现在只成功的一半，还有以下操作才能够完全成功。

重启电脑，就能看到grub2的引导界面了，这时只能用来引导Ubuntu ，还暂时无法引导Windows 7，这时选择进入Ubuntu，再找到并启动终端，在终端输入如下命令：

sudo update-grub2
按照提示输入密码，如果顺利的话，会出现如下类似语句，那就表示成功了。
grub.cfg …
Found Debian background: moreblue-orbit-grub.png
Found linux image: /boot/vmlinuz-2.6.31-15-generic
Found initrd image: /boot/initrd.img-2.6.31-15-generic
Found memtest86+ image: /boot/memtest86+.bin
Found Windows 7 (loader) on /dev/sda1
done
如果没有出现以上类似语句的话，那就在新立得里面搜索grub，可以安装带有Ubuntu标志的那个grub-pc，安装之后，再输入sudo update-grub2更新一下grub2就可以了。

