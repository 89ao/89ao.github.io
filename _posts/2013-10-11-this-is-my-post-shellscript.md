---
layout: post
title: "this-is-my-post-shellscript"
categories:
- shell
tags:
- shell


---
写了个快捷发日志的shell，主要功能是在固定目录生成”yyyy-mm-dd-title.md“的文件，然后填入初始化内容，再打开vim编辑。代码如下:

	#!/bin/bash
	workspace="/home/viao/github/89ao.github.io/_posts/"
	date=`date +"%Y-%m-%d"`;
	title=`echo $1|sed 's/\s\+/-/g'`;
	echo $workspace$date-$title.md;
	touch $workspace$date-$title.md;
	echo "---" >> $workspace$date-$title.md
	echo "layout: post" >> $workspace$date-$title.md
	echo "title: \"$title\"" >> $workspace$date-$title.md
	echo "categories:" >> $workspace$date-$title.md
	echo "- " >> $workspace$date-$title.md
	echo "tags:" >> $workspace$date-$title.md
	echo "- " >> $workspace$date-$title.md
	echo "" >> $workspace$date-$title.md
	echo "" >> $workspace$date-$title.md
	echo "---" >> $workspace$date-$title.md
	vim $workspace$date-$title.md
