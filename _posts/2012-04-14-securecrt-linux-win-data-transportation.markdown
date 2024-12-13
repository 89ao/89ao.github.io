---
author: pandao
comments: false
date: 2012-04-14 02:27:18+00:00
layout: post
slug: securecrt-linux-win-data-transportation
title: 用SecureCRT让Linux和Win之间上传和下载数据
thread: 87
categories:
- linux
---

用SecureCRT (Linux)来上传和下载数据

设置一下上传和下载的默认目录就行

options–>session options–>file transfer 下可以设置上传和下载的目录

剩下的你只要在用SecureCRT 登陆linux终端的时候：

发送文件到windows客户端：sz file1 file2

zmodem接收可以自行启动.

从客户端上传文件到linux服务端：

只要服务端执行 : rz(rz -y)

然后在 SecureCRT 里选文件发送,协议 zmodem

简单吧，如果你以前一直使用ssh，而又没有对外开放ftp服务，你就直接使用这种方式来传输你的文件

SecureCRT 的帮助中copy的：

ZModem is a full-duplex file transfer protocol that supports fast data transfer rates and effective error detection. ZModem is very user friendly, allowing either the sending or receiving party to initiate a file transfer. ZModem supports multiple file (”batch”) transfers, and allows the use of wildcards when specifying filenames. ZModem also supports resuming most prior ZModem file transfer attempts.

rz，sz是便是Linux/Unix同Windows进行ZModem文件传输的命令行工具

PS：Linux上rz/sz这两个小工具安装lrzsz-x.x.xx.rpm即可，Unix可用源码自行 编译，Solaris spac的可以到sunfreeware下载执行码
