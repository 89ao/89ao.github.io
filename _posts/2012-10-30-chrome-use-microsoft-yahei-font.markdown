---
author: pandao
comments: false
date: 2012-10-30 06:12:21+00:00
layout: post
slug: chrome-use-microsoft-yahei-font
title: Chrome使用微软雅黑字体
thread: 161
categories:
- 杂七杂八
---

访问本地计算机的以下目录

WIN7路径：


    
    C:\Users\Username\AppData\Local\Google\Chrome\User Data\Default\User StyleSheets



XP路径在此：


    
    C:\Documents and Settings\Username\Local Settings\Application Data\Google\Chrome\User Data\Default\User StyleSheets



其中Username为你的用户名，找到Custom.css文件之后用记事本打开并添加如下字段：


    
    *{font-family:Arial,"Microsoft Yahei" !important;}



其中Microsoft Yahei为你要设置显示的字体。

若你想给字体再添加一个阴影的显示，只需再添加以下字段：


    
    * {text-shadow: silver 0px 0px 1px !important;}



其中的0px 0px 1px都可以根据个人爱好进行设置。


