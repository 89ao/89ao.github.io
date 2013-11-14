---
layout: post
title: "pretending write like a geek"
categories:
- blog
tags:
- blog


---

我终于下决心迁移到 GitHub 上。好处就不多说了，看看[别人怎么说 Jekyll @ GitHub](http://www.besteric.com/2013/05/08/migrate-wordpress-to-jekyll/)吧。

GitHub上找了个[模板](http://webfrogs.me/2012/12/20/use-jekyll/)，花了一整天折腾修改，分类、链接、评论、附件等终于都完美了，搜索引擎优化、站内搜索等还没完成。如果需要可以在 [GitHub](http://www.github.com/Yonsm) 上参考我的这个 [博客的完整代码](http://www.github.com/Yonsm/NET)。

回看一下博客建立到现在快 9 年了，从刚开始的把博客当微博用，到中期的勤奋“耕耘”，再对比一下今年的7个月快过去了才 3 篇不像样的文章，今昔非比。这次迁移重新整理了博客，文章数目从 530 篇缩减到 250 篇。希望这次变换博客空间和引擎是个契机（好吧，是借口），接下来的时间里能多产出点东西。Idea 有很多，能不能出来就不知道了。

刚开始使用 Markdown 写东西，很不错。语法高亮可以使用 [Pygments](http://pygments.org/) ，[使用介绍在此](https://github.com/mojombo/jekyll/wiki/Liquid-Extensions)。例子效果如下：

{% highlight bash linenos %}
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
{% endhighlight %}
