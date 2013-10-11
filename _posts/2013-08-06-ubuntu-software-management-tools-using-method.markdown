---
author: pandao
comments: false
date: 2013-08-06 23:22:02+00:00
layout: post
slug: ubuntu-software-management-tools-using-method
title: Ubuntu 软件管理的工具使用方法
thread: 231
categories:
- linux
---

使用Ubuntu的第一步就是应该学会如何管理软件。以下几种方法是目前我用到的，整理一下，怕时间久了就会忘记。

**一、APT命令安装**

APT全称Advanced Packaging Tool，可以自动下载，配置，安装二进制或者源代码格式的软件包，因此简化了Linux系统上管理软件的过程。现在Debian和其衍生发行版（如Ubuntu）中都包含了APT。APT命令（package 为软件包名称）：

    
    apt-cache search package 搜索包
    apt-cache show package 获取包的相关信息，如说明、大小、版本等
    sudo apt-get install package 安装包
    sudo apt-get install package –reinstall 重新安装包
    sudo apt-get -f install 强制安装
    sudo apt-get remove package 删除包
    sudo apt-get remove package –purge 删除包，包括删除配置文件等
    sudo apt-get autoremove 自动删除不需要的包
    sudo apt-get update 更新源
    sudo apt-get upgrade 更新已安装的包
    sudo apt-get dist-upgrade 升级系统
    sudo apt-get dselect-upgrade 使用 dselect 升级
    apt-cache depends package 了解使用依赖
    apt-cache rdepends package 了解某个具体的依赖
    sudo apt-get build-dep package 安装相关的编译环境
    apt-get source package 下载该包的源代码
    sudo apt-get clean && sudo apt-get autoclean 清理下载文件的存档
    sudo apt-get check 检查是否有损坏的依赖


除了要了解基本的apt指令外，还需要了解下一些与APT相关的文件，具体每个文件作用如下：

    
    /etc/apt/sources.list 设置软件包的获取来源
    /etc/apt/apt.conf apt配置文件
    /etc/apt/apt.conf.d apt的零碎配置文件
    /etc/apt/preferences 版本参数
    /var/cache/apt/archives/partial 存放正在下载的软件包
    /var/cache/apt/archives 存放已经下载的软件包
    /var/lib/apt/lists 存放已经下载的软件包详细信息
    /var/lib/apt/lists/partial 存放正在下载的软件包详细信息


**二、DPKG命令安装**

dpkg是Debian软件包管理器的基础，被用于安装、卸载和供给和.deb软件包相关的信息。dpkg本身是一个底层的工具，本身并不能从远程包仓库下载包以及处理包的依赖的关系，需要将包从远程下载后再安装。DPKG常用命令：

    
    dpkg -i package.deb 安装包
    dpkg -r package 删除包
    dpkg -P package 删除包（包括配置文件）
    dpkg -L package 列出与该包关联的文件
    dpkg -l package 显示该包的版本
    dpkg –unpack package.deb 解开 deb 包的内容
    dpkg -S keyword 搜索所属的包内容
    dpkg -l 列出当前已安装的包
    dpkg -c package.deb 列出 deb 包的内容
    dpkg –configure package 配置包


注意：更多选项可通过 dpkg -h 查询，有些指令需要超级用户权限才能执行。

**三、Synaptic Package Manager（新立得软件包管理器）**

由于synaptic是GUI界面的，没啥命令好说的，其实这个在Ubuntu里面也挺少用到的，更多的还是通过apt-get命令就可以搞定。

**四、aptitude命令**

与apt类似的管理工具，在管理依赖方面相比apt要强，目前官方已经不推荐，可能是由于64位的系统安装32的库会出现问题导致的。

除了上面讲解的几种，其实在Ubuntu安装软件过程中还是会遇到一些问题。比如：

1、如何安装下载下来是.tar.gz的软件？

tar.gz或者.tar.bz2一般情况下都是源代码的安装包，对于此种类型的软件包，一般先要通过命令将压缩包解压，然后才能进行编译，继而进行安装。以.tar.gz格式为例，我们先要执行 tar -zxvf FileName.tar.gz 以解压软件包，然后通过执行 ./configure 来进行配置，执行 make 来进行编译，执行 sudo make install 。执行完成后，即可完成软件的编译和安装。使用 make clean 删除安装时产生的临时文件。

2、如何安装下载下来是.bin的软件？

扩展名为.bin文件是二进制的，它也是源程序 经编译后得到的机器语言。后缀为.bin 的一般是一些商业软件。安装起来也非常的简单。第一步，进入程序目录，执行：sudo chmod +x xxx.bin，即修改文件为可执行。第二步，运行：sudo ./xxx.bin，这时程序就进去安装了。

3、如何安装下载下来是.rpm的软件？

.rpm格式是Red Hat Package Manager的简称，是由Red Hat公司推出的，在Ubuntu上不能安装.rpm格式的软件包，一般用alien把rpm转换为deb格式后再安装。Ubuntu没有默认安装alien，所以先安装alien，命令为：sudo apt-get install alien 然后用alien命令进行转换：sudo alien xxx.rpm 这一步以后会生成一个同名的xxx.deb文件， 然后就可以双击或者通过dpkg命令安装了。
