---
layout: post
title: "过滤文件内容的利器:grep"
categories:
- Linux
tags:
- shell


---

实例文件下载：   

`wget http://linux.vbird.org/linux_basic/0330regularex/regular_express.txt`   

**例题一：查找特定字符**

	[root@mail_bk tmp]# grep -n 'the' regular_express.txt
	I can't finish the test.
	the symbol '*' is represented as start.
	You are the best is mean you are the no. 1.
	The world <Happy> is the same with "glad".
	google is the best tools for search keyword.

**例题二：反选**

	[root@mail_bk tmp]# grep -nv 'the' regular_express.txt

**例题三：查找特定字符不论大小写**

	[root@mail_bk tmp]# grep -ni 'the' regular_express.txt
	I can't finish the test.
	Oh! The soup taste good.
	the symbol '*' is represented as start.
	The gd software is a library for drafting programs.
	You are the best is mean you are the no. 1.
	The world <Happy> is the same with "glad".
	google is the best tools for search keyword.

**例题四：利用中括号\[]来查找集合字符**

查找test和taste这两个单词    
    

	[root@mail_bk tmp]# grep -n 't[a-z]st' regular_express.txt
	I can't finish the test.
	Oh! The soup taste good.
	或者
	[root@mail_bk tmp]# grep -n 't[ae]st' regular_express.txt
	I can't finish the test.
	Oh! The soup taste good.

注：其实\[]里面不论有几个字符，他都代表“一个”字符

**例题五：查找不是以g开头的oo字符**

	[root@mail_bk tmp]# grep -n '[^g]oo' regular_express.txt
	apple is my favorite food.
	Football game is not use feet only.
	google is the best tools for search keyword.
	goooooogle yes!
	注：你发现18、19行还是有g开头，这是因为该行tool是被接受的

**例题六：查找不是以字母开头的oo字符**

	[root@mail_bk tmp]# grep -n '[^a-z]oo' regular_express.txt
	Football game is not use feet only.
	总结：我们可以使用[a-z][A-Z][0-9]等方式来写，如果要求字符串是数字加字母，可以写成[a-zA-Z0-9]
	
	[root@mail_bk tmp]# grep -n '[a-zA-Z0-9]' regular_express.txt

**例题七：查找以the开头**

	[root@mail_bk tmp]# grep -n '^the' regular_express.txt
	the symbol '*' is represented as start.

**例题八：查找以小写字母开头**

	[root@mail_bk tmp]# grep -n '^[a-z]' regular_express.txt  
	apple is my favorite food.
	this dress doesn't fit me.
	motorcycle is cheap than car.
	the symbol '*' is represented as start.
	google is the best tools for search keyword.
	goooooogle yes!
	go! go! Let's go.

**例题九：查找不是英文字母开头**

	[root@mail_bk tmp]# grep -nv '^[a-zA-Z]' regular_express.txt
	"Open Source" is a good mechanism to develop programs.
	# I am VBird
	
	或者：
	[root@mail_bk tmp]# grep -n '^[^a-zA-Z]' regular_express.txt
	"Open Source" is a good mechanism to develop programs.
	# I am VBird
	注意:在中括号里面和外面含义是不同的，在括号里面标示反选，在括号外面表示行首

**例题十：查找以.点结尾的**

	[root@mail_bk tmp]# grep -n '\.$' regular_express.txt
	"Open Source" is a good mechanism to develop programs.
	apple is my favorite food.
	Football game is not use feet only.
	this dress doesn't fit me.
	motorcycle is cheap than car.
	This window is clear.
	the symbol '*' is represented as start.
	You are the best is mean you are the no. 1.
	The world <Happy> is the same with "glad".
	I like dog.
	google is the best tools for search keyword.
	go! go! Let's go.
	注意：因为小数点具有特殊含义，所以必须使用转义符（\）

**例题十一：查找空白行**

	[root@mail_bk tmp]# grep -n '^$' regular_express.txt

**例题十二：任意一个字符.点与任意重复字符**
\.代表一定有一个任意字符的意思
\*代表重复前面字符0到无穷个
1、查找g？？d的字符

	[root@mail_bk tmp]# grep -n 'g..g' regular_express.txt 
	google is the best tools for search keyword.

2、查找两个o以上的字符串

	[root@mail_bk tmp]# grep -n 'ooo*' regular_express.txt
	"Open Source" is a good mechanism to develop programs.
	apple is my favorite food.
	Football game is not use feet only.
	Oh! The soup taste good.
	google is the best tools for search keyword.
	goooooogle yes!

3、查找gog，goog，gooog字符

	[root@mail_bk tmp]# grep -n 'go*g' regular_express.txt   
	google is the best tools for search keyword.
	goooooogle yes!

4、查找g开头与g结尾的字符串，当中字符串可有可无

	"Open Source" is a good mechanism to develop programs.
	The gd software is a library for drafting programs.
	google is the best tools for search keyword.
	goooooogle yes!
	go! go! Let's go.

5、查找任意数字的字符

	[root@mail_bk tmp]# grep -n '[0-9][0-9]*' regular_express.txt      
	However, this dress is about $ 3183 dollars.
	You are the best is mean you are the no. 1.

**例题十三：查找2-5个o的连续字符串**

	[root@mail_bk tmp]# grep -n 'o\{2,5\}' regular_express.txt 
	"Open Source" is a good mechanism to develop programs.
	apple is my favorite food.
	Football game is not use feet only.
	Oh! The soup taste good.
	google is the best tools for search keyword.
	goooooogle yes!

**例题十四：查找g开头2-5个o的连续字符串，然后g结尾**

	[root@mail_bk tmp]# grep -n 'go\{2,5\}g' regular_express.txt
	google is the best tools for search keyword.
