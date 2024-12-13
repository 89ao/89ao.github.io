---
author: pandao
comments: false
date: 2011-09-16 03:03:10+00:00
layout: post
slug: wow-on-linux
title: WOW on Linux
thread: 66
categories:
- linux
---

一些基本概念：
1.1 wine相当于一个”翻译”，通过伪造动态链接库和提供模拟windows环境把windows应用程序的win32 API翻译成linux内核可以理解的posix api，把d3d api翻译成opengl的。
默认的~/.wine就是一个模拟的windows环境，包含了基本的windows系统目录，和文本格式的注册表文件，这个模拟环境在playonlinux中叫做prefix。通过WINEPREFIX变量也可以指定其他的模拟环境。比如命令
WINEPREFIX=/home/user/.prefix wine “C:\WoW\WoW.exe”
就会以/home/user/.prefix而不是默认的~/.wine作为模拟windows环境来运行WoW.exe
1.2 playonlinux是一个第三方的wine配置程序，提供额外的配置功能，可以更方便的安装windows程序和管理不同的prefix。playonlinux在~/.PlayOnLinux/wineprefix下建立子目录作为不同的wineprefix。

[::艾泽拉斯国家地理 BBS.NGACN.CC::]

使用：
如果没有安装wine，那么可以直接通过playonlinux安装wine。如果已经从系统的包管理器中安装了wine，playonlinux会识别出来。没有安装的程序可以通过菜单：File>install来从安装程序或者光盘安装。对于已经安装好的WoW需要导入。

2.1 首先把WoW整个目录复制或者链接到”~/.wine/drive_c/Program Files”下面(推荐复制，因为专利问题，ntfs-3g是通过fuse实现的，读写性能大概相当于原生ntfs的2/3。实在空间不够了，再考虑软链接)

2.2 通过playonlinux菜单：plugins>Wine Import。一路选前进/是，遇到选择程序的那一步，选择WoW的主程序WoW.exe。然后输入程序的名称就可以了。下面会继续弹出导入程序的对话框，选取消。这时候你会看到WoW出现在程序列表里。

2.3 选择WoW，通过Configure this Appliction按钮来配置WoW。首先用Configure wine选项配置wine。
主要这个几个选项：
显示>虚拟桌面打勾，桌面大小填写你显示器的最佳分辨率。
允许窗口管理器控制窗口打勾。
Vertex Shader支持选硬件。
允许Pixel Shader打勾。
音效用pulse驱动或者ALSA驱动，硬件加速选择完全。
然后确定

2.4 高级配置。选择Use advanced wine configuration plugin。然后前进，直到选择WoW。下面是几个选项的值：
DirectDrawRenderer: opengl
UseGLSL: enabled
VideoMemorySize: 填你的显存容量
OffscreenRenderingMode: N卡用backbuffer，A卡用fbo。如果你不开抗锯齿或者全屏幕泛光，N卡也用fbo，因为如果你开动态阴影的话，backbuffer渲染阴影不正确，对wow来说，fbo稍微快那么一点点。总之对于N卡来说要么放弃抗锯齿或者全屏幕泛光(选fbo)，要么放弃动态阴影(选backbuffer)。
RenderTargetLocakMode: N卡用readtex，A卡用texdraw。Intel的卡我不清楚，就用默认吧，只有轻微的性能差异。
Multisampling: enabled
MouseWarpOverride: enable

这样的就完成了，直接通过run按钮启动wow。

Tips:
安装正确的二进制驱动。N卡通过www.nvidia.cn搜索，A卡通过www.amd.com.cn搜索。如果是比较老的A卡，那么就用开源驱动。Ubuntu好像可以直接通过软件中心安装官方驱动，不过我没用过Ubuntu。。。

如果声音有问题(极少)，可以在pulse和alsa之间切换尝试，硬件加速可以改成软件模拟来尝试。

如果A卡运行游戏出现图标错误，更改WTF/Config.wtf，加一行: SET UIFaster “2”

如果运行游戏缺少某些dll，从windows系统复制过来放到WoW目录或者”~/.wine/drive_c/windows/system32”下

由于dm的干扰，这样运行wow会有轻微的性能损失。等到你对系统熟悉以后，就可以脱离playonlinux了，而且可以自己写脚本让wow和输入法运行在独立的Xserver上。
我个人的脚本，你以后可以参考：


#!/bin/sh
#Script for running WOW in a new X server
WOW_DIR="${HOME}/.wine/drive_c/Program Files/World of Warcraft"
X1_PID0=$(ps aux | awk '{if($0~/X\ \:1/) print $2}')

#Kill X :1 when exit
trap "KILL_X" 0
KILL_X () {
echo "Game stoped,X :1 will be killed..."
kill "${X1_PID1}"
exit 0
}

#Lanuch game
RUNWOW() {
if [ -d "${WOW_DIR}" ];then
X :1 -ac &
sleep 2
echo "Lanuch WOW..."
cd "${WOW_DIR}" &&
DISPLAY=:1 wine "${WOW_DIR}/WoW.exe" 
else 
echo "Check your wow path"
fi
}

#Check display :1
if [ -z "${X1_PID0}" ];then
RUNWOW
else
echo "Do you really wish to kill the X server on display :1?Check if there is any one application running in it!"
echo "1: don't kill it now."
echo "2: kill the X :1 now."
echo -n "Your choice [1..2] >"
read ANS
case $ANS in
1) exit 1;;
2);;
esac
echo "Kill X :1 first."
kill ${X1_PID0} &&
RUNWOW "$@"
fi

#Get the pid of X :1 again after it reset
X1_PID1=$(ps aux | awk '{if($0~/X\ \:1/) print $2}')

exit 0

