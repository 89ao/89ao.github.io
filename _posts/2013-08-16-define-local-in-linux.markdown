---
author: pandao
comments: false
date: 2013-08-16 06:01:11+00:00
layout: post
slug: '226'
title: linux下local定义
thread: 226
categories:
- linux
---

1、安装中文语言包
apt-get install language-pack-zh
2、用 vim配置语言环境变量
vim /etc/environment
在下面添加或修改如下变量，类似于这样

    
    LC_NUMERIC="zh_CN.UTF-8"
    LC_TIME="en_US.UTF-8"


这就需要对locale的内部机制有一点点的了解。在前面我已经提到过，locale把按照所涉及到的文化传统的各个方面分成12个大类，这12个大类分别是：
1、语言符号及其分类(LC_CTYPE)
2、数字(LC_NUMERIC)
3、比较和排序习惯(LC_COLLATE)
4、时间显示格式(LC_TIME)
5、货币单位(LC_MONETARY)
6、信息主要是提示信息,错误信息, 状态信息, 标题, 标签, 按钮和菜单等(LC_MESSAGES)
7、姓名书写方式(LC_NAME)
8、地址书写方式(LC_ADDRESS)
9、电话号码书写方式(LC_TELEPHONE)
10、度量衡表达方式(LC_MEASUREMENT)
11、默认纸张尺寸大小(LC_PAPER)
12、对locale自身包含信息的概述(LC_IDENTIFICATION)。
