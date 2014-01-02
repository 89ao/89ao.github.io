---
layout: post
title: "为Elementary OS添加右键菜单'在此处打开终端'"
categories:
- eOS
tags:
- elementaryOS
- open-terminal

---




ElementaryOS默认的文件浏览器是自己的Pantheon Files，nautilus的右键打开终端大家是不是很怀念呢？那就自己在右键菜单加一个吧。


用你喜欢的编辑器创建一个文件

    sudo vim /usr/share/contractor/terminal.contract

填入以下内容

    [Contractor Entry]
    Name=此处打开终端
    Icon=terminal
    Description=此处打开终端
    MimeType=inode;application/x-sh;application/x-executable;
    Exec=pantheon-terminal -d %U
    Gettext-Domain=pantheon-terminal

OK，搞定。
