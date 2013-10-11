---
author: pandao
comments: false
date: 2012-10-31 18:10:37+00:00
layout: post
slug: ubuntu12-04-to-enter-single-user
title: Ubuntu12.04进入单用户
thread: 163
categories:
- linux
---

在Ubuntu12.04 LTS中，没有其他linux那样的grub画面，那么对我们进入单用户模式有了一点影响。查过资料之后发现，原来是在开机的时候按住SHIFT键，就可以看到grub画面。

开机过程中按shift键，看到grub选择界面之后按e进入编辑模式，在

    
    linux /boot/vmlinuz-3.2.0-29-generic root=UUID=1fb78bfc-a01e-4c97-8f12-6dbae66590fd ro $vt_handoff


中添加single，使其变成

    
    linux /boot/vmlinuz-3.2.0-29-generic root=UUID=1fb78bfc-a01e-4c97-8f12-6dbae66590fd ro <span style="color: #ff0000;">single</span> $vt_handoff


然后按ctrl+x或者F10启动，既可以进入单用户模式。
