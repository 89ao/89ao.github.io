---
layout: post
title: "JeOS制作工具制作centos5.x JeOS镜像"
categories:
- Linux
tags:
- JeOS


---


[Orange JeOS](http://orangejeos.sourceforge.net/)是一个非常好用的制作CentOS5.x JeOS镜像的工具，可惜项目貌似是停止开发了，那就在实验环境的时候做个CentOS-5-JeOS.iso吧

首先去项目地址下载安装文件安装：

注意，该rpm依赖如下：

- Runs on a CentOS 5 or RHEL 5 system
- Requires 900 MB of free disk space
- Requires the following packages:
- bash, anaconda, anaconda-runtime, wget, rpm-build, yum-utils, syslinux
- Initally requires an internet connection (for repository access)

执行命令如下：

	rpm -Uvh oj-builder*.noarch.rpm
	mkdir -p $HOME/oj_builder
	cd $HOME/oj_builder
	
修改/usr/share/oj-builder/build_oj.sh中的源地址为163的源以便它下载的时候更快一点。

	bash /usr/share/oj-builder/build_oj.sh core

完成之后会在`$HOME/oj_builder`下生成相关的文件，不再赘述。
