---
author: pandao
comments: false
date: 2010-03-03 01:36:22+00:00
layout: post
slug: flatpress-change-password
title: Flatpress如何修改密码
thread: 15
categories:
- Blog相关
---

本来拿来主义作祟想直接GOOGLE一下先贤使用 FlatPress的经验的，但是在多方面搜索了之后都没有找到答案的情况下，心想还是听毛主席的话：自己动手丰衣足食吧。于是直接驱OPERA上了WIKI，根据作者的说法

    
    I've lost my password!
    
    Delete %%setup.lock from fp-content/ backup your fp-content/config/ if you heavily customized FlatPress and then restart setup (point to index.php or setup.php); once asked create a user with the same username of the old one and it will be overwritten. Restore your config/ dir backup once done.


言下之意您想修改密码是没可能了，想修改密码的话，您还是“重装”下吧。按照作者的说法，请先删除“fp-content/”目录下的“%%setup.lock”，备份“fp-content/config/”目录下的所有文件，然后返回主页重新启动安装(index.php或者setup.php),当要求你创建一个用户的时候，输入旧的用户名，密码就会被覆盖了。接下来还原“fp-content/config/”目录下的文件，搞定。

晕…原来这么麻烦的，不过转念一想，作者这样设计不是具有最好的安全性么，这个思路值得思考一下。
