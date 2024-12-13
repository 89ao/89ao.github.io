---
author: pandao
comments: false
date: 2013-09-30 08:57:55+00:00
layout: post
slug: how-to-become-a-more-efficient-system-administrator
title: 如何成为一名效率更高的系统管理员
thread: 262
categories:
- linux
tags:
- linux
---



如何成为一名效率更高的系统管理员











学会这 10 个技巧后，您将成为世界上最强大的 Linux® 系统管理员，整个世界是有点夸张，但要在一个大团队中工作，这些技巧是十分必要的。学习 SHH 通道、VNC、密码恢复、控制台侦察等等。各个技巧都附有例子，可以将这些例子复制到自己的系统中。










[Vallard Benincosa](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#authorN1001E), 认证技术销售专家, IBM

2008 年 8 月 11 日









	
  * [![+](http://www.ibm.com/i/c.gif)](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#toggle)内容

































好的系统管理员区分在效率上。如果一位高效的系统管理员能在 10 分钟内完成一件他人需要 2 个小时才能完成的任务，那么他应该受到奖励（得到更多报酬），因为他为公司节约了时间，而时间就是金钱，不是吗？

技巧是为了提高管理效率。虽然本文不打算对_所有_ 技巧进行讨论，但是我会介绍 “懒惰” 管理员所用的 10 个基本法宝。这些技巧可以节约时间 —— 即使没有因为高效而得到更多的报酬，但至少可以有更多的时间去玩。


## 技巧 1：卸载无响应的 DVD 驱动器


网络新手的经历：按下服务器（运行基于 Redmond 的操作系统）DVD 驱动器上的 Eject 按钮时，它会立即弹出。他然后抱怨说，在大多数企业 Linux 服务器中，如果在那个目录中运行某个进程，弹出就不会发生。作为一名长期的 Linux 管理员，我会重启机器。如果我不清楚正在运行什么，以及为何不释放 DVD 驱动器，我则会弹出磁盘。但这样效率很低。

下面介绍如何找到保持 DVD 驱动器的进程，并轻松弹出 DVD 驱动器：首先进行模拟。在 DVD 驱动器中放入磁盘，打开一个终端，装载 DVD 驱动器：

`**# mount /media/cdrom
# cd /media/cdrom
# while [ 1 ]; do echo "All your drives are belong to us!"; sleep 30; done**`

现在打开第二个终端并试着弹出 DVD 驱动器：

`**# eject**`

将得到以下消息：

`umount: /media/cdrom: device is busy`

在释放该设备之前，让我们找出谁在使用它。

`**# fuser /media/cdrom**`

进程正在运行，无法弹出磁盘其实是我们的错误。

现在，如果您是根用户，可以随意终止进程：

`**# fuser -k /media/cdrom**`

现在终于可以卸载驱动器了：

`**# eject**`

`fuser` 很正常。

[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 技巧 2：恢复出现问题的屏幕


尝试以下操作：

`**# cat /bin/cat**`

注意！终端就想垃圾一样。输入的所有内容非常零乱。那么该怎么做呢？

输入 `reset`。但是，输入 `reset` 与 输入 `reboot` 或 `shutdown` 太接近了。吓得手心冒汗了吧 — 特别是在生产机器上执行这个操作时。

放心吧，在进行此操作时，机器不会重启。继续操作：

`**# reset**`

现在屏幕恢复正常了。这比关闭窗口后再次登陆好多了，特别是必须经过 5 台机器和 SSH 才能到达这台机器时。

[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 技巧 3：屏幕协作


来自产品工程的高级维护用户 David 打电话说：“为什么我不能在您部署的这些新机器上编译 supercode.c”。

您会问他：“您运行的是什么机器？”

David 答道：“ Posh”。（这个虚够的公司将它的 5 台生产服务器以纪念 Spice Girls 的方式命名）。这下您可以大显身手了，另一台机器由 David 操作：

`**# su - david**`

转到 posh：

`**# ssh posh**`

到达之后，运行以下代码：

`**# screen -S foo**`

然后呼叫 David：

“David，在终端运行命令 `# screen -x foo`”。

这使您和 David 的会话在 Linux shell 中联接在一起。您可以输入，他也可以输入，但彼此可以看到对方所做的事情。这避免了进入其他层次，而且双方都有相同的控制权。这样做的好处是 David 可以观察到您的故障诊断技巧，并能准确了解如何解决问题。

最后大家都能看到问题所在：David 的编译脚本对一个不在此新服务器上的旧目录进行了硬编码。将它装载后再次编译即可解决问题，然后 David 继续工作。您则可以继续之前的娱乐活动。

关于此技巧需要注意的一点是，双方需要以同一用户登录。`screen` 命令还可以：实现多个窗口和拆分屏幕。请阅读手册页获取更多相关信息。

对于 `screen` 会话，我还有最后一个技巧。要从中分离并让它打开，请输入 `**Ctrl-A D**`（即按住 **Ctrl** 键并点击 **A** 键。然后按 **D** 键）。

然后通过再次运行 `screen -x foo` 命令可以重新拼接起来。

[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 技巧 4：找回根密码


如果忘记根密码，就必须重新安装整台机器。更惨的是，许多人都会这样做。但是启动机器并更改密码却十分简单。这并非在所有情况下都适用（比如设置了一个 GRUB 密码，但也忘记了），但这里介绍一个 Cent OS Linux 示例，说明一般情况下的操作。

首先重启系统。重启时会跳出如图 1 所示的 GRUB 屏幕。移动箭头键，这样可以保留在此屏幕上，而不是进入正常启动。


##### 图 1. 重启后的 GRUB 屏幕


![重启后的 GRUB 屏幕](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/figure1.jpg)然后，使用箭头键选择要启动的内核，并输入 **E** 编辑内核行。然后便可看到如图 2 所示的屏幕：


##### 图 2：准备编辑内核行


![准备编辑内核行](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/figure2.jpg)再次使用箭头键突出显示以 `kernel` 开始的行，按 **E** 编辑内核参数。到达如图 3 所示的屏幕时，在图 3 中所示的参数后追加数字 1 即可：


##### 图 3. 在参数后追加数字 1


![在参数后追加数字 1](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/figure3.jpg)然后按 **Enter** 和 **B**，内核会启动到单用户模式。然后运行 `passwd` 命令，更改用户根密码：

`**sh-3.00# passwd**
New UNIX password:
Retype new UNIX password:
passwd: all authentication tokens updated successfully`

现在可以重启了，机器将使用新密码启动。

[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 技巧 5：SSH 后门


有很多次，我所在的站点需要某人的远程支持，而他却被公司防火强阻挡在外。很少有人意识到，如果能通过防火墙到达外部，那么也能轻松实现让外部的信息进来。

从本意讲，这称为 “在防火墙上砸一个洞”。我称之为 _SSH 后门_。为了使用它，必须有一台作为中介的连接到 Internet 的机器。

在本例中，将这样台机器称为 blackbox.example.com。公司防火墙后面的机器称为 ginger。此技术支持的机器称为 tech。图 4 解释了设置过程。


##### 图 4. 在防火墙上砸一个洞


![在防火墙上砸一个洞](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/figure4.gif)以下是操作步骤：



	
  1. 检查什么是允许做的，但要确保您问对了人。大多数人都担心您打开了防火墙，但他们不明白这是完全加密的。而且，必须破解外部机器才能进入公司内部。不过，您可能属于 “敢作敢为” 型的人物。自己进行判断应该选择的方式，但不如意时不抱怨别人。

	
  2. 使用 `-R` 标记通过 SSH 从 ginger 连接到 blackbox.example.com。假设您是 ginger 上的根用户，tech 需要根用户 ID 来帮助使用系统。使用 `-R` 标记将 blackbox 上端口 2222 的说明转发到 ginger 的端口 22 上。这就设置了 SSH 通道。注意，只有 SSH 通信可以进入 ginger：您不会将 ginger 放在无保护的 Internet 上。可以使用以下语法实现此操作：`**~# ssh -R 2222:localhost:22 thedude@blackbox.example.com**`

进入 blackbox 后，只需一直保持登录状态。我总是输入以下命令：

`**thedude@blackbox:~$ while [ 1 ]; do date; sleep 300; done**`

使机器保持忙碌状态。然后最小化窗口。

	
  3. 现在指示 tech 上的朋友使用 SSH 连接到 blackbox，而不需要使用任何特殊的 SSH 标记。但必须把密码给他们：`**root@tech:~# ssh thedude@blackbox.example.com**`.

	
  4. tech 位于 blackbox 上后，可以使用以下命令从 SSH 连接到 ginger：`**thedude@blackbox:~$: ssh -p 2222 root@localhost**`

	
  5. Tech 将提示输入密码。应该输入 ginger 的根密码。

	
  6. 现在您和来自 tech 的支持可以一起工作并解决问题。甚至需要一起使用屏幕！（参见 [技巧 4](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#T4)）。


[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 技巧 6：通过 SSH 通道进行远程 VNC 会话


VNC 或虚拟网络计算已经存在很长时间了。通常，当远程服务器上的某类图形程序只能在此服务器上使用时，我才需要 VNC。

例如，假设在 [技巧 5](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#T5) 中，ginger 是一台存储服务器。许多设备都使用 GUI 程序来管理存储控制器。这些 GUI 管理工具通常需要通过一个网络直接连接到存储服务器，而这个网络有时保存在专用的子网络中。因此，只能通过 ginger 访问这个 GUI。

可以尝试使用 `-X` 选项通过 SSH 连接到 ginger 并启动它，但这对带宽要求很高，您需要忍受等待的痛苦。VNC 是一个网络友好的工具，几乎适用于所有操作系统。

假设设置与技巧 5 中的一样，但希望 tech 能访问 VNC 而不是 SSH。对于这种情况，需要进行一些类似的操作，不过转发的是 VNC 端口。执行以下操作步骤：



	
  1. 在 ginger 上启动一个 VNC 服务器会话。运行以下命令：`**root@ginger:~# vncserver -geometry 1024x768 -depth 24 :99**`这些选项指示启动服务器，分辨率为 1024x768，像素深度为每像素 24 位。如果使用较慢的连接设置，8 也许是更好的选项。使用 `:99` 指定可访问 VNC 服务器的端口。VNC 协议在 5900 处启动，因此 `:99` 表示服务器可从端口 5999 访问。

启动该会话时，要求您指定密码。用户 ID 与启动 VNC 服务器时的用户相同（本例中就是根用户）。

	
  2. 从 ginger 连接到 blackbox.example.com 的 SSH 将 blackbox 上的端口 5999 转发到 ginger。这通过运行以下命令在 ginger 中完成：`**root@ginger:~# ssh -R 5999:localhost:5999 thedude@blackbox.example.com**`运行此命令后，需要将此 SSH 会话保持为打开状态，以便保留转发到 ginger 的端口。此时，如果在 blackbox 上，那么运行以下命令即可访问 ginger 上的 VNC 会话：

`**thedude@blackbox:~$ vncviewer localhost:99**`

这将通过 SSH 将端口转发给 ginger，但我们希望通过 tech 让 VNC 访问 ginger。为此，需要另一个通道。

	
  3. 在 tech 中，打开一个通道，通过 SHH 将端口 5999 转发到 blackbox 上的端口 5999。这通过运行以下命令完成：`**root@tech:~# ssh -L 5999:localhost:5999 thedude@blackbox.example.com**`这次使用的 SSH 标记为 `-L`，它不是将 5999 放到 blackbox，而是从中获取。到达 blackbox 后，需要保持此会话为打开状态。现在即可在 tech 中使用 VNC 了！

	
  4. 在 tech 中，运行以下命令使 VNC 连接到 ginger：`**root@tech:~# vncviewer localhost:99**`.Tech 现在将拥有一个直接到 ginger 的 VNC 会话。


设置虽然有点麻烦，但比为修复存储阵列而四处奔波强多了。不过多实践几次这就变得容易了。

对此技巧我还要补充一点：如果 tech 运行的是 Windows® 操作系统，并且没有命令行 SSH 客户端，那么 tech 可以运行 Putty。Putty 可以设置为通过查找侧栏中的选项来转发 SSH 端口。如果端口是 5902 而不是本例中的 5999，则可以输入图 5 中的内容。


##### 图 5. Putty 可以转发用作通道的 SSH


![Putty 可以转发用作通道的 SSH 端口](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/figure5.jpg)如果进行了此设置，那么 tech 就可以使用 VNC 连接到 localhost:2，如同 tech 正在 Linux 操作系统上运行一样。

[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 技巧 7：检查带宽


设想：公司 A 有一个名为 ginger 的存储服务器，并通过名为 beckham 的客户端节点装载 NFS。公司 A 确定他们需要从 ginger 得到更多的带宽，因为有大量的节点需要 NFS 装载 ginger 的共享文件系统。

实现此操作的最常用和最便宜的方式是将两个吉比特以太网 NIC 组合在一起。这是最便宜的，因为您通常会有一个额外的可用 NIC 和一个额外的端口。

所以采取此这个方法。不过现在的问题是：到底需要多少带宽？

吉比特以太网理论上的限制是 128MBit/s。这个数字从何而来？看看这些计算：

_1Gb = 1024Mb_；_1024Mb/8 = 128MB_；"b" = "bits,"、"B" = "bytes"

但实际看到的是什么呢，有什么好的测量方法呢？我推荐一个工具 iperf。可以按照以下方法获得 iperf：

`**# wget http://dast.nlanr.net/Projects/Iperf2.0/iperf-2.0.2.tar.gz**`

需要在 ginger 和 beckham 均可见的共享文件系统上安装此工具，或者在两个节点上编译并安装。我将在两个节点均可见的 bob 用户的主目录中编译它：

`**tar zxvf iperf*gz
cd iperf-2.0.2
./configure -prefix=/home/bob/perf
make
make install**`

在 ginger 上，运行：

`**# /home/bob/perf/bin/iperf -s -f M**`

这台机器将用作服务器并以 MBit/s 为单位输出执行速度。

在 beckham 节点上，运行：

`**# /home/bob/perf/bin/iperf -c ginger -P 4 -f M -w 256k -t 60**`

两个屏幕上的结果都指示了速度是多少。在使用吉比特适配器的普通服务器上，可能会看到速度约为 112MBit/s。这是 TCP 堆栈和物理电缆中的常用带宽。通过以端到端的方式连接两台服务器，每台服务器使用两个联结的以太网卡，我获得了约 220MBit/s 的带宽。

事实上，在联结的网络上看到的 NFS 约为 150-160MBit/s。这仍然表示带宽可以达到预期效果。如果看到更小的值，则应该检查是否有问题。

我最近碰到一种情况，即通过连接驱动程序连接两个使用了不同驱动程序的 NIC。这导致性能非常低，带宽约为 20MBit/s，比不连接以太网卡时的带宽还小！

[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 技巧 8：命令行脚本和实用程序


Linux 系统管理员通过使用权威的命令行脚本会变得更高效。这包括巧妙使用循环和知道如何使用 `awk`、`grep` 和 `sed` 等的实用程序解析数据。通常这可以减少击键次数，降低用户出错率。

例如，假设需要为即将安装的 Linux 集群生成一个新的 /etc/hosts 文件。一般的做法是在 vi 或文本编辑器中添加 IP 地址。不过，可以通过使用现有 /etc/hosts 文件并将以下内容追加到此文件来实现。在命令行上运行：

`**# P=1; for i in $(seq -w 200); do echo "192.168.99.$P n$i"; P=$(expr $P + 1);
done >>/etc/hosts**`

200 个主机名（n001 到 n200）将由 IP 地址（192.168.99.1 到 192.168.99.200）来创建。手动填充这样的文件有可能会创建重复的 IP 地址或主机名，因此这是使用内置命令行消除用户错误的好例子。请注意，这是在 bash shell（大多数 Linux 发行版的默认值）内完成的。

再举一个例子，假设要检查 Linux 集群中的各个计算节点中的内存大小是否一样。通常，拥有一个发行版或类似的 shell 是最好的。但是为了演示，以下使用 SSH。

假设 SSH 设置为不使用密码验证。然后运行：

`**# for num in $(seq -w 200); do ssh n$num free -tm | grep Mem | awk '{print $2}';
done | sort | uniq**`

这样的命令行相当简洁。（如果在其中放入正则表达式情况会更糟）。让我们对它进行细分，详细讨论各部分。

首先从 001 循环到 200。使用 `seq` 命令的 `-w` 选项在前面填充 0。 然后替换 `num` 变量，创建通过 SSH 连接的主机。有了目标主机后，向它发出命令。本例中是：

`**free -m | grep Mem | awk '{print $2}'**`

这个命令的意思是：



	
  * 使用 `free` 命令获取以兆字节为单位的内存大小。

	
  * 获取这个命令的结果，并使用 `grep` 获取包含字符串 `Mem` 的行。

	
  * 获取那一行并使用 `awk` 输出第二个字段，它是节点中的总内存。


在每个节点上执行这个操作。

在每个节点上执行命令后，200 个节点的整个输出就传送（`|`d）到 `sort` 命令，以对所有内存值进行排序。

最后，使用 `uniq` 命令消除重复项。这个命令会导致以下情况中的一种：



	
  * 如果所有节点（n001 到 n200）拥有相同的内存大小，则只显示一个数字。这个数字就是每个操作系统看到的内存大小。

	
  * 如果节点内存大小不同，将会看到几个内存大小的值。

	
  * 最后，如果某个节点上的 SSH 出现故障，则会看到一些错误消息。


这个命令并不是完美无缺的。如果发现与预期不同的内存值，您就不知道是哪一个节点出了问题，或者有多少个节点。为此需要发出另一个命令。

这个技巧提供了一种查看某些内容的快速方式，而且如果发生错误，您可以立刻知道。其价值在于快速检查。

[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 技巧 9：控制台侦察


有些软件会向控制台输出错误消息，而控制台不一定会显示在 SHH 会话中。使用 vcs 设备可以进行检查。在 SSH 会话中，在远程服务器 `# cat /dev/vcs1` 上运行以下命令。这将显示第一个控制台中的内容。也可以使用 2、3 等查看其他虚拟终端。如果某个用户在远程系统上输入，您将看到他输入的内容。

在大多数数据场中，使用远程终端服务器、KVM 甚至 Serial Over LAN 是查看这类信息的最好方式；它也提供了带外查看功能的一些好处。使用 vcs 设备能够提供一种快速带内方法，这能节省去机房查看控制台的时间。

[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 技巧 10：随机系统信息收集


在 [技巧 8](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#T8) 中，介绍了一个使用命令行获取有关系统中总内存信息的例子。在这个技巧中，我将介绍几个其他方法，用于从需要进行验证、故障诊断或给予远程支持的系统收集重要信息。

首先，收集关于处理器的信息。通过以下命令很容易实现：

`**# cat /proc/cpuinfo**`。

这个命令给出关于处理器的速度、数量和型号的信息。在许多情况下使用 `grep` 可以得到需要的值。

我经常做的检查是确定系统中处理器的数量。因此，如果我买了一台带双核处理器的四核服务器，我可以运行以下命令：

`**# cat /proc/cpuinfo | grep processor | wc -l**`。

然后我看到值应该是 8。如果不是，我会打电话给供应商，让他们给我派送另一台处理器。

我需要的另一条信息是磁盘信息。可以使用 `df` 命令获得。我总是添加 `-h` 标记，以便看到以十亿字节或兆字节为单位的输出。`# df -h` 还会显示磁盘的分区情况。

列表最后是查看系统固件的方式 —— 一个获取 BIOS 级别和 NIC 上的固件信息的方法。

要检查 BIOS 版本，可以运行 `dmidecode` 命令。遗憾的是，不能轻易使用 `grep` 获取信息，所以这不是一个很有效的方法。对于我的 Lenovo T61 laptop，输出如下：

`**#dmidecode | less**
...
BIOS Information
Vendor: LENOVO
Version: 7LET52WW (1.22 )
Release Date: 08/27/2007
...`

这比重启机器并查看 POST 输出有效得多。

要检查以太网适配器的驱动程序和固件版本，请运行 `ethtool`：

`**# ethtool -i eth0
driver: e1000
version: 7.3.20-k2-NAPI
firmware-version: 0.3-0**`

[回页首](http://www.ibm.com/developerworks/cn/linux/l-10sysadtips/#ibm-pcon)


## 结束语


可以从精通命令行的人那里学习很多技巧。最好的学习方式是：



	
  * 与其他人一起工作。共享屏幕会话并观察其他人是如何工作的 —— 您会发现新的做事方法。可能需要谦虚一点，让其他人引导，不过通常可以学到很多东西。

	
  * 阅读手册页。认真阅读手册页，即使是熟知的命令，也能获得更深的见解。例如，您以前可能根本不知道可以使用 `awk` 进行网络编程。

	
  * 解决问题。作为系统管理员，总是要解决问题，不管是您还是其他人引起的问题。这就是经验，经验可以使您更优秀、更高效。


我希望至少有一个技巧能帮助您学习到您不知道的知识。像这样的基本技巧可以使您更高效，并且能增长经验，但最重要的是，技巧可以让您有更多的空闲时间去做自己感兴趣的事情，比如玩电子游戏。最好的管理员比较悠闲，因为他们不喜欢工作。他们能找到完成任务的最快方法，并且能快速完成任务，从而保持休闲的生活。















## 参考资料




### 学习





	
  * 您可以参阅本文在 developerWorks 全球站点上的 [英文原文](http://www.ibm.com/developerworks/linux/library/l-10sysadtips/?S_TACT=105AGX52&S_CMP=cn-a-l)。

	
  * 学习 developerWorks 上的 [Linux Professional Institute 考试准备指南](http://www.ibm.com/developerworks/cn/linux/lpi/)，了解基础知识以完善这些技巧。

	
  * 请参阅 “[在 Linux（或异构）网络上共享计算机，第 1 部分 ](http://www.ibm.com/developerworks/cn/linux/network/share/part1/)”（developerWorks，2001 年 12月），了解更多关于 SSH 和 VNC 的讨论。

	
  * 在 [developerWorks Linux 专区](http://www.ibm.com/developerworks/cn/linux/) 可以找到针对 Linux 开发人员的更多资料。请浏览 [最受欢迎的文章和教程](http://www.ibm.com/developerworks/cn/linux/top10/index.html)。

	
  * 在 developerWorks 上查阅所有 [Linux 技巧](http://www.ibm.com/developerworks/cn/views/linux/libraryview.jsp?search_by=Linux+%E6%8A%80%E5%B7%A7) 和 [Linux 教程](http://www.ibm.com/developerworks/cn/views/linux/libraryview.jsp?type_by=%E6%95%99%E7%A8%8B)。

	
  * 随时关注 [developerWorks 技术活动和网络广播](http://www.ibm.com/developerworks/offers/techbriefings/)。




[http://www.ibm.com/developerworks/cn/linux/l-11sysadtips/index.html](http://www.ibm.com/developerworks/cn/linux/l-11sysadtips/index.html)


















