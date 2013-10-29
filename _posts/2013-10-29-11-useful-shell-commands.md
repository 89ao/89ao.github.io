---
layout: post
title: "11个很少有人知道的shell命令"
categories:
- Linux
- Shell
tags:
- Shell


---

###1. sudo !!命令

没有特定输入sudo命令而运行，将给出没有权限的错误。那么，你不需要重写整个命令，仅仅输入'!!'就可以抓取最后的命令。

###2. python产生一个http Server

下面的命令生产一个通过HTTP显示文件夹结构树的简单网页，可以通过浏览器在端口8000访问，直到发出中断信号。

	python -m SimpleHTTPServer
###3. mtr命令

我们大多数都熟悉ping和traceroute。那对于把两个命令的功能合二为一的mtr命令呢。如果mtr没在你的机子上安装，apt或者yum需要的包。

	sudo apt-get install mtr (On Debian based Systems)
	
	yum install mtr (On Red Hat based Systems)

现在运行mtr命令，开始查看mtr运行的主机和google.com直接的网络连接。

	mtr google.com

###4. Ctrl+x+e命令

这个命令对于管理员和开发者非常有用。为了使每天的任务自动化，管理员需要通过输入vi、vim、nano等打开编辑器。
仅仅从命令行快速的敲击“Ctrl-x-e”，就可以在编辑器中开始工作了。

###5. nl命令

“nl命令”添加文件的行数。一个叫做'one.txt'的文件，其每行的内容是（Fedora、Debian、Arch、Slack和Suse），给每行添加行号。首先使用cat命令显示“one.txt”的文件内容。

	#cat one.txt
	fedora
	debian
	arch
	slack
	suse

在运行“nl命令”，以添加行号的方式来显示。

	#nl one.txt
	fedora
	debian
	arch
	slack
	suse

###6. shuf命令

“Shut”命令随机从一个文件或文件夹中选择行/文件/文件夹。首先使用ls命令来显示文件夹的内容。

	# ls
	Desktop  Documents  Downloads  Music  Pictures  Public  Templates  Videos
	
	#  ls | shuf (shuffle Input)
	Music
	Documents
	Templates
	Pictures
	Public
	Desktop
	Downloads
	Videos
	
	#  ls | shuf -n1 (pick on random selection)
	Public
	# ls | shuf -n1
	Videos
	# ls | shuf -n1
	Templates
	# ls | shuf -n1
	Downloads

注意：你可以把‘ n1’替换成‘ n2’来输出两个随机选择或者使用 n3、 n4等数字输出其他任意的随机选择。

###7. ss命令

“ss”表示socket统计。这个命令调查socket，显示类似netstat命令的信息。它可以比其他工具显示更多的TCP和状态信息。

	# ss
	State      Recv-Q Send-Q      Local Address:Port          Peer Address:Port  
	ESTAB      0      0           192.168.1.198:41250        *.*.*.*:http   
	CLOSE-WAIT 1      0               127.0.0.1:8000             127.0.0.1:41393  
	ESTAB      0      0           192.168.1.198:36239        *.*.*.*:http   
	ESTAB      310    0               127.0.0.1:8000             127.0.0.1:41384  
	ESTAB      0      0           192.168.1.198:41002       *.*.*.*:http   
	ESTAB      0      0               127.0.0.1:41384            127.0.0.1:8000

###8. last命令

“last”命令显示的是上次登录用户的历史信息。这个命令通过搜索文件“/var/log/wtmp”，显示logged-in和logged-out及其tty‘s的用户列表。

	#  last
	server   pts/0        :0               Tue Oct 22 12:03   still logged in  
	server   tty8         :0               Tue Oct 22 12:02   still logged in  
	…
	...
	(unknown tty8         :0               Tue Oct 22 12:02 - 12:02  (00:00)   
	server   pts/0        :0               Tue Oct 22 10:33 - 12:02  (01:29)   
	server   tty7         :0               Tue Oct 22 10:05 - 12:02  (01:56)   
	(unknown tty7         :0               Tue Oct 22 10:04 - 10:05  (00:00)   
	reboot   system boot  3.2.0-4-686-pae  Tue Oct 22 10:04 - 12:44  (02:39)   
	wtmp begins Fri Oct  4 14:43:17 2007

###9. curl ifconfig.me

那么如何得到你的外部IP地址呢？使用google？那么这个命令就在你的终端输出你的外部IP地址。

	# curl ifconfig.me

注意：你可能没有按照curl包，你需要 apt/yum来按照包。

###10. tree命令

以树式的格式得到当前文件夹的结构。

	# tree
	|-- Desktop
	|-- Documents
	|   `-- 37.odt
	|-- Downloads
	|   |-- attachments.zip
	|   |-- ttf-indic-fonts_0.5.11_all.deb
	|   |-- ttf-indic-fonts_1.1_all.deb
	|   `-- wheezy-nv-install.sh
	|-- Music
	|-- Pictures
	|   |-- Screenshot from 2013-10-22 12:03:49.png
	|   `-- Screenshot from 2013-10-22 12:12:38.png
	|-- Public
	|-- Templates
	`-- Videos
	
	10 directories, 23 files

###11. pstree

这个命令显示当前运行的所有进程及其相关的子进程，输出的是类似‘tree’命令的树状格式。


     # pstree
     init─┬─NetworkManager───{NetworkManager}
     ├─accounts-daemon───{accounts-daemon}
     ├─acpi_fakekeyd
     ├─acpid
     ├─apache2───10*[apache2]
     ├─at-spi-bus-laun───2*[{at-spi-bus-laun}]
     ├─atd
     ├─avahi-daemon───avahi-daemon
     ├─bluetoothd
     ├─colord───{colord}
     ├─colord-sane───2*[{colord-sane}]
     ├─console-kit-dae───64*[{console-kit-dae}]
     ├─cron
     ├─cupsd
     ├─2*[dbus-daemon]
     ├─dbus-launch
     ├─dconf-service───2*[{dconf-service}]
     ├─dovecot─┬─anvil
     │         ├─config
     │         └─log
     ├─exim4
     ├─gconfd-2
     ├─gdm3─┬─gdm-simple-slav─┬─Xorg
     │      │                 ├─gdm-session-wor─┬─x-session-manag─┬─evolution-a+
     │      │                 │                 │                 ├─gdu-notific+
     │      │                 │                 │                 ├─gnome-scree+
     │      │                 │                 │                 ├─gnome-shell+++
     │      │                 │                 │                 ├─nm-applet──+++
     │      │                 │                 │                 ├─ssh-agent
     │      │                 │                 │                 ├─tracker-min+
     │      │                 │                 │                 ├─tracker-sto+
     │      │                 │                 │                 └─3*[{x-sessi+
     │      │                 │                 └─2*[{gdm-session-wor}]
     │      │                 └─{gdm-simple-slav}
     │      └─{gdm3}
     ├─6*[getty]
     ├─gnome-keyring-d───9*[{gnome-keyring-d}]
     ├─gnome-shell-cal───2*[{gnome-shell-cal}]
     ├─goa-daemon───{goa-daemon}
     ├─gsd-printer───{gsd-printer}
     ├─gvfs-afc-volume───{gvfs-afc-volume}


###12. 还有个alias

做个这样的alias平常还是很方便的：

	alias dz='du -s *|sort -n'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias grep='grep --color=auto'
	alias i='apt-get install'
	alias l='ls -CF'
	alias la='ls -A'
	alias ll='ls -alF'
	alias ls='ls --color=auto'
	alias s='apt-cache search'
	alias sa='alias>~/.aliases'
	alias sz='dpkg-query -Wf "\${Installed-Size}\t\${Package}\n"|sort -n'
