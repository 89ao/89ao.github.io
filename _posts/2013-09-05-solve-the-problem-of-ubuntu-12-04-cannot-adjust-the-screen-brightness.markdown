---
author: pandao
comments: false
date: 2013-09-05 13:15:34+00:00
layout: post
slug: solve-the-problem-of-ubuntu-12-04-cannot-adjust-the-screen-brightness
title: 解决 Ubuntu 12.04 无法调节屏幕亮度的问题
thread: 251
categories:
- linux
---

装好Ubuntu 12.04 后，最喜欢先打开的就是“系统设置”了，因为想把它先初步调节成自己喜欢的样式（当然，想进一步调节的话，就需要借助其他软件了），然后再去慢慢改造它。Ubuntu默认的屏幕亮度为最大，看着很刺眼，所以就想调低一点，但不管怎么调都没什么变化，所以就暂时没去管他，结果，就把它给淡忘了，今天刚好有空，索性就去找了一下解决方法。看来大家都遇到了这个问题，所以解决方法有很多，下面我就写出一种个人认为比较简单的解决方法：



终端输入代码:



1



>sudo gedit /etc/default/grub






在打开文件中找到

>GRUB_CMDLINE_LINUX=""    
改成    
>GRUB_CMDLINE_LINUX="acpi_backlight=vendor“

改好后保存即可



然后升级grub：



>sudo update-grub



重启之。。。按FN就能调节了



用于设定亮度初始值：

终端输入代码:





1


>sudo gedit /etc/rc.local



在打开文件里增加一句（加在exit 0之前）

代码:

>echo 500 > /sys/class/backlight/intel_backlight/brightness

然后保存即可



经过以上方法后，就可以调节屏幕亮度了，而且重启后也不会改变你设定的亮度值，眼睛再也不用在黑夜中忍受光刺之苦了。

不过，我反正是用jockey-gtk换了个驱动就OK了呵呵呵呵呵呵呵呵呵呵....，上面的这么多东西还没测试可行。。。
