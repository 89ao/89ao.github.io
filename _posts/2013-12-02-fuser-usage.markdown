---
layout: post
title: "fuser使用笔记"
categories:
- Linux
tags:
- fuser


---

fuser是一个非常好用的工具，最常用的场合是：当挂载的文件系统无法被卸载的时候，找出正在占用它的用户或进程信息，kill掉之后即可卸载。

##常用的例子如下：

无法卸载：

	umount /mount/point
	"/mount/point is buzy".

查询是谁在使用这个目录：

	fuser /mount/point

杀掉这个用户或者进程：

	kill PID
	fuser -k /mount/point

今天在察看文档之后发现它还有其他的用法：

用法1：

##详细察看占用信息

	fuser -v /root/

![](/assets/fuser/fuserv.png)

显示使用者，进程ID，PID，后面的ACCESS=c代表进程的工作目录，后面是具体命令。

access其他选项：

	e:该文件为进程的可执行文件；
	f:该文件被进程打开，默认f不显示；
	F：该文件被进程打开，并写入，默认F不显示；
	r:表示该目录为进程的根目录；
	m：表示进程使用该文件进行内存映射，或者该文件为共享库文件，被进程映射至内存；

##查询socket端口的使用者

	fuser -v -n tcp 22

![](/assets/fuser/fuservp.png)

##察看文件系统的使用者

	fuser -v -m /dev/sda2

![](/assets/fuser/fuservm.png)

##发送其他SIGKILL信号

fuser除了可以发送-k信号之外，还能发送以下信号：

![](/assets/fuser/fuseri.png)

结束所有对某文件系统进行访问的进程

	fuser -ck /data
