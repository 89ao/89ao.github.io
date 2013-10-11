---
author: pandao
comments: false
date: 2013-04-24 05:32:26+00:00
layout: post
slug: esxi-recovery-password
title: esxi恢复密码
thread: 193
categories:
- linux
- Virtualization
---







机房的ESXi4.1密码忘记了，重装太麻烦，就找找恢复密码的方法吧。
基本思路是修改shadow文件，我是这样做的：
1、用linux启动光盘，我用的是CDlinux做的U盘启动
2、到命令行下，运行mount /dev/sda5 /mnt/
3. cp /mnt/state.tgz /tmp/.
4. cd /tmp
tar xvfz state.tgz
tar xvfz local.tgz
5. vi /tmp/etc/shadow
把类似root:x:143434343:12232:9:99999:7
这一行中的143434343给清除
6. rm -f state.tgz local.tgz
tar czvf local.tgz etc
tar czvf state.tgz local.tgz
cp local.tgz /mnt/
7. 重启esxi即可重新设置root密码结束之后又搜索了一下，发现另外一个比较常规一点的方法，备用，下次试试吧


### ESXi 3.5, ESXi 4.x, and ESXi 5.0




Reinstalling the ESXi host is the only supported way to reset a password on ESXi.  Any other method may lead to a host failure or an unsupported configuration due to the complex nature of the ESXi architecture. ESXi does not have a service console and as such traditional Linux methods of resetting a password, such as single-user mode do not apply. 




### ESX 3.x and 4.x







**Note**: This section does not apply to ESXi. See the ESXi section of this article.







To change the password for the root user on an ESX 3.x or ESX 4.x host, you must reboot into single-user mode. To do this, follow these steps:





	
  1. Reboot the ESX host.

	
  2. When the GRUB screen appears, press the space bar to stop the server from automatically booting into VMware ESX.

	
  3. Use the arrow keys to select **Service Console only** (troubleshooting mode).

	
  4. Press the a key to modify the kernel arguments (boot options).

	
  5. On the line presented, type a space followed by the word single.

	
  6. Press Enter. The server continues to boot into single-user mode.

	
  7. When presented with a bash prompt such as sh-2.05b#, type the command passwd and press Enter.

	
  8. Follow the prompts to set a new root user password. For more information, see [Changing an ESX host root password (1004659)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1004659).


	
  9. When the password is changed successfully, reboot the host using the command reboot and allow VMware ESX to boot normally.











[官方Link](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&externalId=1317898&sliceId=1&docTypeID=DT_KB_1_1&dialogID=86810079&stateId=0)
