---
author: pandao
comments: false
date: 2013-04-15 08:32:22+00:00
layout: post
slug: under-unixlinux-suid-sgid-resolution
title: 关于UNIX/Linux下SUID、SGID的解析
thread: 191
categories:
- linux
---

一、UNIX下关于文件权限的表示方法和解析

SUID 是 Set User ID, SGID 是 Set Group ID的意思。

UNIX下可以用ls -l 命令来看到文件的权限。用ls命令所得到的表示法的格

式是类似这样的：-rwxr-xr-x 。下面解析一下格式所表示的意思。
这种表示方法一共有十位：
9 8 7 6 5 4 3 2 1 0
- r w x r - x r - x
第9位表示文件类型,可以为p、d、l、s、c、b和-：
p表示命名管道文件
d表示目录文件
l表示符号连接文件
-表示普通文件
s表示socket文件
c表示字符设备文件
b表示块设备文件
第8-6位、5-3位、2-0位分别表示文件所有者的权限，同组用户的权限，其

他用户的权限，其形式为rwx：
r表示可读，可以读出文件的内容
w表示可写，可以修改文件的内容
x表示可执行，可运行这个程序
没有权限的位置用-表示
例子：
ls -l myfile显示为：
-rwxr-x--- 1 foo staff 7734 Apr 05 17:07 myfile
表示文件myfile是普通文件，文件的所有者是foo用户，而foo用户属于staf
f
组，文件只有1个硬连接，长度是7734个字节，最后修改时间4月5日17:07。

所有者foo对文件有读写执行权限，staff组的成员对文件有读和执行权限，

其他的用户对这个文件没有权限。

如果一个文件被设置了SUID或SGID位，会分别表现在所有者或同组用户的权

限的可执行位上。例如：
1、-rwsr-xr-x 表示SUID和所有者权限中可执行位被设置
2、-rwSr--r-- 表示SUID被设置，但所有者权限中可执行位没有被设置

3、-rwxr-sr-x 表示SGID和同组用户权限中可执行位被设置
4、-rw-r-Sr-- 表示SGID被设置，但同组用户权限中可执行位没有被社

其实在UNIX的实现中，文件权限用12个二进制位表示，如果该位置上的值是

1，表示有相应的权限：
11 10 9 8 7 6 5 4 3 2 1 0
S G T r w x r w x r w x
第11位为SUID位，第10位为SGID位，第9位为sticky位，第8-0位对应于上面

的三组rwx位。
11 10 9 8 7 6 5 4 3 2 1 0
上面的-rwsr-xr-x的值为： 1 0 0 1 1 1 1 0 1 1 0 1
-rw-r-Sr--的值为： 0 1 0 1 1 0 1 0 0 1 0 0

给文件加SUID和SUID的命令如下：
chmod u+s filename 设置SUID位
chmod u-s filename 去掉SUID设置
chmod g+s filename 设置SGID位
chmod g-s filename 去掉SGID设置
另外一种方法是chmod命令用八进制表示方法的设置。如果明白了前面的12位

权限表示法也很简单。

二、SUID和SGID的详细解析

由于SUID和SGID是在执行程序（程序的可执行位被设置）时起作用，而可执

行位只对普通文件和目录文件有意义，所以设置其他种类文件的SUID和SGID位是

没有多大意义的。
首先讲普通文件的SUID和SGID的作用。例子：
如果普通文件myfile是属于foo用户的，是可执行的，现在没设SUID位，ls命

令显示如下：
-rwxr-xr-x 1 foo staff 7734 Apr 05 17:07 myfile
任何用户都可以执行这个程序。UNIX的内核是根据什么来确定一个进程对资

源的访问权限的呢？是这个进程的运行用户的（有效）ID，包括user id和group

id。用户可以用id命令来查到自己的或其他用户的user id和group id。
除了一般的user id 和group id外，还有两个称之为effective 的id，就是

有效id，上面的四个id表示为：uid，gid，euid，egid。内核主要是根据euid和

egid来确定进程对资源的访问权限。
一个进程如果没有SUID或SGID位，则euid=uid egid=gid，分别是运行这个程

序的用户的uid和gid。例如kevin用户的uid和gid分别为204和202，foo用户的ui
d
和gid为200，201，kevin运行myfile程序形成的进程的euid=uid=204，egid=gid
=
202，内核根据这些值来判断进程对资源访问的限制，其实就是kevin用户对资源

访问的权限，和foo没关系。
如果一个程序设置了SUID，则euid和egid变成被运行的程序的所有者的uid和

gid，例如kevin用户运行myfile，euid=200，egid=201，uid=204，gid=202，则

这个进程具有它的属主foo的资源访问权限。
SUID的作用就是这样：让本来没有相应权限的用户运行这个程序时，可以访

问他没有权限访问的资源。passwd就是一个很鲜明的例子。
SUID的优先级比SGID高，当一个可执行程序设置了SUID，则SGID会自动变成

相应的egid。
下面讨论一个例子：
UNIX系统有一个/dev/kmem的设备文件，是一个字符设备文件，里面存储了核

心程序要访问的数据，包括用户的口令。所以这个文件不能给一般的用户读写，

权限设为：cr--r----- 1 root system 2, 1 May 25 1998 kmem
但ps等程序要读这个文件，而ps的权限设置如下：
-r-xr-sr-x 1 bin system 59346 Apr 05 1998 ps
这是一个设置了SGID的程序，而ps的用户是bin，不是root，所以不能设置SUID来

访问kmem，但大家注意了，bin和root都属于system组，而且ps设置了SGID，一般

用户执行ps，就会获得system组用户的权限，而文件kmem的同组用户的权限是可

读，所以一般用户执行ps就没问题了。但有些人说，为什么不把ps程序设置为
root用户的程序，然后设置SUID位，不也行吗？这的确可以解决问题，但实际中

为什么不这样做呢？因为SGID的风险比SUID小得多，所以出于系统安全的考虑，

应该尽量用SGID代替SUID的程序，如果可能的话。
下面来说明一下SGID对目录的影响。SUID对目录没有影响。
如果一个目录设置了SGID位，那么如果任何一个用户对这个目录有写权限的

话，他在这个目录所建立的文件的组都会自动转为这个目录的属主所在的组，而

文件所有者不变，还是属于建立这个文件的用户。

三、关于SUID和SGID的编程

和SUID和SGID编程比较密切相关的有以下的头文件和函数：

#include
#include

uid_t getuid(void);

uid_t geteuid(void);

gid_t getgid (void);

gid_t getegid (void);

int setuid (uid_t UID);

int setruid (uid_t RUID);

int seteuid (uid_t EUID);

int setreuid (uid_t RUID,uid_t EUID);

int setgid (gid_t GID);

int setrgid (gid_t RGID);

int setegid (git_t EGID);

int setregid (gid_t RGID, gid_t EGID);

具体这些函数的说明在这里就不详细列出来了,要用到的可以用man查。


SUID/SGID :
假如你有文件a.txt
#ls -l a.txt
-rwxrwxrwx
#chmod 4777 a.txt
-rwsrwxrwx ======>注意s位置
#chmod 2777 a.txt
-rwxrwsrwx ======>注意s位置
#chmod 7777 a.txt
-rwsrwxswt ======>出现了t,t的作用在内存中尽量保存a.txt,节省系统再加载的时间.

现在再看前面设置 SUID/SGID作用:
#cd /sbin
#./lsusb
...
#su aaa(普通用户)
$./lsusb
...
是不是现在显示出错？
$su
#chmod 4755 lsusb
#su aaa
$./lsusb
... 现在明白了吗？本来是只有root用户才能执行的命令，加了SUID后,普通用户就可以像root一样的用，权限提升了。上面是对于文件来说的，对于目录也差不多！
目录的S属性使得在该目录下创建的任何文件及子目录属于该目录所拥有的组，目录的T属性使得该目录的所有者及root才能删除该目录。还有对于s与S，设置SUID/SGID需要有运行权限，否则用ls -l后就会看到S,证明你所设置的SUID/SGID没有起作用。

Why we need suid,how do we use suid?

r -- 读访问

w -- 写访问

x -- 执行许可

s -- SUID/SGID

t -- sticky位

那么 suid/sgid是做什么的？ 为什么会有suid位呢？

要想明白这个，先让我们看个问题：如果让每个用户更改自己的密码？

用户修改密码，是通过运行命令passwd来实现的。最终必须要修改/etc/passwd文件，

而passwd的文件的属性是：

#ls -l /etc/passwd

-rw-r--r-- 1 root root 2520 Jul 12 18:25 passwd

我们可以看到passwd文件只有对于root用户是可写的，而对于所有的他用户来说都是没有写权限的。 那么一个普通的用户如何能够通过运行passwd命令修改这个passwd文件呢？

为了解决这个问题，SUID/SGID便应运而生。而且AT&T对它申请了专利。 呵呵。

SUID和SGID是如何解决这个问题呢？

首先，我们要知道一点：进程在运行的时候，有一些属性，其中包括 实际用户ID,实际组ID,有效用户ID,有效组ID等。 实际用户ID和实际组ID标识我们是谁，谁在运行这个程序,一般这2个字段在登陆时决定，在一个登陆会话期间， 这些值基本上不改变。

而有效用户ID和有效组ID则决定了进程在运行时的权限。内核在决定进程是否有文件存取权限时， 是采用了进程的有效用户ID来进行判断的。

知道了这点，我们来看看SUID的解决途径：

当一个程序设置了为SUID位时，内核就知道了运行这个程序的时候，应该认为是文件的所有者在运行这个程序。即该程序运行的时候，有效用户ID是该程序的所有者。举个例子：

[root@sgrid5 bin]# ls -l passwd

-r-s--s--x 1 root root 16336 Feb 14 2003 passwd

虽然你以test登陆系统，但是当你输入passwd命令来更改密码的时候，由于passwd设置了SUID位，因此虽然进程的实际用户ID是test对 应的ID，但是进程的有效用户ID则是passwd文件的所有者root的ID,因此可以修改/etc/passwd文件。

让我们看另外一个例子。

ping命令应用广泛，可以测试网络是否连接正常。ping在运行中是采用了ICMP协议，需要发送ICMP报文。但是只有root用户才能建立ICMP报文，如何解决这个问题呢？同样，也是通过SUID位来解决。

[root@sgrid5 bin]# ls -l /bin/ping

-rwsr-sr-x 1 root root 28628 Jan 25 2003 /bin/ping

我们可以测试一下，如果去掉ping的SUID位，再用普通用户去运行命令，看会怎么样。

[root@sgrid5 bin]#chmod u-s /bin/ping

[root@sgrid5 bin]# ls -l ping

-rwxr-xr-x 1 root root 28628 Jan 25 2003 ping

[root@sgrid5 bin]#su test

[test@sgrid5 bin]$ ping byhh.net

ping: icmp open socket: Operation not permitted

SUID虽然很好了解决了一些问题，但是同时也会带来一些安全隐患。

因为设置了 SUID 位的程序如果被攻击(通过缓冲区溢出等方面),那么hacker就可以拿到root权限。

因此在安全方面特别要注意那些设置了SUID的程序。

通过以下的命令可以找到系统上所有的设置了suid的文件：

[root@sgrid5 /]# find / -perm -04000 -type f -ls

对于这里为什么是4000，大家可以看一下前面的st_mode的各bit的意义就明白了。

在这些设置了suid的程序里，如果用不上的，就最好取消该程序的suid位。

原文地址：[http://www.zhuaxia.com/item/519700228](http://www.zhuaxia.com/item/519700228)
