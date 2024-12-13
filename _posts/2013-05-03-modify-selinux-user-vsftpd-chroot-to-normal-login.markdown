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

在开启 SELinux 和防火墙的情况下，修改 vsftpd 用户的家目录为/home/xxx 之后会导致问题。FTP 登录报错：500 OOPS: cannot change directory。

回顾一下冲突过程：

1. 为锁定用户在自己的 home 目录中，在 vsftpd.conf 打开 chroot_local_user。

这样 FTP 登录用户的“/”，就是 passwd 中的 home path，比如/var/www/xxx/。避免 FTP 用户跑到/etc 乱闯。这样设置过，FTP 登录时，会自动执行`CWD /var/www/xxx，`并且把这个目录设置为 FTP 进程的根目录，用户就无法离开了。

`vi /etc/vsftpd/vsftpd.conf`

    # You may specify an explicit list of local users to chroot() to their home
    # directory. If chroot_local_user is YES, then this list becomes a list of
    # users to NOT chroot().
    chroot_local_user=YES
    # chroot_list_enable=YES
    # (default follows)
    # chroot_list_file=/etc/vsftpd/chroot_list
    # 当然也可以用chroot_list_enable=YES的办法。但要逐个在chroot_list中指定FTP用户名，很麻烦。也容易出现疏漏。所以还是推荐用chroot_local_user来限制。

2. 下面，问题就出来了。打开 SELinux 后，SELinux 会阻止 ftp daemon 读取用户 home 目录。所以 FTP 会甩出一句 “500 OOPS: cannot change directory”。无法进入目录，出错退出。

解决办法有两个：

1. 降低 SELinux 安全级别，把 enforcing 降低到 permissive

`vi /etc/sysconfig/selinux`

    # This file controls the state of SELinux on the system.
    # SELINUX= can take one of these three values:
    #       enforcing - SELinux security policy is enforced.
    #       permissive - SELinux prints warnings instead of enforcing.
    #       disabled - SELinux is fully disabled.
    SELINUX=permissive

这时 FTP 的登录功能就正常了。但降低整体系统安全作为代价来解决一个小问题，这总不是最佳方案。

2. 同时，也有另一个更理想的办法。修改 selinux 的布尔值

首先查看 SELinux 中有关 FTP 的设置状态：

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

经过尝试发现，打开 ftp_home_dir 或者  allow_ftpd_full_access 。都可以达到在 enforcing 级别下，允许 FTP 正常登录的效果。

    setsebool -P ftp_home_dir 1

CentOS6 里，是这样

    setsebool -P allow_ftpd_full_access 1

    service vsftpd restart

加-P 是保存选项，每次重启时不必重新执行这个命令了。最后别忘了在/etc/sysconfig/selinux 中，修改 SELINUX=enforcing。
