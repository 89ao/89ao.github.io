---
layout: post
title: "crontab笔记"
categories:
- Linux
tags:
- crontab


---

编写crontab有两种方式，一种为使用crontab -e命令，另一种为直接编辑/etc/crontab文件。	

推荐使用crontab -e编辑，在保存退出的时候有语法检查。
 

格式为

	分  时  日  月  星期  命令
	*/5 *    *    *    *     /root/script.sh

crontab -e写入之后的路径是/var/spool/cron下的。


crontab -l   

可以显示已经创建了的cron任务。   

 
说明：
cron服务每分钟不仅要读一次/var/spool/cron内的所有文件，还需要读一次 /etc/crontab,

用crontab -e配置是针对某个用户的，而编辑/etc/crontab是针对系统的任务。  

