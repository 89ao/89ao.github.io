---
layout: post
title: "用jekyll@git写日志的流程优化"
categories:
- blog 
tags:
- git
- shell

---

在连续3天摸索jekyll@git之后，终于对它算是比较熟悉了，考虑到国外服务的稳定性([GitHub](https://github.com/))，和国内空间的访问速度([GitCafe](https://gitcafe.com))，最终决定两边都搭博相互做个冗余，域名用[dnspod](https://www.dnspod.cn/)解析，分别指向两边的空间地址。然后开启dnspod的域名监控与自动切换，如果一个节点挂掉了就自动切换到另外一个节点上去，这样在做了热备的情况下保证了速度的情况下也有一个备用节点时刻都是可以访问的。

- 这里赞一句，dnspod做的真不错，解析速度快，生效速度快，服务还很全面，非常喜欢。 -

这样做在前端显示是挺不错的了，保证了速度和稳定性，但是由于GitHub和GitCafe的细微区别，导致了两边不能整合到一起，一次写文，两边发布，所以自己折衷的想了一个办法，描述如下：

**Q1：写文非常不方便，要新建一个YYYY-MM-DD-title-md的文件，然后在文件的首几行添加上固定的格式如下，然后才在“---”之后写，而每次新建每次添加头无疑是一件非常蛋疼的事情，所以解决如下：**

	---
	layout: post
	title: "vim安装markdown语法高亮"
	categories:
	- Linux
	tags:
	- vim
	- markdown
	---
A1：文章发布脚本在此：

	#!/bin/bash
	workspace="~/gitcafe/89ao"
	date=`date +"%Y-%m-%d"`;
	title=`echo $1|sed 's/\s\+/-/g'`;
	echo $workspace/_posts/$date-$title.md;
	touch $workspace/_posts/$date-$title.md;
	echo "---" >> $workspace/_posts/$date-$title.md;
	echo "layout: post" >> $workspace/_posts/$date-$title.md;
	echo "title: \"$title\"" >> $workspace/_posts/$date-$title.md;
	echo "categories:" >> $workspace/_posts/$date-$title.md;
	echo "- " >> $workspace/_posts/$date-$title.md;
	echo "tags:" >> $workspace/_posts/$date-$title.md;
	echo "- " >> $workspace/_posts/$date-$title.md;
	echo "" >> $workspace/_posts/$date-$title.md;
	echo "" >> $workspace/_posts/$date-$title.md;
	echo "---" >> $workspace/_posts/$date-$title.md;
	vim $workspace/_posts/$date-$title.md;

然后在.bashrc里添加一句`alias rakepost='sh ~/.scripts/rakepost.sh'`，以后每次使用的时候，只需 rakepost "title name"，也不需要在写title的时候手动加上短横` \- `，十分方便。退出vim之后还能显示新建的文件路径，若是要再次编辑或者删除，也十分方便。

**Q2，两个工作目录内容同步的问题。**
A2，本来我是这么想的，做一个触发式同步的脚本，检测到有一边有改变就向另外一边同步，但是那样无疑要一直挂着一个检测进程，要不就是cron每几分钟执行一次，像我这样的性能狂人和电脑洁癖无疑是无法容忍的。最后又想一个简单的方法，描述如下：

由于gitcafe的速度优势，我选择主要工作目录在cafe下，前面的发文等工作一切正常，但是当到了要提交的时候，我在.bashrc中做了一个别名：

	alias cafepush='git push origin gitcafe-pages && sh ~/.scripts/git_sync.sh'

git_sync.sh文件内容如下

	#!/bin/bash
	rsync -avz --progress --delete --exclude ".git/" --exclude "_config.yml" --exclude "CNAME" ~/gitcafe/89ao/ ~/github/89ao.github.io/

###所以,总的alias如下：

	alias cafepush='git push origin gitcafe-pages && sh ~/.scripts/git_sync.sh'       
	alias cafe='cd ~/gitcafe/89ao/'        
	alias hub='cd ~/github/89ao.github.io/'      
	alias rakepost='sh ~/.scripts/rakepost.sh'      
	alias gitsync='sh ~/.scripts/git_sync.sh'	 
	alias gitcmt='git add . ; git commit -m'        


没错没有任何技术含量和呵呵呵呵，但是这样做的结果就是能帮我在发布了cafe的文件之后，将cafe的文件同步到hub那边，然后告诉我同步结果如何，如果有更新，那么我再去hub那边发布一下，就O了。
