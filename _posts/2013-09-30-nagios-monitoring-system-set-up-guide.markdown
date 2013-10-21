---
author: pandao
comments: false
date: 2013-09-30 08:39:29+00:00
layout: post
slug: nagios-monitoring-system-set-up-guide
title: Nagios 监控系统架设全攻略
thread: 261
categories:
- linux
---


**简介：** Nagios 全名为（Nagios Ain’t Goona Insist on Saintood），最初项目名字是 NetSaint。它是一款免费的开源 IT 基础设施监控系统，其功能强大，灵活性强，能有效监控 Windows 、Linux、VMware 和 Unix 主机状态，交换机、路由器等网络设置等。一旦主机或服务状态出现异常时，会发出邮件或短信报警第一时间通知 IT 运营人员，在状态恢复后发出正常的邮件或短信通知。Nagios 结构简单，可维护性强，越来越受中小企业青睐，以及运维和管理人员的使用。同时提供一个可选的基于浏览器的 Web 界面，方便管理人员查看系统的运行状态，网络状态、服务状态、日志信息，以及其他异常现象.

Nagios 结构说明

Nagios 结构上来说， 可分为核心和插件两个部分。Nagios 的核心部分只提供了很少的监控功能，因此要搭建一个完善的 IT 监控管理系统，用户还需要在 Nagios 服务器安装相应的插件，插件可以从 [Nagios 官方网站](http://www.nagios.org/)下载，也可以根据实际要求自己编写所需的插件。Nagios 可实现的功能特性:	

  * 监控网络服务（SMTP、POP3、HTTP、FTP、PING 等）；

	
  * 监控本机及远程主机资源（CPU 负荷、磁盘利用率、进程 等）；

	
  * 允许用户编写自己的插件来监控特定的服务，方便地扩展自己服务的检测方法，支持多种开发语言（Shell、Perl、Python、PHP 等）

	
  * 具备定义网络分层结构的能力，用"parent"主机定义来表达网络主机间的关系，这种关系可被用来发现和明晰主机宕机或不可达状态；

	
  * 当服务或主机问题产生与解决时将告警发送给联系人（通过 EMail、短信、用户定义方式）；

	
  * 可以支持并实现对主机的冗余监控；

	
  * 可用 WEB 界面用于查看当前的网络状态、通知和故障历史、日志文件等；
Nagios 监控实现原理

Nagios 软件需安装在一台独立的服务器上运行，这台服务器称为监控中心，监控中心服务器可以采用 Linux 或 Unix 操作系统；每一台被监视的硬件主机或服务都运行一个与监控中心服务器进行通信的 Nagios 软件后台程序，也可以理解为 Agent 或插件均可。监控中心服务器读取配置文件中的指令与远程的守护程序进行通信，并且指示远程的守护程序进行必要的检查。虽然 Nagios 软件必须在 Linux 或 Unix 操作系统上运行，但是远程被监控的机器可以是任何能够与其进行通信的主机，根据远程主机返回的应答，Naigos 将依据配置进行回应；接着 Nagios 将通过本地的机器进行测试，如果检测返回值不正确，Nagios 将通过一种或多种方式报警；具体原理如下图所示：   

**图 1. Nagios 监控原理图**

![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image003.jpg)Nagios 安装与配置


##Nagios 安装	
__安装前的准备工作__

	清单 1. Nagios 安装前准备操作
	# wget http://apt.sw.be/redhat/el6/en/x86_64/RPMS.dag/rpmforge-release-0.3.6-1.el6.rf.x86_64.rpm
	# rpm --import http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
	# rpm -Uvh rpmforge-release-0.3.6-1.el5.rf.x86.rpm

	
__安装相关软件包__

	清单 2. 安装软件包
	#yum install gd fontconfig-devel libjpeg-devel libpng-devel gd-devel perl-GD \
	openssl-devel php mailx postfix cpp gcc gcc-c++ libstdc++ glib2-devel 
	libtoul-ltdl-devel

	
__创建用户和组__

	清单 3. 创建用户和组
	#groupadd -g 6000 nagios
	#groupadd -g 6001 nagcmd
	#useradd -u 6000 -g nagios -G nagcmd -d /home/nagios -c "Nagios Admin" nagios

	
__编译安装 Nagios__

	清单 4. 编译安装 Nagios
	# tar xzfv nagios-3.2.0.tar.gz
	# cd nagios-3.2.0
	# ./configure --prefix=/usr/local/nagios --with-nagios-user=nagios \
	 --with-nagios-group=nagios --with-command-user=nagios
	 --with-command-group=nagcmd --enable-event-broker --enable-nanosleep 
	 --enable-embedded-perl --with-perlcache
	#make all   
	#make install
	#make install-init 
	#make install-commandmode  
	#make install-webconf   
	make install-config


##安装与配置 Apache

由于 Nagios 提供了 Web 监控界面，可通过 Web 界面的方式可以清晰地看到被监控的主机和资源的运行状态等，因此安装需要安装 Apache 服务。 同时配置 Web 监控界面是需要 PHP 模块的支持，这里均选用当前系统自带软件包即可，也可通过源码包编译安装。

（1）安装 Apache 和 php

	#yum install httpd php*

（2）配置 Apache

在 Apache 配置文件件/etc/httpd/conf/httpd.conf 中找到

	DirectoryIndex index.html index.html.var

将其修改为：

	DirectoryIndex index.html index.php

再在 Apache 配置文件下增加如下内容

	AddType application/x-httpd-php .php

以上两处主要用于增加 php 格式的支持。同时为了安全，需要经过授权才能访问 Nagios 的 Web 监控界面，所以需要在配置文件`/etc/httpd/conf/http.conf` 或 `/etc/httpd/conf.d/nagios.conf` 增加访问控制配置，若定义在 httpd.conf 文件中，将下图的语句加入到 httpd.conf 文件最后面即可.

**图 2. Nagios 访问控制设置**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image005.jpg)

（3）设置用户访问控制

	# htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

设置权限且重启 Apache

	清单 5. 权限设定与启动服务
	#chown nagios:nagcmd /usr/local/nagios/etc/htpasswd.users	
	# usermod -a -G nagios,nagcmd apache
	# /etc/init.d/httpd restart

	
__安装 Postfix 邮件服务__

Nagios 监控平台支持邮件报警功能，所以需要安装邮件服务。这里采用互联网比较主流的 MTA —Postfix. 也可根据自己的生产环境去定义， 如： Sendmail、Qmail 等。由于 Nagios 只用到了 Postfix 的邮件发送功能，所以这里不需要对 Postfix 邮件服务作过多配置，安装 Postfix 套件，启动服务并在下次服务器重启自动加载即可。具体如下命令：

	清单 6. Postifx 安装与配置
	#yum install postifx
	#chkconfig postfix on; /etc/init.d/postfix restart


##安装 Nagios 插件

Naigos 提供的各种监控功能基本上是通过插件来完成的，而 Nagios 的核心指提供了很少的功能，因此安装插件是非常有必要的。Nagios 官网提供了很多不同版块的插件应用，同时插件版本与 Nagios 版本也没有什么关联，如果支持汉化功能，则需要找到与之匹配的汉化软件包，否则会导致部分功能不能完成运行，这里保持默认英文，如下面的安装细节：


	清单 7. Nagios 插件安装
	# wget http://ovh.dl.sourceforge.net/sourceforge/nagiosplug/nagios-plugins-1.4.14.tar.gz
	# tar xzf nagios-plugins-1.4.14.tar.gz 
	# cd nagios-plugins-1.4.14
	# ./configure --with-nagios-user=nagios --with-nagios-group=nagios  \
	--with-command-user=nagios --with-command-group=nagcmd \ 
	--prefix=/usr/local/nagios
	 # make all
	 # make install
	 # chmod 755 /usr/local/nagios

这样 Nagios 的插件就安装完成了，通过查看 Nagios 主程序目录，/usr/local/nagios/linexec 目录下可以看到很多的外部插件执行文件，如下图：

**图 3. Nagios 插件脚本示例**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image007.jpg)


###重启 Nagios 服务


	清单 8. Nagios 与 Apache 服务启动与设定
	#/etc/init.d/nagios restart
	#/etc/init.d/httpd restart
	#chkconfig httpd on; chkconfig naigos on

__禁用 Selinux 和 iptables__
Selinux 和 Iptables 是 Linux 系统提供的安全防护机制，主要用来防护 Linux 系统下的服务或应用程序不受外界安全攻击等。一般企业考虑到 Nagios 监控平台的安全可靠性，都会采用硬件的防火墙或其他安全设备来对服务器进行防护。同时此部分不是此平台描述的重点， 这里就不作过多的阐述

__Nagios 监控平台访问__

到目前为之 Nagios 基本安装成功，若要投入生产环境，还需要安装其他相应的插件及配置，否则是无法提供相应的监控等功能。 通过浏览器，在地址栏输入： http://IPAddress/nagios， 输入用户名及密码即可访问 Naigos 登录界面。

**图 4. Nagios 登录界面**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image009.jpg)

###Nagios 配置

**Nagios 目录与相关配置文件说明**

Nagios 安装完成后，/usr/local/nagios/目录下会生成 nagios 相关目录及配置文件，默认的的配置文件在/usr/local/nagios/etc 目录下。关于详细的描述，见下表：

	**表 1. Nagios 相关目录的名称及用途**
	目录名称	作用
	bin		Nagios 可执行程序所在目录
	etc		Nagios 配置文件目录
	sbin		Nagios cgi 文件所在目录， 也就是执行外部 命令所需要文件所在的目录
	share		Nagios 网页存放路径
	libexec		Nagios 外部插件存放目录
	var		Nagios 日志文件、Lock 等文件所在的目录
	var/archives	Nagios 日志自动归档目录
	var/rw		用来存放外部命令文件的目录

**表 2. 配置文件的作用概述**

	配置文件	说明
	cgi.cfg		控制 CGI 访问的配置文件
	nagios.cfg	Nagios 主配置文件
	resource.cfg	变量定义文件，又称为资源文件，在此文件中定义变量，以便由其他配置文件引用，如$USER1$
	objects		objects 是一个目录，在此目录下有很多配置文件模板，用于定义 Nagios 对象
	objects/commands.cfg	命令定义配置文件，其中定义的命令可以被其他配置文件引用
	objects/contacts.cfg	定义联系人和联系人组的配置文件
	objects/localhost.cfg	定义监控本地主机的配置文件
	objects/printer.cfg	定义监控打印机的一个配置文件模板，默认没有启用此文件
	objects/switch.cfg	监控路由器的一个配置文件模板，默认没有启用此文件
	objects/templates.cfg	定义主机和服务的一个模板配置文件，可以在其他配置文件中引用
	objects/timeperiods.cfg	定义 Nagios 监控时间段的配置文件
	objects/windows.cfg	监控 Windows 主机的一个配置文件模板，默认没有启用此文件

备注:
Nagios 在配置方面非常灵活，默认的配置文件并不是必需的。可以使用这些默认的配置文件，也可以创建自己的配置文件，然后在主配置文件 nagios.cfg 中引用即可。

__Nagios 配置文件间的关联__

Nagios 的配置过程涉及几个定义有:主机、主机组、服务、服务组、联系人、联系人组、监控时间和监控命令等，从这些定义可以看出，Nagios 的各个配置文件之间是互为关联、彼此引用的。成功配置一台 Nagios 监控系统，需要掌握每个配置文件之间依赖与被依赖的关系，可从下面四个步骤来入手，第一步：定义哪些主机、主机组、服务和服务组，第二步：要定义这个监控要通过什么命令实现，第三步：要定义监控的时间段，第四步：要定义主机或服务出现问题时要通知的联系人和 联系人组；强烈建议依据以上顺序对 Nagios 系统进行相关配置。

__Nagios 配置设定__

Nagios 安装成功后，会在/usr/loca/nagios 目下生成相应的主机，服务、命令、模板等配置文件，同时也可看到之前设置的 Nagios 授权目录认证文件 htpasswed.users，而 Object 目录是存放一些配置文件模板，主要用于定义 Nagios 对象，具体如下图：

**图 5. Nagios 配置目录与文件**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image011.jpg)

**图 6. Nagios 对象模板文件**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image013.jpg)

自定义监控目录  

默认情况下 nagios.cfg 会启用一些对象配置文件如：comands.cfg、 contacts.cfg localhost.cfg 、contacts.cfg 、windows.cfg 等，为了更好的对 Nagios 平台的管理与日后的维护，这里采用了自定义目录在/usr/local/nagios/etc/目录下创建一个 monitor 文件夹，用来保存所管理被监控的对象。同时注释 nagios.cfg 配置文件默认定义的对象配置文件，并在 nagios.cfg 文件增加一行：cfg_dir=/usr/local/nagios/etc/monitor 即可， 如下图：

**图 7. Nagios 启用自定义目录**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image015.jpg)

Nagios 的配置大多是对监控对象配置文件进行修改配置，这里需复制了 objects 目录下的所有对象配置文件模板，同时在 monitor 文件下创建了独立的配置文件 hosts.cfg 和 service.cfg 来定义主机和服务，至于联系人和监控的时间段这里保持默认配置。 如下图：

**图 8. 自定义目录下对象配置文件**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image017.jpg)


下面主要描述下此平台架设相关的几个主要配置文件具体含义，分别为：templates.cfg、hosts.cf、services.cfg.

**templates.cfg 文件**   

**表 3. 默认模板配置文件**


	define contact{
	name generic-contact #联系人名称
	service_notification_period 24x7 #当服务出现异常时，发送通知的时间段，时间段是 7x24 小时
	host_notification_period 24x7 #当主机出现异常时，发送通知的时间段，时间段是 7x24 小时
	service_notification_options w,u,c,r #这个定义的是“通知可以被发出的情况”。w 即 warning，表示警告状态，u 即 unknown，表示不明状态，c 即 criticle，表示紧急状态，r 即 recover，表示恢复状态
	host_notification_options d,u,r #定义主机在什么状态下需要发送通知给使用者，d 即 down，表示宕机状态，u 即 unreachable，表示不可到达状态，r 即 recovery，表示重新恢复状态。
	service_notification_commands notify-service-by-email #服务故障时，发送通知的方式，可以是邮件和短信，这里发送的方式是邮件，其中“notify-service-by-email”在 commands.cfg 文件中定义。
	host_notification_commands notify-host-by-email #主机故障时，发送通知的方式，可以是邮件和短信，这里发送的方式是邮件，其中“notify-host-by-email”在 commands.cfg 文件中定义。
	}define host{
	name linux-server #主机名称
	use generic-host #use 表示引用，也就是将主机 generic-host 的所有属性引用到 linux-server 中来，在 nagios 配置中，很多情况下会用到引用。
	check_period 24x7 #这里的 check_period 告诉 nagios 检查主机的时间段
	check_interval 5 #nagios 对主机的检查时间间隔，这里是 5 分钟。
	retry_interval 1 #重试检查时间间隔，单位是分钟。
	max_check_attempts 10 #nagios 对主机的最大检查次数， check_command check-host-alive #指定检查主机状态的命令，其中“check-host-alive”在 commands.cfg 文件中定义。
	notification_period workhours #主机故障时，发送通知的时间范围，其中“workhours”在 timeperiods.cfg 中进行了定义，下面会陆续讲到。
	
	notification_interval 30 #在主机出现异常后，故障一直没有解决，nagios 再次对使用者发出通知的时间。单位是分钟
	notification_options d,u,r #定义主机在什么状态下可以发送通知给使用者，d 即 down，表示宕机状态，u 即 unreachable，表示不可到达状态，r 即 recovery，表示重新恢复状态。
	contact_groups admins #指定联系人组，这个“admins”在 contacts.cfg 文件中定义。
	
	define service{
	name local-service #定义一个服务名称
	use generic-service #引用服务 local-service 的属性信息，local-service 主机在 templates.cfg 文件中进行了定义
	max_check_attempts 4 #最大检测 4 次，为了确定服务最终状态
	normal_check_interval 5 #每 5 分钟检测一次
	retry_check_interval 1 #每 1 分钟重新检测服务，最终的状态能被确定
	}

**host.cfg 文件**

此文件默认情况下不存在，需要手动创建。hosts.cfg 主要用来指定被监控的主机地址及相关属性信息。配置如下表:

**表 4. 定义主机配置实例**

	define host {
	use linux-server #引用主机 linux-server 的属性信息，linux-server 主机在 templates.cfg 文件中进行了定义。
	host_name DirHost162 #被监控主机名alias RHEL6.3_CSDA-FVT-Server #被监控主机别名
	
	address 192.168.1.162 ##被监控主机 IP 地址
	
	}
	........

**services.cfg 文件**

此文件在默认情况下也不存在，需要手动创建。services.cfg 文件主要用于定义监控的服务和主机资源，例如监控 HTTP 服务、FTP 服务、主机磁盘空间、主机系统负载等。


**表 5. 定义服务配置**

	#Define DirHost162
	
	define service{
	use local-service #引用服务 local-service 的属性信息，local-service 主机在 templates.cfg 文件中进行了定义。
	host_name DirHost162 #被监控主机名
	service_description SSH #监控的服务
	check_command check_ssh # nagios 插件监控指令
	}
	
	define service{
	use local-service,services-pnp
	host_name DirHost162
	service_description SSHD
	check_command check_tcp!22 # 使用的检测命令， 同时多个参数匹配用 “!” 分隔，如:check_ping!100.0,20%!500.0,60%
	
	}
	…….


###Nagios 运行与维护

1.验证 Nagios 配置文件的正确性


	#/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfgNagios 

提供的这个验证功能非常有用，如果你的配置文件有语法或配置错误，它会显示出错的配置文件及在文件中哪一行。检测结果中的报警信息通常是可以忽略的，因为一般只是建议性的提示。

2.利用别名简化 Nagios 配置检测机制

在当前用户下的.bashrc 文件增加一行 alias nagioscheck 语句，如下表：

**图 9. 简化 Nagios 配置检测机制**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image019.jpg)

	# source /root/.bashrc

3.启动 Nagios 服务

**清单 9. 通过初始化脚本启动 Nagios**



	#/etc/init.d/nagios start|restart|stop 或者 service nagios start

**清单 10. 手工方式启动 Nagios**


	通过 Nagios 命令的-d 参数来启动 nagios 过护进程。
	#/usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg

Nagios 性能分析图标的作用

Nagios 对服务或主机监控的是一个瞬时状态，有时候系统管理员需要了解主机在一段时间内的性能及服务的响应状态，并且形成图表，这就需要通过查看日志数据来分析。但是这种方式不仅烦琐，而且抽象。为了能更直观的查看主机运行状态，这里采用 PNP 来实现此功能。PNP 是一个小巧的开源软件包，它是基于 PHP 和 Perl 脚本编写，PNP 可以利用 rrdtoul 工具将 Nagios 采集的数据绘制成图表，然后显示主机或者服务在一段时间内运行的状况。以下详细介绍 PNP 安装配置流程：


###安装 RDDtoul 工具

**清单 11. 编译安装 RDDtoul**

	#tar zxvf rrdtoul-1.4.5.tar.gz
	#cd rrdtoul-1.4.5
	#./configure --prefix=/usr/local/rrdtoul
	#make
	#make install

###安装 PNP

**清单 12. 编译安装 PNP**

	#tar zxvf pnp-0.4.13.tar.gz
	#cd pnp-0.4.13
	#./configure\
	  --with-nagios-user=nagios \
	  --with-nagios-group=nagios \
	  --with-rrdtoul=/usr/local/rrdtoul/bin/rrdtoul  \
	  --with-perfdata-dir=/usr/local/nagios/share/perfdata
	#make all
	#make install
	#make install-config
	#make install-init

1. PNP 配置文件定义

在 PNP 安装完成后， 默认安装目录下回自带相应的模板配置文件， 因此只需要参考相应的模板文件进行修改即可，


**清单 13. PNP 配置文件定义**

	# cd /usr/local/nagios/etc/pnp/
	# cp process_perfdata.cfg-sample process_perfdata.cfg
	# cp npcd.cfg-sample npcd.cfg
	# cp rra.cfg-sample rra.cfg
	# chown -R nagios:nagios /usr/local/nagios/etc/pnp2.修改 process_perfdata.cfg 文件

打开 Nagios 下的 process_perfdata.cfg 文件，修改相关内容。可从下图的注释信息了解到

将数字 0 变更为 2 是开启了日志的调试功能，操作如下:
**图 10. 开启日志调试功能**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image021.jpg)

3.修改 Nagios 相关配置文件	
  * 增加小太阳图标

修改 templates.cfg,增加一个定义 PNP 的 host 和 service，详细见下图 ：

**图 11. PNP 配置与设定**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image023.jpg)	

 * 修改 nagios.cfg

如果想让 nagios 将数据输出，首先要修改 nagios 的主配置文件 nagios.cfg，找到如下几项，如有注释的将其去掉。修改后的信息如下：

**清单 14. 增加 nagios 数据输出设置**

	#vim /usr/local/nagios/etc/nagios.cfg
	process_performance_data=1
	host_perfdata_command=process-host-perfdata
	service_perfdata_command=process-service-perfdata

  * 修改 commands.cfg


process-host-perfdata 和 process-service-perfdata 指令声明了 nagios 输出哪些值到输出文件中。 不过这些定义相对简单，而 PNP 提供了一个 Perl 脚本，非常详细地定义了一个输出数据的方法，process_perfdata.pl 其实是 PNP 自带的一个脚本，这个脚本在 PNP 安装完成后会自动生成。因此，可以将 process-host-perfdata 和 process-service-perfdata 指令中对应的执行命令的内容替换成此脚本。增加下图的内容：
**图 12. 在 commands.cfg 文件中增加性能图片配置**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image025.jpg)	

  * 修改 hosts.cfg 与 services.cfg


将 hosts-pnp 和 services-pnp 引用到 hosts.cfg 和 services.cfg 中，修改后的 hosts.cfg 内容如图 13 和图 14 所示：

**图 13. 在 hosts.cfg 文件中增加性能图片配置**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image027.jpg)

**图 14. 在 services.cfg 文件中增加性能图片配置**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image029.jpg)验证性能分析图标功能

访问 nagios 管理界面，点击查看哪台主机小太阳的图标，即可看到此主机的状态信息，这里点击的是 DirHost162 主机，详细如图 15 和图 16 所示：  

**图 15. 被监控主机管理界面**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image031.jpg)

**图 16. 性能图标分析示意图**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image033.jpg)

利用 NRPE 扩展 Nagios 功能

NRPE 是 Nagios 的一个功能扩展，它可在远程 Linux 和 UNIX 主机上执行插件程序。通过在远程服务器上安装 NRPE 构件及 Nagios 插件程序来向 Nagios 监控平台提供该服务器的一些本地情况，如 CPU 负载、内存使用、硬盘使用，服务等。这里将 Nagios 监控平台称为 Nagios 服务器 端，而将远程被监控的服务器称为 Nagios 客户端。

下图为 NRPE 构件监控远程主机本地信息的运行原理:

**图 17. 监控远程主机原理图**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image035.gif)
NRPE 组成部分与检测类型

**NRPE 总共由两部分组成**:

check_nrpe 插件，位于监控主机上

NRPE daemon,运行在远程被监控的 Linux 主机上

当监控远程 Linux/UNIX 主机服务或资源时，工作流程如下：	
  * nagios 会运行 check_nrpe 这个插件，并且会告诉它需要检查什么；

	
  * check_nrpe 插件会连接到远程的 NRPE daemon，所用的方式是 SSL；

	
  * NRPE daemon 会运行相应的 Nagios 插件来执行检查动作；

	
  * NPRE daemon 将检查的结果返回给 check_nrpe 插件，插件将其递交给 Nagios 做处理。


NRPE daemon 需要 Nagios 插件安装在远程的 Linux 主机上，否则 daemon 不能做任何的监控。

**NRPE 的检测类型分为两种:**

**直接检测**：检测的对象是运行 NRPE 的那台 Linux 主机的本地资源，原理如下:

直接使用 NRPE 插件监控远程 Linux/UNIX 主机的本地或者私有资源；如 CPU 负载、内存使用、SWAP 空间使用、硬盘等运行状况。

**图 18. 直接检测结构图**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image037.gif)

**间接检测**：当运行 Nagios 的监控主机无法访问到某台被监控主机，但是运行 NRPE 的机器可以访问得到的时候，运行 NRPE 的主机就充当一个中间代理，将监控请求发送到被监控对象上。

**图 19. 间接检测结构图**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image039.gif)


##在服务器端安装 

###NRPE 安装

**清单 15. 服务器安装 NRPE**



	# cd /usr/local/src/
	# tar zxvf nrpe-2.12.tar.gz 
	# cd nrpe-2.12
	# ./configure && make all
	# make install-plugin
	# make install-daemon
	# make install-daemon-config

修改命令定义文件

由于在 Nagios 命令定义文件 commands.cfg 没有 check_nrpe 命令， 因此需要对此文件进行修改与定义，配置细节如下图：

**图 20. 在 commands.cfg 文件中增加 NRPE 配置**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image041.jpg)
定义被监控主机

在被监控或远程主机上增加 check_nrpe 的相关配置，由于 hosts.cfg 已定义了相应的主机，所以这里编辑文件 Nagios 服务器上的 services.cfg 文件即可

	#vim /usr/local/nagios/etc/monitor/services.cfg**图 21. 在被监控主机，增加 NRPE 指令**

![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image043.jpg)
**查看配置文件是否正确**

**清单 16. 服务器安装 NRPE**

	# nagioscheck**重新加载配置文件**

**清单 17. Ngaios 配置加载**

	# /etc/init.d/nagios reload

在 Linux 客户端安装 NRPE 安装

安装 Nagios 插件 nagios-plugin

添加 nagios 用户名，且不允许 nagios 用户登录， 此用户用于与 Nagios 服务器通信所用。

**清单 18. 客户端安装 nagios-plugin**

	# useradd -s /sbin/nulgin nagios
	# tar -zxvf nagios-plugins-1.4.14.tar.gz
	# cd nagios-plugins-1.4.14
	#./configure
	# make && make install


安装 NRPE

在 Linux 客户端安装 nrpe 程序包，根据编译提示向导完成安装操作。在安装的过程中会看到 NRPE 的端口为 5666，且可通过 Xinetd 服务来控制 nrpe 进程，具体实现步骤如下：


**清单 19. 客户端安装 NRPE**



	#tar zxvf tar zxvf nrpe-2.12.tar.gz
	# cd nrpe-2.12	
	#./configure
	#make all
	#make install-plugin
	#make install-daemon
	#make install-daemon-config
	#make install-xinetd
	#chown -R nagios:nagios /usr/local/nagios/

配置 NRPE

定义被监控的 Linux 主机的对象，监控此主机的 CPU 负载、登录用户数、磁盘分区、进程、swap 使用情况等，编辑/usr/local/nagios/etc/nrpe.cfg 文件， 内容如下示例：


**清单 20. NRPE 配置与设定**

	command[check_users]=/usr/local/nagios/libexec/check_users -w 5 -c 10
	command[check_load]=/usr/local/nagios/libexec/check_load -w 30,25,20 -c 60,55,40
	command[check_sda3]=/usr/local/nagios/libexec/check_disk -w 15% -c 8% -p /dev/sda3
	command[check_vg01]=/usr/local/nagios/libexec/check_disk -w 20% -c 10% -p /dev/vg01
	command[check_zombie_procs]=/usr/local/nagios/libexec/check_procs -w 5 -c 10 -s Z
	command[check_swap_1]=/usr/local/nagios/libexec/check_swap -w 20 -c 10定义 Xinetd 服务支持 nrpe

这里只需要修改 only_from 项，增加 Ngaios 服务的地址即可，这样一来服务器与客户端就可进行 nrpe 会话，监控到 Linux 客户端相关信息，被监控端也更加容易维护管理，见下图：

	#vim /etc/xinetd.d/nrpe**图 22. 定义 Xinetd 服务支持 nrpe**

![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image045.jpg)

定义服务端口

在 Linux 客户端"/etc/services" 文件增加一行

	nrpe	5666/tcp	#Naigos_Client

测试 NRPE

由于 NRPE 相应的插件已经安装成功， 这里使用 check_nrpe 命令来验证是否 nrpe 是否正常运行，如果执行以下命令能够显示 NRPE 的具体版本信息，则表示 nrpe 运行正常，加载重启 xinetd 服务即可。

**清单 21. NRPE 功能测试**

	#/usr/local/nagios/libexec/check_nrpe -H localhost
NRPE v2.12 

	#/etc/init.d/xinetd restart

Nagios 管理平台界面介绍

通过上面所有的软件及插件的安装与配置，Nagios 监控系统架构成功的完成了；若想进一步扩展，如监控 Windows 平台，则需要在 Windowns 系统安装 NSClient 软件，并在 Nagios 服务器定义 windows.cfg 等文件，VMware 则需要 Nagios 官网下载相应的插件及模块文件，并在 Nagios 服务器编辑 command.cfg、hosts.cfg、services.cfg 文件，这里不过多的阐述，可分别参照以下表 6 和表 7 方法来进行：

Window 平台

	#vim /usr/local/nagios/etc/monitor/windows.cfg

**表 6. Windows 平台配置**

	define host{
	use windows-server,**hosts-pnp **
	host_name Windowns Server 2003_192
	alias Remote win2003 192
	address 192.168.1.192
	}
	define service{
	use generic-service,**services-pnp**
	host_name Windowns Server 2003_192
	service_description NSClient++ Version
	check_command check_nt!CLIENTVERSION
	} }
	………

VMware 平台

	# vim/usr/local/nagios/etc/monitor/commands.cfg

**表 7. VMware 平台配置**

	define command{
	command_name check_esx3_host_net_usage
	command_line $USER1$/check_esx3 -H $HOSTADDRESS$ -u $ARG1$ -p $ARG2$ -l net -s usage -w $ARG3$ -c $ARG4$
	}
	define command{
	command_name check_esx3_host_runtime_issues
	command_line $USER1$/check_esx3 -H $HOSTADDRESS$ -u $ARG1$ -p $ARG2$ -l runtime -s issues
	_……_


当前状态界面介绍

通过浏览器访问 Nagios 服务器，从当前页面可以看到当前主机和服务的健康状态，网络运行情况，以及服务与主机的检测时间等，如下图 15，可以看到我的 Nagios 服务器有一台服务器处于宕机状态。

**图 23. Nagios 当前状态界面**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image047.jpg)系统主机界面介绍

点击 Hosts 标签，可以看到 Nagios 服务器监控多少台主机状态及当前主机的活跃状态，从下面图示可以看到监控的主机类型有，Windwos，Linux，Switch，FC-Swith，Storage 等，若想进一步了解每台主机的服务，系统负载等被监控的对象，可以直接点击某个主机，也可点击小太阳图标来查看当前被监控的主机的生成的图表信息。

**图 24. 所有被监控主机界面**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image049.jpg)
下图是主机组页面，可看到 Nagios 服务器将相对应的主机组或监控的对象进行了分组定义，同时可以具体看到当前总共有多少台主机，活跃的主机，服务的健康状态等等

**图 25. 主机组和服务组界面**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image051.jpg)

**报告界面介绍**

图 26，主要是记录一些事件信息，记录某台主机所监控对象的状态，若超出自己定义的配置，则会提示一般警告或严重告警信息，一旦主机恢复则自动告知用户当前主机的状态：

**图 26. 事件报告管理界面**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image053.jpg)
同时可以将事件信息以邮件的方式告知联系人，让其在第一时间了解到服务器的健康状态等信息,及时作出处理，提供服务器的工作效率等,如下图：

**图 27. 邮件通知界面**
![](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/image055.jpg)
关于 Nagios 管理界面详细，可在左侧的导航菜单去查阅相应的具体功能，如：当前状态、拓补图、总览、问题故障、报告、配置等信息，均可根据自己的生产环境来制定。结束语

通过此篇文章描述了 Nagios 监控管理平台的工作原理，以及如何在 Linux 平台部署开源软件的管理平台，掌握 Naigos 配置管理，通过外部插件的方式来对服务对象 Windows 、Linux、 Unix 、 VMware 等平台进行有效的管理与监控，适合运行部门及管理部门的 IT 人员使用，不仅提高了效率同时减少了管理人员未能及时发现问题所带来的的困绕，也提高了生产的环境的可用性。
参考资料

**学习**	
  * [Nagios 基本安装向导](http://wiki.monitoring-fr.org/nagios/nagios-centos-install)：此 wiki 主要记录目前市场主流的开源监控平台，如：Nagios、Centreon、Zabbix、等；从中可获取一些开源监控平台产品的安装以及其他信息。

	
  * [Nagios 的官方网站](http://www.nagios.org/)，从中可以找到 Nagios 产品的特性，支持的平台，一些新的功能以及解决方案：

	
  * [Nagios 插件网站](http://exchange.nagios.org/directory/Plugins)：此网站列出了它所支持的平台，网络协议、应用 如:集群,云计算、数据库、中间件、Haddop 以及其他监控对象等。

	
  * 在 [developerWorks Linux 专区](http://www.ibm.com/developerworks/cn/linux/)寻找为 Linux 开发人员（包括 [Linux 新手入门](http://www.ibm.com/developerworks/cn/linux/newto/)）准备的更多参考资料。


**讨论**	
  * 加入 [developerWorks 中文社区](http://www.ibm.com/developerworks/cn/community/)。查看开发人员推动的博客、论坛、组和维基，并与其他 developerWorks 用户交流。


关于作者
罗俊，IBM CSTL Systems Director 软件工程师，工作方向为虚拟化和 Appliance，关注 Linux 系统及应用架构，虚拟化、云计算等领域

原文链接：[http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/index.html](http://www.ibm.com/developerworks/cn/linux/1309_luojun_nagios/index.html)

