---
layout: post
title: "pidgin/empathy的手机短信插件"
categories:
- pidgin
tags:
- pidgin

---

Pidgin短信是Pidgin/empathy的一个插件。当手机收到短信进，电脑上面有提示；可以在电脑上发手机短信。让你时刻保持在电脑屏幕上，也不会错过短信。目前只支持安卓，wifi连接方式。

![](https://github.com/Simpleyyt/pidgin-libsms/raw/master/ScreenShot/pic3.png)

##功能

PC接收手机短信并提醒。
在PC上发送短信。
更新手机联系人到PC端。

##安装

###手机端

将目录下的`PidginSMS.apk`安装到安卓手机上。

###PC端

编译需要依赖libglib-2.0-dev，可用以下命令安装

	sudo apt-get install libglib2.0-dev

cd到源码目录下，并输入

	sudo make install

便可以完成安装。

##使用

1,安装并打开手机端Pidgin短信应用	
输入用户名（你的手机号或者名字）和密码（用于加密和验证）	
点击开启Pidgin短信服务	

2,在电脑端安装Pidgin插件，打开Pidgin/empathy	
在帐号管理里面添加Pidgin短信/sms帐户（Pidgin里显示Pidgin短信，empathy里显示sms）	
输入的用户名密码应与手机端一致	

3,验证成功后便可以开始使用	
（注：建议用Pidgin, empathy并无离线保存联系人，每次都得更新）	

向作者致敬：simpleyyt@gmail.com


github地址：https://github.com/Simpleyyt/pidgin-libsms

百度网盘：http://pan.baidu.com/s/1mg0nqqc
