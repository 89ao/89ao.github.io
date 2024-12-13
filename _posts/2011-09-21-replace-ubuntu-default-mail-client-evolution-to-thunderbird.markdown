---
author: pandao
comments: false
date: 2011-09-21 09:58:08+00:00
layout: post
slug: replace-ubuntu-default-mail-client-evolution-to-thunderbird
title: 将Ubuntu默认的邮件客户端Evolution替换为Thunderbird
thread: 56
categories:
- linux
---

借鉴整理以下两篇博文： http://brightway.be/2010/09/970.ooxx 　　　　　　　　　　 

　　　　　　　　　　 http://hi.baidu.com/huazhai800/blog/item/2dd41d43c06f151e9213c6fd.html/cmtid/81dd126064ed95d18cb10d24

由于默认的Evolution对于我来说实在不好用，于是只能找方法替换它，可是由于Evolution集成在系统中，所以替换起来稍微麻烦一些。

首先，打开终端，输入以下命令来卸载Evolution：

sudo aptitude remove evolution

接着安装Thunderbird：

sudo apt-get install thunderbird

这时安装的Thunderbird应该是英文版的，为了方便使用需要安装语言包：

打开 “ 系统——>系统管理——>新立得软件包管理器 ”,搜索“thunderbird-locale-zh-cn”，标记并安装。

下面的操作是将Thunderbird集成到系统中，即配置到右上角的“信封”图标的下拉菜单（indicator applet）中：

sudo gedit /usr/share/indicators/messages/applications/thunderbird

然后写下如下代码：

/usr/share/applications/thunderbird.desktop

保存关闭。

这样基本的配置就结束了，但是这时的Thunderbird不具备消息提示功能，我们需要通过为它安装插件来实现这样的功能。

首先，我们需要安装相关的包：

打开 “ 系统——>系统管理——>新立得软件包管理器 ” ，搜索 “ libnotify-bin ” ，标记并应用。

如果不安装就会出现这样的提示：“To see notifications via libnotify, the libnotify-bin package needs to be installed. Please install this package via System->Administration->Synaptic Package Manager.”

接着，下载以下两个插件：

Indicators for Thunderbird 1.1：https://www.bubto.com/2010/libnotify_popups-0.2.1-tb.xpi (发现给的两个链接都找不到了，只有这个可以下载)

MinimizeToTray Plus： https://addons.mozilla.org/en-US/thunderbird/addon/2831/

第二个插件是为了能够使Thunderbird最小化而不在任务栏显示。（也许由于我使用了dock所以第二个插件的功能没能体现）

安装方法：

打开thunderbird->tools（工具）->add-ons（附加组件）->install（安装），选择安装刚刚下载的扩展名是xpi的文件。 

安装完，重启Thunderbird，就可以看到indicator applet里的变化了。

最后想要从indicator applet里删除原来的Evolution可以采用添加Thunderbird的方法，即：

sudo gedit /usr/share/indicators/messages/applications/evolution

之后清空里面的代码即可。

PS：由此可以推出其他indicator applet里的选项应该也是可以用这种方法替换的吧。

