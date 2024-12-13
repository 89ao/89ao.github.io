---
layout: post
title: "有用的Linux find命令"
categories:
- Linux
tags:
- shell


---

1. 相反匹配

显示所有的名字不是MyCProgram.c的文件或者目录。由于maxdepth是1，所以只会显示当前目录下的文件和目录。

	find -maxdepth 1 -not -iname "MyCProgram.c"
	.
	./MybashProgram.sh
	./create_sample_files.sh
	./backup
	./Program.c

2. 使用inode编号查找文件

任何一个文件都有一个独一无二的inode编号，借此我们可以区分文件。创建两个名字相似的文件，例如一个有空格结尾，一个没有。

	touch "test-file-name"
	 touch "test-file-name "
	[Note: There is a space at the end]
	 ls -1 test*
	test-file-name
	test-file-name

从ls的输出不能区分哪个文件有空格结尾。使用选项-i，可以看到文件的inode编号，借此可以区分这两个文件。

	ls -i1 test*
	16187429 test-file-name
	16187430 test-file-name

你可以如下面所示在find命令中指定inode编号。在此，find命令用inode编号重命名了一个文件。

	find -inum 16187430 -exec mv {} new-test-file-name \;
 	
	  ls -i1 *test*
	16187430 new-test-file-name
	16187429 test-file-name

你可以在你想对那些像上面一样的糟糕命名的文件做某些操作时使用这一技术。例如，名为file?.txt的文件名字中有一个特殊字符。若你想执行“rm file?.txt”，下面所示的所有三个文件都会被删除。所以，采用下面的步骤来删除”file?.txt”文件。

	ls
	file1.txt  file2.txt  file?.txt

找到每一个文件的inode编号。

	ls -i1
	804178 file1.txt
	804179 file2.txt
	804180 file?.txt

如下所示：?使用inode编号来删除那些具有特殊符号的文件名。

	find -inum 804180 -exec rm {} \;
	 ls
	file1.txt  file2.txt
	[Note: The file with name "file?.txt" is now removed]

7. 根据文件权限查找文件

下面的操作时合理的：

找到具有指定权限的文件
忽略其他权限位，检查是否和指定权限匹配
根据给定的八进制/符号表达的权限搜索
此例中，假设目录包含以下文件。注意这些文件的权限不同。

	ls -l
	total 0
	-rwxrwxrwx 1 root root 0 2009-02-19 20:31 all_for_all
	-rw-r--r-- 1 root root 0 2009-02-19 20:30 everybody_read
	---------- 1 root root 0 2009-02-19 20:31 no_for_all
	-rw------- 1 root root 0 2009-02-19 20:29 ordinary_file
	-rw-r----- 1 root root 0 2009-02-19 20:27 others_can_also_read
	----r----- 1 root root 0 2009-02-19 20:27 others_can_only_read

找到具有组读权限的文件。使用下面的命令来找到当前目录下对同组用户具有读权限的文件，忽略该文件的其他权限。

	find . -perm -g=r -type f -exec ls -l {} \;
	-rw-r--r-- 1 root root 0 2009-02-19 20:30 ./everybody_read
	-rwxrwxrwx 1 root root 0 2009-02-19 20:31 ./all_for_all
	----r----- 1 root root 0 2009-02-19 20:27 ./others_can_only_read
	-rw-r----- 1 root root 0 2009-02-19 20:27 ./others_can_also_read

找到对组用户具有只读权限的文件。

	find . -perm g=r -type f -exec ls -l {} \;
	----r----- 1 root root 0 2009-02-19 20:27 ./others_can_only_read

找到对组用户具有只读权限的文件(使用八进制权限形式)。

	find . -perm 040 -type f -exec ls -l {} \;
	----r----- 1 root root 0 2009-02-19 20:27 ./others_can_only_read

8. 找到home目录及子目录下所有的空文件(0字节文件)

下面命令的输出文件绝大多数都是锁定文件盒其他程序创建的place hoders

	find ~ -empty

只列出你home目录里的空文件。

	find . -maxdepth 1 -empty

只列出当年目录下的非隐藏空文件。

	find . -maxdepth 1 -empty -not -name ".*"

9. 查找5个最大的文件

下面的命令列出当前目录及子目录下的5个最大的文件。这会需要一点时间，取决于命令需要处理的文件数量。

	find . -type f -exec ls -s {} \; | sort -n -r | head -5

10. 查找5个最小的文件

方法同查找5个最大的文件类似，区别只是sort的顺序是降序。

	find . -type f -exec ls -s {} \; | sort -n  | head -5
上面的命令中，很可能你看到的只是空文件(0字节文件)。如此，你可以使用下面的命令列出最小的文件，而不是0字节文件。

	find . -not -empty -type f -exec ls -s {} \; | sort -n  | head -5

11. 使用-type查找指定文件类型的文件

只查找socket文件

	find . -type s

查找所有的目录

	find . -type d

查找所有的一般文件

	find . -type f

查找所有的隐藏文件

	find . -type f -name ".*"

查找所有的隐藏目录

	find -type d -name ".*"

12. 通过和其他文件比较修改时间查找文件

显示在指定文件之后做出修改的文件。下面的find命令将显示所有的在ordinary_file之后创建修改的文件。

	ls -lrt
	total 0
	-rw-r----- 1 root root 0 2009-02-19 20:27 others_can_also_read
	----r----- 1 root root 0 2009-02-19 20:27 others_can_only_read
	-rw------- 1 root root 0 2009-02-19 20:29 ordinary_file
	-rw-r--r-- 1 root root 0 2009-02-19 20:30 everybody_read
	-rwxrwxrwx 1 root root 0 2009-02-19 20:31 all_for_all
	---------- 1 root root 0 2009-02-19 20:31 no_for_all
	 
	 find -newer ordinary_file
	.
	./everybody_read
	./all_for_all
	./no_for_all

13. 通过文件大小查找文件

使用-size选项可以通过文件大小查找文件。

查找比指定文件大的文件

	find ~ -size +100M

查找比指定文件小的文件

	find ~ -size -100M

查找符合给定大小的文件

	find ~ -size 100M

注意: – 指比给定尺寸小，+ 指比给定尺寸大。没有符号代表和给定尺寸完全一样大。

14. 给常用find操作取别名

若你发现有些东西很有用，你可以给他取别名。并且在任何你希望的地方执行。

常用的删除a.out文件。

	alias rmao="find . -iname a.out -exec rm {} \;"
	 rmao

删除c程序产生的core文件。

	alias rmc="find . -iname core -exec rm {} \;"
	 rmc

15. 用find命令删除大型打包文件

下面的命令删除大于100M的*.zip文件。

	find / -type f -name *.zip -size +100M -exec rm -i {} \;"
用别名rm100m删除所有大雨100M的*.tar文件。使用同样的思想可以创建rm1g,rm2g,rm5g的一类别名来删除所有大于1G,2G,5G的文件。

	alias rm100m="find / -type f -name *.tar -size +100M -exec rm -i {} \;"
	 alias rm1g="find / -type f -name *.tar -size +1G -exec rm -i {} \;"
	 alias rm2g="find / -type f -name *.tar -size +2G -exec rm -i {} \;"
	 alias rm5g="find / -type f -name *.tar -size +5G -exec rm -i {} \;"
	 
	 rm100m
	 rm1g
	 rm2g
	 rm5g

16. 基于访问/修改/更改时间查找文件

你可以找到基于以下三个文件的时间属性的文件。

访问时间的文件。文件访问时，访问时间得到更新。
的文件的修改时间。文件内容修改时，修改时间得到更新。
更改文件的时间。更改时间时，被更新的inode数据的变化。
在下面的例子中，min选项之间的差异和时间选项是参数。

分论点将它的参数为分钟。例如，60分钟（1小时）= 60分钟。时间参数，将它的参数为24小时。例如，时间2 = 2 * 24小时（2天）。虽然这样做的24个小时计算，小数部分都将被忽略，所以25小时为24小时，和47小时取为24小时，仅48小时为48小时。要获得更清晰的参考atime的部分find命令的手册页。

16.找到在1个小时内被更改的文件

想要通过文件修改时间找出文件，可以使用参数 -mmin -mtime。下面是man手册中有关mmin和mtime的定义。

-mmin n 文件最后一次修改是在n分钟之内
-mtime n 文件最后一次修改是在 n*24小时之内（译者注：也就是n天了呗）

执行下面例子中的命令，将会找到当前目录以及其子目录下，最近一次修改时间在1个小时（60分钟）之内的文件或目录

	 find . -amin -60
同样的方式，执行下面例子中的命令，将会找到24小时（1天）内被访问了的文件（文件系统根目录 / 下）

	 find / -atime -1
17.找到1个小时内被访问过的文件

想要通过文件访问时间找出文件，可以使用参数 -amin -atime。下面是man手册中有关amin和atime的定义。

-amin n 文件最后一次访问是在n分钟之内
-atime n 文件最后一次访问是在 n*24小时之内

执行下面例子中的命令，将会找到当前目录以及其子目录下，最近一次访问时间在1个小时（60分钟）之内的文件或目录

	 find . -amin -60
同样的方式，执行下面例子中的命令，将会找到24小时（1天）内被访问了的文件（文件系统根目录 / 下）

	 find / -atime -1
18.查找一个小时内状态被改变的文件

（译者注：这里的改变更第1个例子的更改文件内容时间是不同概念，这里是更改的是文件inode的数据，比如文件的权限，所属人等等信息）

要查找文件的inode的更改时间，使用-cmin和-ctime选项

-cmin n  文件的状态在n分钟内被改变
-ctime n  文件状态在n*24小时内（也就是n天内）被改变

（译者注：如果上面的n为-n形式，则表示n分钟/天之内，n为+n则表示n分钟/天之前）

下面的例子在当前目录和其子目录下面查找一个小时内文件状态改变的文件（也就是60分钟内）：

	 find . -cmin -60
同样的道理，下面的例子在根目录/及其子目录下一天内（24小时内）文件状态被改变的文件列表：

	 find / -ctime -1
19.搜索仅仅限定于文件，不显示文件夹

上面的例子搜索出来不仅仅有文件，还会显示文件夹。因为当一个文件被访问的时候，它所处的文件夹也会被访问，如果你对文件夹不感兴趣，那么可以使用 -type f 选项

下面的例子会显示30分钟内被修改过的文件，文件夹不显示：

	 find /etc/sysconfig -amin -30
	.
	./console
	./network-scripts
	./i18n
	./rhn
	./rhn/clientCaps.d
	./networking
	./networking/profiles
	./networking/profiles/default
	./networking/profiles/default/resolv.conf
	./networking/profiles/default/hosts
	./networking/devices
	./apm-scripts
	[注: 上面的输出包含了文件和文件夹]
 
	 find /etc/sysconfig -amin -30 -type f
	./i18n
	./networking/profiles/default/resolv.conf
	./networking/profiles/default/hosts
	[注: 上面的输出仅仅包含文件]

20.仅仅查找非隐藏的文件（不显示隐藏文件）：

如果我们查找的时候不想隐藏文件也显示出来，可以使用下面的正则式查找：

下面的命令会显示当前目录及其子目录下15分钟内文件内容被修改过的文件，并且只列出非隐藏文件。也就是说，以.开头的文件时不会显示出来的

	 find . -mmin -15 \( ! -regex ".*/\..*" \)
基于文件比较的查找命令

我们平时通过更别的东西进行比较，会更容易记住一些事情。比如说我想找出在我编辑test文件之后编辑过的文件。你可以通过test这个文件的编辑时间作为比较基准去查找之后编辑过的文件：

21.查找文件修改时间在某一文件修改后的文件：

	语法： find -newer FILE
下面的例子显示在/etc/passwd修改之后被修改过的文件。对于系统管理员，想知道你新增了一个用户后去跟踪系统的活动状态是很有帮助的（万一那新用户不老实，一上来就乱搞，你很快就知道了  ^_^）：

	 find -newer /etc/passwd
22.查找文件访问时间在某一文件的修改时间之后的文件：

	 find -newer /etc/passwd
下面的例子显示所有在/etc/hosts文件被修改后被访问到的文件。如果你新增了一个主机/端口记录在/etc/hosts文件中，你很可能很想知道在那之后有什么文件被访问到了，下面是这个命令：

	 find -anewer /etc/hosts
23.查找状态改变时间在某个文件修改时间之后的文件：

	语法： find -cnewer FILE
下面的例子显示在修改文件/etc/fstab之后所有文件状态改变过的文件。如果你在/etc/fstab新增了一个挂载点，你很可能想知道之后哪些文件的状态发生了改变，这时候你可以使用如下命令：

	 find -cnewer /etc/fstab
在查找到的文件列表结果上直接执行命令：

这之前你已经看到了如果通过find命令去查找各种条件的文件列表。如果你对这些find命令还不熟悉，我建议你看完上面的第一部分

接下来这部分我们向你介绍如果在find命令上执行各种不同的命令，也就是说如何去操作find命令查找出来的文件列表。

我们能在find命令查找出来的文件名列表上指定任意的操作：

	 find <CONDITION to Find files> -exec <OPERATION> \;
其中的OPERATION可以是任意的命令，下面列举一下比较常用的：

 rm 命令，用于删除find查找出来的文件
 mv 命令，用于重命名查找出的文件
 ls -l 命令，显示查找出的文件的详细信息
 md5sum， 对查找出的文件进行md5sum运算，可以获得一个字符串，用于检测文件内容的合法性
 wc 命令，用于统计计算文件的单词数量，文件大小等待
 执行任何Unix的Shell命令
 执行你自己写的shell脚本，参数就是每个查找出来的文件名

24.在find命令输出上使用 ls -l， 列举出1小时内被编辑过的文件的详细信息

	 find -mmin -60
	./cron
	./secure
	 
	  find -mmin -60 -exec ls -l {} \;
	-rw-------  1 root root 1028 Jun 21 15:01 ./cron
	-rw-------  1 root root 831752 Jun 21 15:42 ./secure

25.仅仅在当前文件系统中搜索

系统管理员有时候仅仅想在/挂载的文件系统分区上搜索，而不想去搜索其他的挂载分区，比如/home/挂载分区。如果你有多个分区被挂载了，你想在/下搜索，一般可以按下面的这样做

下面这个命令会搜索根目录/及其子目录下所有.log结尾的文件名。如果你有多个分区在/下面，那么这个搜索会去搜索所有的被挂载的分区：

	 find / -name "*.log"
如果我们使用-xdev选项，那么仅仅会在在当前文件系统中搜索，下面是在xdev的man page上面找到的一段-xdev的定义：

	-xdev Don’t descend directories on other filesystems.
下面的命令会在/目录及其子目录下搜索当前文件系统(也就是/挂载的文件系统)中所有以.log结尾的文件，也就是说如果你有多个分区挂载在/下面，下面的搜索不会去搜索其他的分区的（比如/home/）

	 find / -xdev -name "*.log"
26.在同一个命令中使用多个{}

linux手册说命令中只能使用一个{}，不过你可以像下面这样在同一个命令中使用多个{}

	 find -name "*.txt" cp {} {}.bkup \;
注意，在同一个命令中使用这个{}是可以的，但是在不同的命令里就不行了，也就是说，如果你想象下面这样重命名文件是行不通的

	find -name "*.txt" -exec mv {} `basename {} .htm`.html \;
27. 使用多个{}实例

你可以像下面这样写一个shell脚本去模拟上面那个重命名的例子

	 mv "$1" "`basename "$1" .htm`.html"
上面的双引号是为了防止文件名中出现的空格，不加的话会有问题。然后你把这个shell脚本保存为mv.sh，你可以像下面这样使用find命令了

	find -name "*.html" -exec ./mv.sh '{}' \;
所以，任何情况下你在find命令执行中想使用同一个文件名多次的话，先写一个脚本，然后在find中通过-exec执行这个脚本，把文件名参数传递进去就行，这是最简单的办法

28.将错误重定向到/dev/nul

重定向错误输出一般不是什么好的想法。一个有经验的程序员懂得在终端显示错误并及时修正它是很重要的。

尤其是在find命令中重定向错误不是个好的实践。 但是如果你确实不想看到那些烦人的错误，想把错误都重定向到null设备中（也就是linux上的黑洞装置，任何丢进去的东西消失的无影无踪了）。你可以像下面这样做

	find -name "*.txt" 2>>/dev/null
有时候这是很有用的。比如，如果你想通过你自己的账号在/目录下查找所有的*.conf文件，你会得到很多很多的”Permission denied”的错误消息， 就像下面这样：

	$ find / -name "*.conf"
	/sbin/generate-modprobe.conf
	find: /tmp/orbit-root: Permission denied
	find: /tmp/ssh-gccBMp5019: Permission denied
	find: /tmp/keyring-5iqiGo: Permission denied
	find: /var/log/httpd: Permission denied
	find: /var/log/ppp: Permission denied
	/boot/grub/grub.conf
	find: /var/log/audit: Permission denied
	find: /var/log/squid: Permission denied
	find: /var/log/samba: Permission denied
	find: /var/cache/alchemist/printconf.rpm/wm: Permission denied
	[Note: There are two valid *.conf files burned in the "Permission denied" messages]

你说烦人不？所以，如果你只想看到find命令真实的查找结果而不是这些”Permission denied”错误消息，你可以将这些错误消息重定向到/dev/null中去

	$ find / -name "*.conf" 2>>/dev/null
	/sbin/generate-modprobe.conf
	/boot/grub/grub.conf
	[Note: All the "Permission denied" messages are not displayed]

29.将文件名中的空格换成下划线

你从网上下载下来的音频文件的文件名很多都带有空格。但是带有空格的文件名在linux(类Unix)系统里面是很不好的。你可以使用find然后后面加上rename命令的替换功能去重命名这些文件，将空格转换成下划线

下面显示怎样将所有mp3文件的文件名中的空格换成_

	$ find . -type f -iname “*.mp3″ -exec rename “s/ /_/g” {} \;
30.在find结果中同时执行两条命令

在find的man page页面中，下面是一次文件查找遍历中使用两条命令的语法举例

下面的find命令的例子，遍历文件系统一次，列出拥有setuid属性的文件和目录，写入/root/suid.txt文件， 如果文件大小超过100M，将其记录到/root/big.txt中

	 find / \( -perm -4000 -fprintf /root/suid.txt '%m %u %p\n' \) , \
	\( -size +100M -fprintf /root/big.txt '%-10s %p\n' \)
