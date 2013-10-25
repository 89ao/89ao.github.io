---
layout: post
title: "ubuntu-12.04-LTS-JeOS安装"
categories:
- Linux 
tags:
- JeOS


---


>ubuntu8.04-JeOS.iso出来之后一直备受好评和追捧，用的时候也觉得非常的干净和清爽，特别是在虚拟机里安装的时候非常方便部署，可惜这么多年过去了，Ubuntu没有再出更高的JeOS版本，所幸我们还是有办法安装的，为了方便，可以按照本文的流程安装之后将它制作成模板，这样在以后安装的时候无疑会非常的方便。

需要一个Ubuntu-12.04-LTS镜像

如果我们按照常规的方式安装的话，就算只安装一个基本系统，整个安装下来至少要花费740M左右的空间，而经过我们的定制之后，将指挥安装那些要运行起来一个Linux需要的包，这种方法占用的空间将只有60M！

从CD启动，选择'Rescue broken system'，经过一些默认选项之后会得到一个busybox终端。

首先我们给硬盘分区：

1. 建立一个140-200MB的pagefile(磁盘类型82)作为swap，其他的空间全部做成根分区。
2. 格式化分区：`mkfs.ext4 /dev/sda1`，`mkswap /dev/sda2` 
3. 将根分区挂载到某一个将要对其操作的目录`mkdir /target; mount /dev/sda1 /target`

接下来我们安装基本系统

1. 输入命令`debootstrap --variant=minbase precise /target`
2. 用chroot对新的系统文件进行操作：`chroot /target ; apt-get update ;apt-get install linux-virtual/linux-generic`,Linux-virtual会安装虚拟系统，linux-generic会安装引导和内核，二选一安装即可。
3. 这个时候它会告诉你grub没有安装，我们一会再来安装，首先给root用户设置一个密码`passwd root`，然后安装相应的包`apt-get install net-tools vim-tiny grub-pc` ，然后删除一些不需要的包`apt-get remove linux-firmware locales ; apt-get autoremove`
4. 输入`exit`退出chroot，安装引导`grub-installer /dev/sda`，然后重启，会提示你登陆。

清理以及打包

在执行`grub-install --root-directory=/target /dev/sda`之后，关机，退出光盘，然后开机，在BIOS信息过去之后按`ESC`，进入grub菜单，按`e`编辑以linux开头的那一行行，删掉`UUID=....`，修改成`root=/dev/sda1`，然后按`Ctrl-X`执行。
这个时候会告诉你设备未找到，不过不影响，机器能正常启动，在进入系统之后执行`grub-serup /dev/sda`;`grub-mkconfig > /boot/grub/grub.conf` 和 `grub-install /dev/sda`，现在重启，会提示登陆。

当然你也可以从[这里](http://virtuall.eu/download-document/ub1204lts-jeos.zip)下载制作好了的虚拟机镜像，只要导入Vbox或者VMWARE即可开机使用，注意如果主机不支持VT-x或者AMD-V，要在虚拟机设置中关掉，并设置成只有一个V-cpu。






