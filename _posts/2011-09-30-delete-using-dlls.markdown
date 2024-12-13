---
author: pandao
comments: false
date: 2011-09-30 04:51:10+00:00
layout: post
slug: delete-using-dlls
title: 删除占用中的dll的方法
thread: 81
categories:
- 杂七杂八
---

因为dll文件的特性注定了它可能被多个软件调用，这也是dll文件为什么删除不掉的原因——正在使用的文件是当然不可能给你删除的。那么到底是哪个程序在调用这个dll文件呢？如何才能删除这个dll文件呢？下面就手动删除dll文件的方法。

Step 1.在运行里输入cmd进入命令提示符。

step 2.然后输入命令tasklist /m>c:\listdll.txt回车后，在C盘下会出现一个listdll.txt文本文件，这个文件里如图2所示列出了目前运行的各个程序正在调用的dll文件。在用CTRL+F弹出查找框，输入自己要删除的的dll文件，查找出是哪个程序在调用这个dll文件。
step 3.CTRL+ALT+DEL打开Windows资源管理器，结束占用需要删除dll文件的程序或着进程，这时再去删除这个dll文件就很轻松了。

step 4.如果查出来的占用dll文件的进程是svhost.exe文件/进程，这个进程一般系统有7、8个至多，到底是哪个svhost.exe进程占用了这个dll文件呢？这是可以在命令提示符下输入tasklist /svc，当然，你也可以把它输出为文本文件tasklist /svc>C:\listsvc.txt。这时listsvc.txt文件里的svhost.exe会跟出如图3所示的各个进程的PID号。这时就可以具体的根据PID号来结束进程，达到删除dll文件的目的。
