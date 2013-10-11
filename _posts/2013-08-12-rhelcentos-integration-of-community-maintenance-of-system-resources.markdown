---
author: pandao
comments: false
date: 2013-08-12 23:39:57+00:00
layout: post
slug: rhelcentos-integration-of-community-maintenance-of-system-resources
title: RHEL/CentOS系统的社区维护资源整合
thread: 241
categories:
- linux
---

Linux各个发行版的技术上虽然有差别，但一般不至于有很大鸿沟，实际上更复杂的其实是各个发行版的维护社区的工作方式和交流文化的差别，如果不了解去利用相应的社区资源，就会觉得维护这个发行版异常吃力，从而产生“XXX发行版不好用”的错觉。

因为工作原因最近我接触维护的系统多为CentOS，之前对CentOS的印象都是“又古老又难维护”，不过几个月的积累下来，发现RH系的社区资源并不比Debian/Ubuntu的少，只不过是国内的维护文化和他们的相去甚远，几乎无法兼容，以致很多人都缺乏了解，所以觉得需要撰文列举下这些资源。

以下很多第三方仓库都在[Centos Wiki有介绍](http://wiki.centos.org/AdditionalResources/Repositories/)。


## **仓库列表**


维护仓库的通常是一群维护者，有个论坛、邮件列表等，有什么需求，或者有什么BUG，可以直接去和维护者沟通。下面都是列出了主页的一些仓库，留意主页的链接可以找到交流方法了。


### **官方仓库**


默认安装的CentOS的yum，/etc/yum.repos.d/CentOS-Base.repo是基本的源仓库；里面各个仓库名下mirrorlist是官方列表，yum的fastestmirror插件会从其中选择一个来更新；而如果注释了mirrorlist写baseurl，就只从这一个仓库更新了。可以参考[163源的CentOS5-Base-163.repo](http://mirrors.163.com/.help/CentOS6-Base-163.repo)。

这些是CentOS/RedHat官方维护的，就是那些“老旧过时”而且“几乎什么都没”，只要不是出现严重漏洞都不会更新那些。


### **FedoraProject for EPEL**


Fedora和Redhat的关系就不详述了，就是FedoraProject里有个“EPEL Special Interest Group”，为EPEL系维护的一个社区仓库，基本上加上这个仓库后就能丰富了整个EPEL生态了，在Debian系里面“理所当然源里就有”的那些软件就会有了，比如openvpn，htop，ipcalc，git ... 虽然版本不会很新，但起码能用了。

用法：安装这些链接页面里面的.rpm。



	
  * [EPEL 5](http://download.fedoraproject.org/pub/epel/5/i386/repoview/epel-release.html)

	
  * [EPEL 6](http://download.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html)




### **RPM Fusion**





	
  * [http://rpmfusion.org/](http://rpmfusion.org/)


这个仓库说提供的是FedoraProject跟RedHat都不想提供的程序，提供的分类就知道怎么回事了，基本都是Sound and Video，Games and Entertainment，Hardware Support等等。首先是Linux平台下多媒体支持方面的版权问题非常复杂，ffmpeg/x264等通常都有一些争议行的授权，当然也有nvidia/ati等硬件的闭源驱动、Oracle的闭源版Virtualbox等，把他们独立出来避免争端。

另外这个仓库基本提供的更新都是for Fedora，EPEL5/6的几乎没更新。可以说RPMFusion是个“桌面仓库”，而且国内163源[提供了RPMFusion的镜像](http://mirrors.163.com/rpmfusion/)

用法： 见[Configuration](http://rpmfusion.org/Configuration)


### **RepoForge**





	
  * [RepoForge](http://repoforge.org/)


原叫RPMForge，和CentOS社区较紧密，提供的包也比较海量的，很难评价分什么方向，[CentOS Wiki专门有页面提供安装指导](http://wiki.centos.org/AdditionalResources/Repositories/RPMForge)，因为包的数量太海量了很难和“FedoraProject for EPEL”做比较。

用法： 见[Usage](http://repoforge.org/use/)


### **Remi**





	
  * [Les RPM de Remi - Repository](http://rpms.famillecollet.com/)


这个仓库依赖EPEL。

提供了php54 / mysql55 / firefox 等等的更新，选的软件比较符合Web开发者工作的需要，当然服务器最好也是维护相同版本。这个仓库使用了github来管理软件包的spec，可以[直接看他提供了什么包](https://github.com/remicollet/remirepo)。更新非常紧贴各个软件的官方发布。

用法： 安装主页相应的remi-release-XX.rpm


### **KBS-Extras**





	
  * [http://centos.karan.org/](http://centos.karan.org/)


CentOS本来的维护团队，有趣的一点是这仓库基本全在-testing里面提供软件包。


### **FedoraHosted - SoftwareCollections**





	
  * [https://fedorahosted.org/SoftwareCollections/](https://fedorahosted.org/SoftwareCollections/)


这是重点推荐的。这不是一个仓库，是很多个。里面的软件包和上述那些仓库不大一样，都是在/opt下建立一套专用的目录，避免在/usr里面打架的软件包；这里提供了php/python/ruby/perl/mysql/postgre/apache等常用“服务器生态”。

用法：各个Collection的repo链接。


### **FedoraHosted**





	
  * [https://fedorahosted.org/web/](https://fedorahosted.org/web/)


上述的只是FedoraHosted内一个子仓库，FedoraHosted是类似Ubuntu的PPA社区的环境，维护者可以通过建立自己的帐号然后建立一些自选软件的仓库。里面应该还有很多有用的东西待发掘。


### **Fedora People Repositories**





	
  * [http://repos.fedorapeople.org/](http://repos.fedorapeople.org/)


一样是类似Ubuntu的PPA，不过这里就多数偏向Fedora的更新，也有些有EPEL6。


### **Pramberger, pp**





	
  * [Pramberger](http://www.pramberger.at/peter/services/repository/)


这个仓库主要提供EPEL 3/4/5等旧版本的一些包的更新，有php，python的第三方模块、qt、squid等的更新，大概还是偏向更新服务器环境的吧。

用法：保存http://devel.pramberger.at/getrepo?release=到/etc/yum.repos.d，注意替换release参数(3|4|5)。


### **ELRepo**





	
  * [http://elrepo.org/tiki/tiki-index.php](http://elrepo.org/tiki/tiki-index.php)


偏内核的新硬件支持模块。


### **IUS Community Repo**





	
  * [http://iuscommunity.org/](http://iuscommunity.org/)


提供PHP, Python, MySQL更新，不过感觉更新不够Remi紧密。


## PS.维护技巧




### **yum的仓库选择**


/etc/yum.repos.d/下的文件记录着各个仓库的信息，上述很多仓库在安装之后会在这里生成一个.repo，但里面的仓库不一定被启用了，里面可能写了enabled=0。

一般来说，为了避免系统升级时候和第三方的包出现冲突，第三方的仓库都应该enabled=0，在需要使用、查找其中软件时候，使用yum的参数：

yum --enablerepo=remi install firefox-langpack-fr


### **下载SRPM**


一定需要定制编译特定软件时候，这些仓库都提供SRPM仓库的，但是默认可能没开启。（yumdownloader需要安装yum-utils）

yumdownloader --enablerepo=epel-source --source php


### **Yum/Rpm常用命令**





	
  * [http://yum.baseurl.org/wiki/YumCommands](http://yum.baseurl.org/wiki/YumCommands)

	
  * [http://yum.baseurl.org/wiki/RpmCommands](http://yum.baseurl.org/wiki/RpmCommands)

	
  * [http://yum.baseurl.org/wiki/RepoQuery](http://yum.baseurl.org/wiki/RepoQuery)

	
  * [http://yum.baseurl.org/wiki/Guides](http://yum.baseurl.org/wiki/Guides)




### **Rpm/dpkg、yum/apt-get对照**


[http://www.pixelbeat.org/docs/packaging.html](http://www.pixelbeat.org/docs/packaging.html)

via [http://os.51cto.com/art/201306/400424.htm](http://os.51cto.com/art/201306/400424.htm)
