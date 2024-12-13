---
author: pandao
comments: false
date: 2011-09-20 08:26:38+00:00
layout: post
slug: fix-music-player-characters-in-ubuntu
title: 解决ubuntu中文本乱码和音乐播放器乱码问题
thread: 61
categories:
- linux
---

正式换到ubuntu啦，安装的是11.04，准备先试用一段时间，等11.10出来啦就长期用11.10啦。
换过来啦之后发现本来在win下的txt文件中的汉字变成啦乱码，还有音乐播放器的播放列表里面的东西也是乱码，这样看起来太麻烦啦，所以只有改一改咯，其实只是一个编码问题，具体方法如下：

1.txt乱码问题：
按组合键ALT+F2打开“运行应用程序“对话框，输入 gconf-editor，运行，进入配置编辑器：依次开启 /apps/gedit-2/preferences/encodings/双击右侧auto_detected,在弹出对话框中点选Add，添加 Values值为GB18030或GB2312,确定后选中，点选Up按钮将其移至第一位。同样方法，对show_in_menu进行设置，并将 GB18030或GB2312置于首位，这样再打开txt文件就不是乱码啦。

2.播放列表乱码问题：
先安装mutagen：sudo apt-get install python-mutagen
然后转到你的MP3目录，我的歌曲放在/media/新加卷/MP3
执行以全命令进行转换：mid3iconv -e GBK *.MP3
再用播放器重新导入歌曲文件，这下就正常啦。
