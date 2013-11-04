---
layout: post
title: "3个工作中写的小shell"
categories:
- Shell
tags:
- Shell


---

###shell检查服务器上所有运行的进程所在的路径：


	#!/bin/bash
	ps aux |grep -v grep|awk '{print $2}' > pids.txt
	#for pid in pids.txt
	echo "" > pd.txt
	ifconfig |grep inet|grep -v addr:127|awk '{print $2}' > result.txt
	cat pids.txt|while read line
	do
	#echo $line
	ls -l /proc/$line/cwd |awk '{print $10}'>> pd.txt
	done
	cat pd.txt|sort -u|grep -v pid2dir >> result.txt
	rm pd.txt pids.txt
	cat result.txt

改进：
1.目标是显示出进程的pid，进程名称和路径，这样显示的结果会丰富一些。   
2.自动分发脚本，自动检查所有服务器的结果并汇总到一个文件中。  
3.错误重定向，只显示错误的结果或者只显示正确的结果。  

###以进程名杀进程脚本：  

1.循环，2.赋值  

	for pickid in `ps -o pid,args -u $USER|grep -v grep|awk '{print $1}'`
	do
	echo "kill name ${pickid}"
	kill -9 $pickid
	done


###Dologs.sh

统计多个日志文件，选择某个时间段内的然后对某个关键词进行过滤，最后输出特定某几列。


	#!/bin/sh
	find $1 -ctime -60 -name "*.log*" | grep -E 'ep|service'> logs.txt
	cat logs.txt|while read line;do
	echo "----------------------$line----------------------"
	echo "MSG without parse numbers:---"
	cat $line|grep "MSG without parse"|awk '{a[$1]++}END{for(i in a){if ( substr(i, 2)>= "2013-08-01" && substr(i, 2) <= "2013-09-15")print substr(i, 2),a[i]}}' > 1.tmp
	cat 1.tmp|sort|uniq -u
	echo ">>> numbers: ---"
	cat $line|grep ">>> "|awk '{a[$1]++}END{for(i in a){if ( substr(i, 2)>= "2013-08-01" && substr(i, 2) <= "2013-09-15")print substr(i, 2),a[i]}}' > 2.tmp
	cat 2.tmp|sort|uniq -u
	echo ""
	done
	rm logs.txt 1.tmp 2.tmp


