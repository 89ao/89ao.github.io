---
layout: post
title: "Win8.1将程序添加到右键菜单"
categories:
- 杂七杂八
tags:
- 右键菜单


---

##将程序添加到右键菜单（以记事本、UltraEdit为例）

如何将程序加入右键菜单，这里分别以记事本、UltraEdit为例！

以记事本程序为例：

1. 在运行中输入regedit，打开注册表，找到HKEY_CLASSES_ROOT\*\shell分支，如果没有shell分支，则在*下点击右键，选择“新建－项”，建立shell分支。

2. 在shell下新建“用记事本打开”项，在右侧窗口的“默认”键值栏内输入“用记事本打开”。项的名称和键值可以任意，以含义明确为好。其中键值将显示在右键菜单中。

3. 在“用记事本打开”下再新建Command项，在右侧窗口的“默认”键值栏内输入记事本程序所在的路径，“notepad.exe %1”。其中的%1表示要打开的文件参数。

4. 关闭注册表，即可生效。

如果感觉上述操作太麻烦，您也可以建立一个注册表文件，每次稍加修改，双击导入即可。

##注册表建立方法：

打开记事本，将下面的注册表信息粘到记事本里，存为*.reg（*为自定义文件名）文件，双击执行，右键

看看，是不是又有菜单了。

	Windows Registry Editor Version 5.00 
	;------------------------- 
	[HKEY_CLASSES_ROOT\*\shell] 
	;上面一行对应步骤1 
	[HKEY_CLASSES_ROOT\*\shell\用记事本打开] 
	@="用记事本打开" 
	;上面两行对应步骤2 
	[HKEY_CLASSES_ROOT\*\shell\用记事本打开\Command] 
	@="notepad.exe %1" 
	;上面两行对应步骤3 

------------------------------------

以UltraEdit程序为例：

1. 在运行中输入regedit，打开注册表，找到HKEY_CLASSES_ROOT\*\shell分支，如果没有shell分支，则

在*下点击右键，选择“新建－项”，建立shell分支。

2. 在shell下新建UltraEdit项，在右侧窗口的“默认”键值栏内输入“用UltraEdit打开”。项的名称和键值可以任意，以含义明确为好。其中键值将显示在右键菜单中。

3. 在UltraEdit下再新建Command项，在右侧窗口的“默认”键值栏内输入UltraEdit程序所在的路径，比如“D:\Program Files\UltraEdit-32\Uedit32.exe“ %1。其中的%1表示要打开的文件参数。

4. 关闭注册表，即可生效。
