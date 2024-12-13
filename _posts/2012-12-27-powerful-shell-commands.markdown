---
author: pandao
comments: false
date: 2012-12-27 09:43:32+00:00
layout: post
slug: powerful-shell-commands
title: '[转]你可能不知道的强大shell命令'
thread: 180
categories:
- linux
---

#### 分享一些可能你不知道的shell用法和脚本，简单&强大！


在阅读以下部分前，强烈建议读者打开一个shell实验，这些都不是shell教科书里的大路货哦：）

1、!$<!$是一个特殊的环境变量，它代表了上一个命令的最后一个字符串。如：你可能会这样：








$mkdir mydir
$mv mydir yourdir
$cd yourdir






可以改成：








$mkdir mydir
$mv !$ yourdir
$cd !$






2、sudo !!以root的身份执行上一条命令 。

场景举例：比如Ubuntu里用apt-get安装软件包的时候是需要root身份的，我们经常会忘记在apt-get前加sudo。每次不得不加上sudo再重新键入这行命令，这时可以很方便的用sudo !!完事。

【陈皓：[酷壳博主](http://coolshell.cn/)（[@左耳朵耗子](http://weibo.com/haoel)）注：在shell下，有时候你会输入很长的命令，你可以使用!xxx来重复最近的一次命令，比如，你以前输入过，vi /where/the/file/is, 下次你可以使用 !vi 重得上次最近一次的vi命令。】

3、cd –回到上一次的目录。

场景举例：当前目录为/home/a，用cd ../b切换到/home/b。这时可以通过反复执行cd –命令在/home/a和/home/b之间来回方便的切换。

（陈皓注：cd ~ 是回到自己的Home目录，cd ~user，是进入某个用户的Home目录）

4、‘ALT+.’ or ‘<ESC> .’热建alt+. 或 esc+. 可以把上次命令行的参数给重复出来。

5、^old^new替换前一条命令里的部分字符串。

场景：echo "wanderful"，其实是想输出echo "wonderful"。只需要^a^o就行了，对很长的命令的错误拼写有很大的帮助。（陈皓注：也可以使用 !!:gs/old/new）

6、du -s * | sort -n | tail

列出当前目录里最大的10个文件。

7、:w !sudo tee %

在vi中保存一个只有root可以写的文件

8、date -d@1234567890

时间截转时间

9、> file.txt

创建一个空文件，比touch短。

10、mtr coolshell.cn

mtr命令比traceroute要好。

在命令行前加空格，该命令不会进入history里。

11、echo “ls -l” | at midnight

在某个时间运行某个命令。

12、curl -u user:pass -d status=”Tweeting from the shell” http://twitter.com/statuses/update.xml

命令行的方式更新twitter。

13、curl -u username –silent “https://mail.google.com/mail/feed/atom” | perl -ne ‘print “\t” if /<name>/; print “$2\n” if /<(title|name)>(.*)<\/\1>/;’

检查你的gmail未读邮件

14、ps aux | sort -nk +4 | tail

列出头十个最耗内存的进程

15、man ascii

显示ascii码表。

场景：忘记ascii码表的时候还需要google么?尤其在天朝网络如此“顺畅”的情况下，就更麻烦在GWF多应用一次规则了，直接用本地的man ascii吧。

16、ctrl-x e

快速启动你的默认编辑器（由变量$EDITOR设置）。

17、netstat –tlnp

列出本机进程监听的端口号。（陈皓注：netstat -anop 可以显示侦听在这个端口号的进程）

18、tail -f /path/to/file.log | sed '/^Finished: SUCCESS$/ q'

当file.log里出现Finished: SUCCESS时候就退出tail，这个命令用于实时监控并过滤log是否出现了某条记录。

19、ssh user@server bash < /path/to/local/script.sh

在远程机器上运行一段脚本。这条命令最大的好处就是不用把脚本拷到远程机器上。

20、ssh user@host cat /path/to/remotefile |http://images.51cto.com/files/uploadimg/20121123/1109370.png -gravity NorthWest -background transparent -extent 720×200  output.png

改一下图片的大小尺寸

21、lsof –i

实时查看本机网络服务的活动状态。

22、vim scp://username@host//path/to/somefile

vim一个远程文件

23、python -m SimpleHTTPServer

一句话实现一个HTTP服务，把当前目录设为HTTP服务目录，可以通过http://localhost:8000访问 这也许是这个星球上最简单的HTTP服务器的实现了。

24、history | awk '{CMD[$2]++;count++;} END { for (a in CMD )print CMD[a] " " CMD[a]/count*100 "% " a }' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10

(陈皓注：有点复杂了，history|awk ‘{print $2}’|awk ‘BEGIN {FS=”|”} {print $1}’|sort|uniq -c|sort -rn|head -10)

这行脚本能输出你最常用的十条命令，由此甚至可以洞察你是一个什么类型的程序员。

25、tr -c “[:digit:]” ” ” < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR=”1;32″ grep –color “[^ ]“

想看看Marix的屏幕效果吗？（不是很像，但也很Cool!）

看不懂行代码？没关系，系统的学习一下*nix shell脚本吧，力荐《Linux命令行与Shell脚本编程大全》。

最后还是那句Shell的至理名言：(陈皓注：下面的那个马克杯很不错啊，[404null.com](http://404null.com/)挺有意思的)。


## “Where there is a shell，there is a way!”
