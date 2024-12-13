---
author: pandao
comments: false
date: 2011-09-20 16:10:48+00:00
layout: post
slug: install-xp-after-ubuntu-tutorial
title: 先安装ubuntu后安装XP的详细教程
thread: 59
categories:
- linux
---

被骗了，我们都被骗了，其实WinXP和Ubuntu双系统共存真的很简单，敢折腾就行，不用什么grub4dos,我没法上网，结果硬是自己折腾出来了，现在分享一下我的经历吧
注：我的方法是由Ubuntu引导，非XP引导
要求：1.有一张liveCD或一个liveUSB（这是关键）
2.有一张XP的安装盘（WinPE在我的机子上不可用，安装在复制完文件后就会跳掉，大家不怕折腾的可以自己试试）
2.有一定的XP和Linux操作基础
3.有一定的英语基础

我本来是整个硬盘都分给Ubuntu的，但最近有需要安装一个XP。

第一步：开始我是把5G的swap分出4G用于安装XP，但是失败，提示大意是mbr找不到还是不可写，想起来XP好象是一定要装在最前面的，于是把25G的/(用于安装ubuntu的分区）分出8G用于安装XP
操作：重启－进入liveCD-系统－系统管理－分区编辑器（liveCD中为英文，大家自己对应着看吧）
选择原本的安装Ubuntu的分区（我是通过容量和已使用量判断的，这样比较不容易出错），在它上面右键－更改大小/移动（Resize/move??)，然后在之前的空余空间中填入8000（单位是MB，这个依你自己的需要填），把上面的可拖动的条子移动到最右边，下面有个打勾的，翻译过来是舍入到柱面，勾上。
OK，你再仔细检查一遍，确认没问题后点击上面的Apply。至此第一步完成
（注：1.多出来的8G空间不要格式化，千万不要，除非你想多一个步骤再进一次liveCD
2.调整分区花的时间会很长，已用空间越大时间越长，我的20min+,大家要有点耐心)

第二步：装入XP安装盘，移动到未分配空间（默认就是第一个），按c建立分区，按ENTER选择在该分区上安装XP
开始安装…装驱动，补丁，常用软件，重启，完成
好了，现在你应该是进不去Ubuntu了的（在我的机子上GhostXP没成功，分区格式化后Ghost也不行，但据说可以的话Ghost成功后就会出现XP和Ubuntu双选项启动，下面的步骤全部可省）。

接下来就是本文的重点了

第三步：重启－进入liveCD－开启终端
输入sudo grub (出现grub>的提示符）
输入find /boot/grub/stage1 (出来的结果会是hd 0,1,不一定是0,1，但按照我上面的做法下来的一般都是。我第一次命令执行到这里就卡住了，后来多试几次，终于成功）
输入root (hd0,1) （hd0,1对应你自己出来的结果）
输入setup (hd0) （也不一定是0，自己注意对应关系）
输入quit （退出）

重启，好了，这时候你应该是进的去Ubuntu，但是没有XP的选项了

现在，重中之重来了
第四步：
进入Ubuntu－终端
输入sudo gedit /boot/grub/menu.lst (打开了menu.lst文件）
把以下的内容复制－粘贴入menu.lst

title Windows XP
root (hd0,0)
makeactive
chainloader +1

位置是在拉到文件最下面，有4个title ubuntu的，插在它们中间就行。我的是

## ## End Default Options ##

title Windows XP
root (hd0,0)
makeactive
chainloader +1

title Ubuntu 9.04, kernel 2.6.28-13-generic
uuid 4e1d85e9-bb61-48e3-b76f-e77376b3c3ae
kernel /boot/vmlinuz-2.6.28-13-generic root=UUID=4e1d85e9-bb61-48e3-b76f-e77376b3c3ae ro locale=zh_CN quiet splash
initrd /boot/initrd.img-2.6.28-13-generic
quiet

title Ubuntu 9.04, kernel 2.6.28-13-generic (recovery mode)
uuid 4e1d85e9-bb61-48e3-b76f-e77376b3c3ae
kernel /boot/vmlinuz-2.6.28-13-generic root=UUID=4e1d85e9-bb61-48e3-b76f-e77376b3c3ae ro locale=zh_CN single
initrd /boot/initrd.img-2.6.28-13-generic

title Ubuntu 9.04, kernel 2.6.28-11-generic
uuid 4e1d85e9-bb61-48e3-b76f-e77376b3c3ae
kernel /boot/vmlinuz-2.6.28-11-generic root=UUID=4e1d85e9-bb61-48e3-b76f-e77376b3c3ae ro locale=zh_CN quiet splash
initrd /boot/initrd.img-2.6.28-11-generic
quiet

title Ubuntu 9.04, kernel 2.6.28-11-generic (recovery mode)
uuid 4e1d85e9-bb61-48e3-b76f-e77376b3c3ae
kernel /boot/vmlinuz-2.6.28-11-generic root=UUID=4e1d85e9-bb61-48e3-b76f-e77376b3c3ae ro locale=zh_CN single
initrd /boot/initrd.img-2.6.28-11-generic

title Ubuntu 9.04, memtest86+
uuid 4e1d85e9-bb61-48e3-b76f-e77376b3c3ae
kernel /boot/memtest86+.bin
quiet

### END DEBIAN AUTOMAGIC KERNELS LIST

注意，排第一个的就是它默认启动的！！
那如果我想默认启动第二个怎么办呢？？
menu.lst往上翻，有一行是
# You can specify ’saved’ instead of a number. In this case, the default entry
# is the entry saved with the command ’savedefault’.
# WARNING: If you are using dmraid do not use ’savedefault’ or your
# array will desync and will not let you boot your system.
default 0

把default 0改成default 1就行
依此类推，第三个就是改成2
我的已经改成1，结合上文的title，这样排版比较美观

保存

好了，现在已经基本上完成了，开机，启动的时候注意提示按ESC试试看，是不是出现5个的选项框了？？这说明我们已经成功了！！

menu.lst里面还有很多可以改的，可以更加个性化grub的启动界面，这些可以自己上网找资料，也可以仔细去读menu.lst的提示

这次折腾学到的东西：
1.不要害怕，死命的折腾吧，大不了重装
2.我可怜的小光驱，liveCD不知道读了几次，强烈建议大家自己做个liveUSB，太伤光驱了
3.折腾的确是有好处的，本文我资料都没翻过，很顺的就写下来了，命令背的好熟…

看在我这么辛苦的份上，大家多顶下吧

Ps:感觉WinVista/7也许也可以用这方法，但没试过，敢折腾的自己来吧

建议实际操作前多读几遍本文，最好能都记下来

祝大家都能成功！！
