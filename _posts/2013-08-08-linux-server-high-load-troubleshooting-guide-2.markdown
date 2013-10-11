---
author: pandao
comments: false
date: 2013-08-08 23:30:07+00:00
layout: post
slug: linux-server-high-load-troubleshooting-guide-2
title: Linux服务器中高负载现象故障排查指南
thread: 238
categories:
- linux
---

技术支持分析师们常常接到用户对服务器高负载的控诉。事实上cPanel软件及其安装的应用很少引发服务器高负载情况。服务器拥有者、系统管理员或者服务器供应商应当对高负载状况进行初步调查，并在确认情况复杂后再向分析人士求助。

**服务器高负载因何而起？**

下列项目的过度使用会直接导致高负载问题：



	
  * CPU

	
  * 内存（包括虚拟内存）

	
  * 磁盘I/O


**该如何检查这些项目？**

这取决于大家是要审查当前资源使用情况还是历史资源使用情况。当然，在本文中我们将从这两方面进行探讨。

**关于sar的简要说明**

历史资源使用情况可通过sar工具查看，该工具在默认情况下应该通过sysstat软件包安装在所有cPanel服务器当中。只要通过cron命令 对sysstat进行周期性执行（/etc/cron.d/sysstat），服务器的运行状态数据就会被收集起来。如果cron没有运 行，sysstat将无法收集历史统计结果。

要在sar中查看历史资源使用情况，我们必须为文件提供与统计数据相符的路径。

举例来说，如果大家打算查看本月23号以来服务器的平均负载状况，可以运行以下命令：

代码：



	
  1. [user@host ~]$ sar -q -f /var/log/sa/sa23


以上命令中的-q用于获取平均负载信息，而-f则用于指定sar从哪个文件中获取信息。请注意，sar可能无法使用一周之前乃至更早的运行信息。

如果大家打算查看当前日期的统计信息，则不必为其指令具体时间。输入以下命令即可显示今天的平均负载情况：

代码：

	
  1. [user@host ~]$ sar -q


我们强烈建议大家阅读sar说明文档：

代码：

	
  1. [user@host ~]$ man sar


它所提供的统计信息能够帮助我们确切掌握服务器的运行状态。

**当前CPU使用情况**

运行top，并在Cpu（s）一行中检查%id部分所显示的闲置CPU百分比。该数字越高结果越好，说明CPU的工作负载不强。处于99%闲置状态下的CPU几乎没有处理任何实际任务，而处于1%闲置状态下的CPU则意味着接近满载。

代码：



	
  1. [user@host ~]$ top c


提示：可加写P根据消耗CPU资源的多少对进程加以分类。

**历史CPU使用情况**

查看“%idle”列：

代码：



	
  1. [user@host ~]$ sar -p


**当前内存使用情况**

代码：



	
  1. [user@host ~]$ free -m


提示：运行top c并加写M可查看哪个进程占用的内存量最大。

**历史内存使用情况**

根据sar版本的不同，命令内容也有所区别。早期版本通过添加“-r”参数显示内存使用百分比与虚拟内存使用百分比，但新版本则改用“-s”参数显示虚拟内存使用百分比。

Check %memused and %swpused：

代码：



	
  1. [user@host ~]$ sar -r


或者：

代码：

	
  1. [user@host ~]$ sar -r


代码：

	
  1. [user@host ~]$ sar -S


内存使用情况提示：服务器内存占用量较高的情况其实非常正常。这是因为内存的读写速度及效率远高于服务器磁盘，因此操作系统倾向于将内存作为缓冲机制预先载入数据，从而提高数据读取速度。

同样，内存使用百分比也并不是什么大问题（除非大家没有设置虚拟内存分区，但这也与内存本身无关）。大家真正需要关注的是虚拟内存使用百分比，因为 只有在服务器的物理内存被全部占用后、虚拟内存才会接替而上发挥作用。这一数字越低，就说明服务器的运行状态越好。如果虚拟内存使用率为0%，则意味着我 们的服务器能够完全利用物理内存执行任务。

那么虚拟内存使用率达到多少才算过高？这取决于大家自己的感觉。一般来说，如果虚拟内存使用率一直不高、那么我们的服务器的运行状态还是比较理想 的。如果大家发现虚拟内存使用率随时间不断提升（例如由1%到7%再到32%），这就代表服务器上的某些进程正在疯狂吞噬内存，我们需要及时展开调查以了 解具体情况（而不该直接安装更多内存）。一旦服务器用尽了所有物理内存与虚拟内存，那么整套系统的运行将变得极为缓慢，需要经过重启才能暂时恢复正常。

**当前磁盘I/O使用情况**

注意：这一项对于OpenVZ/Virtuozzo容器不起作用。

以下命令将以每秒一次的频率连续显示十次磁盘使用率统计。请大家关注显示结果中的%util列：

代码：



	
  1. [user@host ~]$ iostat -x 1 10


**历史磁盘I/O使用情况**

代码：



	
  1. [user@host ~]$ sar -d


优秀的系统管理员能够准确把握服务器负载的基准线，并在当前负载超出基准时立即做出判断。这样做的主要目的（除了防止服务器陷入半瘫痪并不得不重新启动之外）是为了及时了解负载高企时服务器正在运行哪些项目。快速反应能帮助大家在发现问题后第一时间进行故障排查。

如果服务器负载过高的状况出现在凌晨两点到四点之间，那么正在熟睡中的我们肯定无法马上展开调查。虽然sar会一直守护在服务器身边，帮我们收集这 段时间内到底哪些资源的使用率居高不下，但却无法揭示问题出现的实际原因。引发负载过高的原因多种多样，其中包括DoS攻击、垃圾邮件攻击、php脚本设 计不当、网络蜘蛛在绘制网络图谱时太过积极、硬件故障、针对用户MySQL数据库的磁盘写入量暴增等等。

好消息是，大家可以利用工具收集这些信息，并在负载过高后将结果自动发送过来。如何实现？从进程列表入手：

代码：

	
  1. [user@host ~]$ ps auxwwwf


我创建了一个shell脚本，以我曾经管理过的服务器上的一套perl脚本为基础。这套脚本与其它服务器监控工具（例如Nagios）配合起来给我的工作带来诸多便利。它能检查六种不同项目（下面将详细介绍），并在进程列表中的条目超出阈值时向我发送邮件通知。

注意：cPanel公司对该脚本的开发、维护或技术支持不承担责任。请不要就这款脚本提出服务申请。如果您在使用中遇到任何问题，请到相关论坛上发帖或请教有经验的系统管理员。cPanel不提供与此脚本相关的任何支持。

它所检查的具体资源对象如下：

	
  * 一分钟平均负载

	
  * 虚拟内存使用数量（单位为KB）

	
  * 内存使用数量（单位为KB）

	
  * 每秒接收数据包数量

	
  * 每秒发出数据包数量

	
  * 进程总数


**如何使用脚本**

要自动运行此脚本，大家需要设置一项cron任务并根据实际情况设定运行频率。我发现每五分钟运行一次是个不错的选择。该脚本无需使用root身份运行，既然如此我们也就不必为其分配高权限。

如果上述监控资源对象中的某一项超过用户自定义的阈值，脚本会自动发送一封电子邮件，其中包含当前进程列表内容。

电子邮件的主题行如下所示：

代码：



	
  1. server.example.com [L: 35] [P: 237] [Swap Use: 1% ] [pps in: 54  pps out: 289]


**脚本使用前的注意事项**

重要事项：大家需要根据自己的理解来调整脚本中的数值。完美的默认值设定并不存在，因为不同的服务器环境

在实际运行中所应遵循的标准也不一样。举例来说，拥有十六个CPU核心的服务器在一分钟平均负载方面肯定要

高于只拥有一个CPU核心的服务器。

注意：大家需要将自己的电子邮箱地址添加到EMAIL变量当中，如下所示：

代码：



	
  1. EMAIL=you@example.com


以下五项也需要根据实际情况加以调整：

	
  * MAX_LOAD

	
  * MAX_SWAP_USED

	
  * MAX_MEM_USED

	
  * MAX_PPS_OUT

	
  * MAX_PPS_IN


代码：

	
  1. #!/bin/sh

	
  2. export PATH=/bin:/usr/bin

	
  3. ##########################################################################

	
  4. #                                                                        #

	
  5. #  Copyright Jeff Petersen, 2009 - 2013                                  #

	
  6. #                                                                        #

	
  7. #  This program is free software: you can redistribute it and/or modify  #

	
  8. #  it under the terms of the GNU General Public License as published by  #

	
  9. #  the Free Software Foundation, either version 3 of the License, or     #

	
  10. #  (at your option) any later version.                                   #

	
  11. #                                                                        #

	
  12. #  This program is distributed in the hope that it will be useful,       #

	
  13. #  but WITHOUT ANY WARRANTY; without even the implied warranty of        #

	
  14. #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #

	
  15. #  GNU General Public License for more details.                          #

	
  16. #                                                                        #

	
  17. #  You should have received a copy of the GNU General Public License     #

	
  18. #  along with this program.  If not, see <http://www.gnu.org/licenses/>. #

	
  19. #                                                                        #

	
  20. ##########################################################################

	
  21. ###############################################################################

	
  22. # START USER CONFIGURABLE VARIABLES

	
  23. ###############################################################################

	
  24. EMAIL="you@example.com"

	
  25. # 1 minute load avg

	
  26. MAX_LOAD=3

	
  27. # kB

	
  28. MAX_SWAP_USED=1000

	
  29. # kB

	
  30. MAX_MEM_USED=500000

	
  31. # packets per second inbound

	
  32. MAX_PPS_IN=2000

	
  33. # packets per second outbound

	
  34. MAX_PPS_OUT=2000

	
  35. # max processes in the process list

	
  36. MAX_PROCS=400

	
  37. ###############################################################################

	
  38. # END USER CONFIGURABLE VARIABLES

	
  39. ###############################################################################

	
  40. IFACE=`grep ETHDEV /etc/wwwacct.conf | awk '{print $2}'`

	
  41. if [[ "$IFACE" =~ "venet" ]] ; then

	
  42. IFACE=venet0

	
  43. fi

	
  44. IFACE=${IFACE}:

	
  45. ###############################################################################

	
  46. # 1 min load avg

	
  47. ###############################################################################

	
  48. ONE_MIN_LOADAVG=`cut -d . -f 1 /proc/loadavg`

	
  49. echo "1 minute load avg: $ONE_MIN_LOADAVG"

	
  50. ###############################################################################

	
  51. # swap used

	
  52. ###############################################################################

	
  53. SWAP_TOTAL=`grep ^SwapTotal: /proc/meminfo | awk '{print $2}'`

	
  54. SWAP_FREE=`grep ^SwapFree: /proc/meminfo | awk '{print $2}'`

	
  55. let "SWAP_USED = (SWAP_TOTAL - SWAP_FREE)"

	
  56. echo "Swap used: $SWAP_USED kB"

	
  57. ###############################################################################

	
  58. # mem used

	
  59. ###############################################################################

	
  60. MEM_TOTAL=`grep ^MemTotal: /proc/meminfo | awk '{print $2}'`

	
  61. MEM_FREE=`grep ^MemFree: /proc/meminfo | awk '{print $2}'`

	
  62. let "MEM_USED = (MEM_TOTAL - MEM_FREE)"

	
  63. echo "Mem used: $MEM_USED kB"

	
  64. ###############################################################################

	
  65. # packets received

	
  66. ###############################################################################

	
  67. PACKETS_RX_1=`grep $IFACE /proc/net/dev | awk '{print $2}'`

	
  68. sleep 2;

	
  69. PACKETS_RX_2=`grep $IFACE /proc/net/dev | awk '{print $2}'`

	
  70. let "PACKETS_RX = (PACKETS_RX_2 - PACKETS_RX_1) / 2"

	
  71. echo "packets received (2 secs): $PACKETS_RX"

	
  72. ###############################################################################

	
  73. # packets sent

	
  74. ###############################################################################

	
  75. PACKETS_TX_1=`grep $IFACE /proc/net/dev | awk '{print $10}'`

	
  76. sleep 2;

	
  77. PACKETS_TX_2=`grep $IFACE /proc/net/dev | awk '{print $10}'`

	
  78. let "PACKETS_TX = (PACKETS_TX_2 - PACKETS_TX_1) / 2"

	
  79. echo "packets sent (2 secs): $PACKETS_TX"

	
  80. let "SWAP_USED = SWAP_TOTAL - SWAP_FREE"

	
  81. if [ ! "$SWAP_USED" == 0 ] ; then

	
  82. PERCENTAGE_SWAP_USED=`echo $SWAP_USED / $SWAP_TOTAL | bc -l`

	
  83. TOTAL_PERCENTAGE=`echo ${PERCENTAGE_SWAP_USED:1:2}%`

	
  84. else

	
  85. TOTAL_PERCENTAGE='0%'

	
  86. fi

	
  87. ###############################################################################

	
  88. # number of processes

	
  89. ###############################################################################

	
  90. MAX_PROCS_CHECK=`ps ax | wc -l`

	
  91. send_alert()

	
  92. {

	
  93. SUBJECTLINE="`hostname` [L: $ONE_MIN_LOADAVG] [P: $MAX_PROCS_CHECK]

	
  94. [Swap Use: $TOTAL_PERCENTAGE ] [pps in: $PACKETS_RX  pps out: $PACKETS_TX]"

	
  95. ps auxwwwf | mail -s "$SUBJECTLINE" $EMAIL

	
  96. exit

	
  97. }

	
  98. if   [ $ONE_MIN_LOADAVG -gt $MAX_LOAD      ] ; then send_alert

	
  99. elif [ $SWAP_USED       -gt $MAX_SWAP_USED ] ; then send_alert

	
  100. elif [ $MEM_USED        -gt $MAX_MEM_USED  ] ; then send_alert

	
  101. elif [ $PACKETS_RX      -gt $MAX_PPS_IN    ] ; then send_alert

	
  102. elif [ $PACKETS_TX      -gt $MAX_PPS_OUT   ] ; then send_alert

	
  103. elif [ $MAX_PROCS_CHECK -gt $MAX_PROCS ] ; then send_alert

	
  104. fi


需要注意的是，进程列表的输出内容中包含一些有用的数列，涉及各个进程的CPU与内存使用情况：

	
  * %CPU

	
  * %MEM

	
  * VSZ

	
  * RSS

	
  * TIME (显示一个进程的存在时间)


我们可以通过多种方式剖析服务器负载高企的原因。下面我们列出几项常用方案--仅供参考，并不全面：

	
  * 利用mysqladmin processlist (或者简写为'mysqladmin pr')检查MySQL进程列表

	
  * 利用mytop检查MySQL进程列表

	
  * 查阅日志文件。了解服务器自身的反馈意见也很重要。您的服务器是否遭遇暴力破解？

	
  * 运行dmesg以检查可能存在的硬件故障

	
  * 利用netstat查看服务器连接


下面则是值得关注的日志文件及其保存路径：

	
  * 系统日志: /var/log/messages, /var/log/secure

	
  * SMTP日志: /var/log/exim_mainlog, /var/log/exim_rejectlog, /var/log/exim_paniclog

	
  * POP3/IMAP日志: /var/log/maillog

	
  * Apache日志: /usr/local/apache/logs/access_log, /usr/local/apache/logs/error_log, /usr/local/apache/logs/suexec_log, /usr/local/apache/logs/suphp_log

	
  * 网站日志: /usr/local/apache/domlogs/ (use this to find sites with traffic in the last 60

	
  * seconds: find -maxdepth 1 -type f -mmin -1 | egrep -v 'offset|_log$')

	
  * Cron日志: /var/log/cron


大家也可以在评论栏中反馈您在工作中遇到的问题、对本篇文章的评论及其它任何希望与朋友们分享的信息。

作为一篇独立的指导性文章，我们不可避免会存在遗漏或者疏忽，期待您提出宝贵意见、也希望大家能从中受到一点启发。

**原文链接：**

[http://forums.cpanel.net/f34/troubleshooting-high-server-loads-linux-servers-319352.html](http://forums.cpanel.net/f34/troubleshooting-high-server-loads-linux-servers-319352.html)
