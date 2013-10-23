---
author: pandao
comments: false
date: 2012-07-14 16:00:22+00:00
layout: post
slug: x-window-system-works
title: X Window System运行原理
thread: 137
categories:
- linux
---

X Window System的组成能够分为X server，X client，X protocol三部分。X server主要控制输入输出，维护字体，颜色等相关资源。他接受输入设备的输入信息并传递给X client，X client将这些信息处理后所返回的信息，也由X server负责输出到输出设备(即我们所见的显示器)上。X server传递给X client的信息称为Event，主要是键盘鼠标输入和窗口状态的信息。X client传递给X server的信息则称为Request，主要是需要X server建立窗口，更改窗口大小位置或在窗口上绘图输出文字等。X client主要是完成应用程式计算处理的部分，并不接受用户的输入信息，输入信息都是输入给X server，然后由X server以Event的形式传递给X client(这里感觉类似Windows的消息机制，系统接收到用户的输入信息，然后以消息的形式传递给窗口，再由窗口的消息处理过程处理)。X client对收到的Event进行相应的处理后，假如需要输出到屏幕上或更改画面的外观等，则发出Request给X server，由X server负责显示。
startx主要是置X client和X server所在的位置，并处理相关参数，最后交给xinit处理。能够看出startx 配置X client的位置是先搜寻$HOME/.xinitrc，然后是/etc/X11/xinit/xinitrc；配置X server的位置是先搜寻$HOME/.xserverrc，然后是/etc/X11/xinit/xserverrc。这就解释了我们平常为什么说启动X Window时用户目录下的.xinitrc和.xserverrc文档优先级要高。所以我们用startx命令启动X时，假如用户目录存在.xinitrc和.xserverrc文档，则实际上等价于命令xinit $HOME/.xinitrc — $HOME/.xserverrc 。假如用户目录不存在那两个文档，则等价于xinit /usr/X11R6/lib/X11/xinit/xinitrc — /usr/X11R6/lib/X11/xinit/xserver。别的情况类推。

至于xinit，则根据startx传过来的参数启动X server，成功后根据xinitrc启动X client。
以上即为X Window System的启动过程，startx只是负责一些参数传递，真正的X启动由xinit实现。实际上能够分为启动X server和启动X client两部分。下面在用户目录下构造.xinitrc(即Xclient)和.xserverrc(即X server)文档。在.xserverrc里写入/usr/bin/X11/X :1。.xinitrc里写入/usr/bin/X11/xeyes -display localhost:1。这就是最简单的X server X client了，只但是把屏幕编号从默认的0改为了1，这里X server即是/usr/bin/X11/X 程式，X client即是/usr/bin/X11/xeyes 程式。

总结下单机用startx启动过程吧：

	(1) startx置X client和X server的位置，处理参数并调用xinit
	(2) xinit根据传过来的参数启动X server，成功后呼叫X client
	(3) 根据xinitrc配置相关资源，启动窗口管理器,输入法和其他应用程式等X client程式。
	启动X窗口的分步骤方法：
	(1) xinit
	(2) gnome-session

尚存问题:	
Gnome 和Gnome2 在配置文档和启动过程有何不同	
在Fedora Gnome2中 假如是root用户 /root/.gnome2/ 中是否需要session目录 有何作用	
