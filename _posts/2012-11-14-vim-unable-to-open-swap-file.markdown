---
author: pandao
comments: false
date: 2012-11-14 08:19:35+00:00
layout: post
slug: vim-unable-to-open-swap-file
title: vim:Unable to open swap file
thread: 164
categories:
- linux
---

用VIM打开任何一个文件时，总会出现如下错误信息提示：


 Unable to open swap file for "[Filename]", recovery impossible，balabala在网络上搜索之后发现是错误303，






:help E303
输出相关信息如下：
Unable to open swap file for "{filename}", recovery impossible
 
Vim was not able to create a swap file.  You can still edit the file, but if
Vim unexpected exits the changes will be lost.  And Vim may consume a lot of
memory when editing a big file.  You may want to change the 'directory' option
to avoid this error.  See |swap-file|.继续在命令行模式下执行：
:set directory?
输出相关信息如下：
directory=~/tmp
问题原来如此，在~/目录下没有tmp目录

mkdir ~/tmp






重试错误提示信息即可消失~
