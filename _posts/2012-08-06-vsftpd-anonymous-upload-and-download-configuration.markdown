---
author: pandao
comments: false
date: 2012-08-06 16:00:33+00:00
layout: post
slug: vsftpd-anonymous-upload-and-download-configuration
title: vsftpd匿名用户上传和下载的配置[转自百度文库]
thread: 131
categories:
- linux
---

抱歉，由于漏写防火墙配置，导致一位朋友配置失败：
防火墙有2种选择，关闭，或者打开但是开放ftp服务，
1：关闭防火墙 services iptables stop
2:打开防火墙,开放ftp服务
services iptables restart
system-config-firewall(-tui) ，勾上ftp的，点击apply，确定，关闭
注：iptables -F并不会关闭防火墙，只是清空系统启动默认生成的规则。
防火墙配置之后，最好重启下vsftp服务。

　　配置要注意三部分，请一一仔细对照：

　　1、vsftpd.conf文件的配置(vi /etc/vsftpd/vsftpd.conf)

　　＃允许匿名用户登录FTP

　　anonymous_enable=YES

　　＃设置匿名用户的登录目录（如需要，需自己添加并修改）

　　anon_root=/var/ftp/pub

　　＃打开匿名用户的上传权限

　　anon_upload_enable=YES

　　＃打开匿名用户创建目录的权限

　　anon_mkdir_write_enable=YES

　　＃打开匿名用户删除和重命名的权限（如需要，需自己添加）

　　anon_other_write_enable=YES

　　#匿名用户的掩码（如需要，需自己添加，含义：如umask是022,这时创建一个权限为666的文件，文件的实际权限为666-022=644）

　　anon_umask=022

　　2、ftp目录的权限设置

　　默认情况下，ftp的根目录为/var/ftp，为了安全，这个目录默认不允许设置为777权限，否则ftp将无法访问。但是我们要匿名上传文件，需要“other”用户的写权限，正确的做法：

　　将ftp目录归属组设为ftp：chgrp ftp /var/ftp

　　一般至此，便实现vsftpd匿名用户的上传下载了。如果还不行，请检查ftp目录的权限，需要ftp组对其有写权限，chmod g+w /var/ftp/pub，或者直接改为777权限，注意，ftp目录是不能改为777的，这是vsftpd的安全措施之一。

　　3、selinux的配置

　　SELinux(Security-Enhanced Linux) 是美国国家安全局（NAS）对于强制访问控制的实现，是 Linux上最杰出的新安全子系统。NSA是在Linux社区的帮助下开发了一种访问控制体系，在这种访问控制体系的限制下，进程只能访问那些在他的任务中所需要文件。SELinux 默认安装在 Fedora 和 Red Hat Enterprise Linux 上，也可以作为其他发行版上容易安装的包得到。

　　出于安全的考虑，不推荐关闭selinux

　　使用getenforce查看当前selinux是否正在运行。

　　不关闭selinux，就要设置selinux的ftp权限。

　　1、使用getsebool -a | grep ftp查看ftp相关设置状态，我们要执行以下操作，

         setsebool -P allow_ftpd_anon_write on

         setsebool -P allow_ftpd_full_access on。

　　2、使用setsebool -P 进行设置。例：setsebool -P allow_ftpd_anon_write=on。

　　　或使用togglesebool进行bool值取反，例如togglesebool　allow_ftpd_anon_write。

　　3、修改selinux安全上下文，先介绍两个命令：

　　　命令1、ls -Z　　ps -Z　　id -Z　　# 分别可以看到文件,进程和用户的SELinux属性

　　　命令2、#chcon 改变SELinux安全上下文

　　　chcon -u [user] 对象

　　　　　　　-r [role]

　　　　　　　-t [type]

　　　　　　　-R 递归

　　　　　　　–reference 源文件 目标文件 # 复制安全上下文

　　　使用方法：

　　　　步骤1、ls -Zd /var/ftp/upload/ 通常会看到：

　　　　　drwxr-xr-x ftp ftp system_u:object_r:public_content_t /var/ftp/upload/

　　　　步骤2、chcon -R -t public_content_rw_t /var/ftp/upload/

　　　　步骤3、ls -Zd /var/ftp/upload/ 如果看到如下信息就OK了：

　　　　　drwxr-xr-x ftp ftp system_u:object_r:public_content_rw_t /var/ftp/upload/

　　最后还是重启下selinux和vsftpd吧，不重启其实也没关系。重新登录到ftp上，应该就能解决问题了。
特别注意，chcon命令修改的上下文，重启失效，生产环境中应使用semanage，请在另外一篇博文中找到，在[这里](http://ihalt.sinaapp.com/2012/08/iptables-selinux-debrief/)

　　另，selinux的图形界面 可由system-config-selinux命令进入。

　　就这些内容了，希望对大家有帮助。
