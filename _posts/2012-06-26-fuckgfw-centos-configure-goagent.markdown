---
author: pandao
comments: false
date: 2012-06-26 08:38:22+00:00
layout: post
slug: fuckgfw-centos-configure-goagent
title: '[FuckGFW]CentOS配置goagent'
thread: 90
categories:
- linux
- 杂七杂八
---

Goagent又是一个基于GAE的FuckGFW利器。

先从goagent的项目网站下载GoAgent。解压后得到local和server两个目录，以pandao为例，将两个目录移动至/goagent这个目录里面

cd /goagent/server切换工作目录到server

python uploader.py输入你的appid和你的用户名密码，上传服务端。

cd /goagent/local切换工作目录到local，使用编辑器修改proxy.ini的appid

vim proxy.ini在首行就是appid=，请将自己刚刚appid填写上，其他可以保持不变。保存。

python proxy.py开始使用goagent代理。(firefox测试通过,chrome未测)

firefox用户安装autoproxy插件，把地址设置成127.0.0.1，端口设置成8087。
chrome用户安装switchysharp插件，然后导入这个设置https://raw.github.com/phus/phus-config/master/SwitchyOptions.bak

如果不能正常登陆twitter/facebook等网站的话就需要导入证书。

firefox：打开FireFox->选项->高级->加密->查看证书->导入证书, 选择local\ca.cer, 勾选“此证书可以标识web站点”，导入。

chrome上的证书导入方法是首先安裝libnss3-tools

sudo apt-get install libnss3-tools然后导入证书

certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n goagent -i /goagent/local/CA.crt
