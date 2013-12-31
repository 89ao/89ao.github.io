---
author: pandao
comments: false
date: 2013-08-19 03:29:32+00:00
layout: post
slug: my-elementaryos-settings
title: 我的elementaryOS设置
thread: 246
categories:
- linux
- elementaryOS
tags:
- elementaryOS

---

###源什么的就别修改了，默认的就是中国的源，速度还不错。
联网老规矩

    sudo apt-get update && sudo apt-get upgrade


###如果安装时没联网，这个时候需要重新设置下载一次完整的语言包
`系统设置`-`语言支持`-将汉语拖到第一位，点击`应用到整个系统`。
点击`地区格式`，选择`汉语`，应用到整个系统

###附加驱动 jockey-gtk    
点击菜单栏中的附加驱动，如果没有，命令为jockey-gtk,选择一个驱动安装重启即可。 

###安装编译包build-essential

    sudo apt-get install build-essential


- **其他软件推荐**   

>leafpad：简单快速的文本编辑器类似于win下的记事本。    
evince：pdf阅读器，也可以选择mupdf（极简的pdf阅读器）   
remmina：远程桌面   
>vim-gnome vim libreoffice   

一条命令

    sudo apt-get install leafpad evince remmina vim vim-gnome libreoffice

teamviewer:也需要在teamviewer官网下载deb包安装，如有缺少的依赖关系apt-get install即可。     

- **更换浏览器**    

谷歌chromium:

    sudo apt-get install chromium-browser


火狐firefox:

    sudo apt-get install firefox


美化火狐（http://www.elementaryupdate.com/2013/02/elementary-firefox-theme.html）   
美化chrome (http://www.elementaryupdate.com/2013/05/egtk-theme-for-chrome.html)     
我一般安装chrome，到google页面上下载对应版本dpkg -i chrome-xxx.deb即可。

- **PPS：**   

先装mplayer    

    sudo apt-get install mplayer


pps可能会出现的问题，就是一个劲缓冲，这时需要安装一个库

    sudo apt-get install libjpeg62


###添加ppa安装相关软件

    sudo apt-add-repository ppa:versable/elementary-update
    sudo apt-get update


（1）ELEMENTARY TWEAKS
eOS高级设置可以设置一些东西，比如dock，最大化最小化按钮等
安装：

    sudo apt-get install elementary-tweaks


安装好了设置里面会多一个tweaks

（2）WINGPANEL SLIM 
设置顶部panel的 
安装：  

    sudo apt-get install wingpanel-slim


![]({{ site.url }}/assets/wingpanel-slim.png)



（3）INDICATOR SYNAPSE  
顶部panel上加一个搜索按钮

    sudo apt-get install indicator-synapse


![]({{ site.url }}/assets/indicator-synapse.jpg)







（4）一些主题   

>elementary-blue-theme   
elementary-champagne-theme  
elementary-colors-theme 
elementary-dark-theme   
elementary-harvey-theme 
elementary-lion-theme   
elementary-matteblack-theme 
elementary-milk-theme   
elementary-plastico-theme   
>elementary-whit-e-theme 

    安装：sudo apt-get install   <   >

（5）一些图标   

>elementary-elfaenza-icons   
elementary-emod-icons   
elementary-enumix-utouch-icons  
elementary-nitrux-icons 
elementary-taprevival-icons 
>elementary-thirdparty-icons (系统默认图标扩展)  

    安装：sudo apt-get install  <    >

（6）dock主题

    sudo apt-get install elementary-plank-themes


（7）一些壁纸

    sudo apt-get install elementary-wallpaper-collection


（8）搜狗输入法

    sudo add-apt-repository ppa:fcitx-team/nightly
    sudo apt-get update
    sudo apt-get install fcitx-sogoupinyin


###隐藏图标：  
在Applications菜单中有时候会多出来很多没用的图标，虽然没什么实际影响但是很扎眼。    
要隐藏这些图标，需要稍微判断一下：  

    cd /usr/share/applications/
然后执行`ls` ，在列出来的文件中找到自己不想显示的图标对应的.desktop文件。通常文件名和图标文字很相似，所以不会很难找。然后：

    cp XXXXXXX.desktop ~/.local/share/applications/
    vim ~/.local/share/applications/XXXXXXX.desktop
在其中加上一行:    

>NoDisplay=true

保存退出即可    


###笔记本显示屏亮度设定：

    sudo apt-get install xbacklight
然后执行`xbacklight =40%`
40%是我喜欢的亮度，可以随意改


###关于常用的一些快捷键：

>终 端: Ctrl+Alt+T  
打开应用程序：Alt+F2    
窗口切换: Alt+Tab   
工作区切换: Super+Tab 或 Super+1 Super+2 (这里的数字都是大键盘上的)     
Ps.开始菜单键在linux中是成为Super,我这里就用Super了.    
打开所有的窗口预览: Super+A 
窗口和工作区预览：Super+S   
移动到第一个工作区: Super+Home  
移动到最后一个工作区: Super+End 
放大窗口：Super + '+' (大、小键盘+号)   
>缩小窗口：Super + '-' (大、小键盘-号)  
