---
author: pandao
comments: false
date: 2013-05-03 01:32:46+00:00
layout: post
slug: modify-selinux-user-vsftpd-chroot-to-normal-login
title: 修改selinux使vsftpd用户chroot之后能正常登陆
thread: 196
categories:
- linux
---

在开启SELinux和防火墙的情况下，修改vsftpd用户的家目录为/home/xxx之后会导致问题。FTP登录报错：500 OOPS: cannot change directory。

回顾一下冲突过程：
1. 为锁定用户在自己的home目录中，在vsftpd.conf打开chroot_local_user。
这样FTP登录用户的“/”，就是passwd中的home path，比如/var/www/xxx/。避免FTP用户跑到/etc乱闯。这样设置过，FTP登录时，会自动执行CWD /var/www/xxx，并且把这个目录设置为FTP进程的根目录，用户就无法离开了。


vi /etc/vsftpd/vsftpd.conf# You may specify an explicit list of local users to chroot() to their home
# directory. If chroot_local_user is YES, then this list becomes a list of
# users to NOT chroot().
chroot_local_user=YES
# chroot_list_enable=YES
# (default follows)
# chroot_list_file=/etc/vsftpd/chroot_list
# 当然也可以用chroot_list_enable=YES的办法。但要逐个在chroot_list中指定FTP用户名，很麻烦。也容易出现疏漏。所以还是推荐用chroot_local_user来限制。


2. 下面，问题就出来了。打开SELinux后，SELinux会阻止ftp daemon读取用户home目录。所以FTP会甩出一句 “500 OOPS: cannot change directory”。无法进入目录，出错退出。

解决办法有两个：

1. 降低SELinux安全级别，把enforcing降低到permissive


vi /etc/sysconfig/selinux# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#       enforcing - SELinux security policy is enforced.
#       permissive - SELinux prints warnings instead of enforcing.
#       disabled - SELinux is fully disabled.
SELINUX=permissive


这时FTP的登录功能就正常了。但降低整体系统安全作为代价来解决一个小问题，这总不是最佳方案。

2. 同时，也有另一个更理想的办法。首先查看SELinux中有关FTP的设置状态：


getsebool -a|grep ftpallow_ftpd_anon_write --> off
allow_ftpd_full_access --> off
allow_ftpd_use_cifs --> off
allow_ftpd_use_nfs --> off
allow_tftp_anon_write --> off
ftp_home_dir --> off
ftpd_connect_db --> off
ftpd_disable_trans --> on
ftpd_is_daemon --> on
httpd_enable_ftp_server --> off
tftpd_disable_trans --> off


经过尝试发现，打开ftp_home_dir或者 allow_ftpd_full_access 。都可以达到在enforcing级别下，允许FTP正常登录的效果。


setsebool -P ftp_home_dir 1
#CentOS6里，是这样
setsebool -P allow_ftpd_full_access 1




service vsftpd restart


加-P是保存选项，每次重启时不必重新执行这个命令了。最后别忘了在/etc/sysconfig/selinux中，修改SELINUX=enforcing。
