---
layout: post
title: "vim安装markdown语法高亮"
categories:
- Linux
tags:
- vim
- markdown


---



背景：在寻找markdown编辑器的时候出现了一些麻烦，首先考虑的是notepad++和SublimeText,两个编辑器的确都很好用，找了半天，终于找到了两者的语法规则文件，Notepad++的比较好找，下个userdefine.xml,放在配置目录，重启即可。SublimeText2请看[这个链接](http://lucifr.com/2012/07/12/markdownediting-for-sublime-text-2/)

最后由于担心windows下中文会乱码，而且Vim也的确用的非常习惯了，考虑下还是用vim吧，如下为记录：

主要使用的包为Vim-Markdown    
首先在[Vim官方](http://www.vim.org/scripts/script.php?script_id=2882)下载markdown语法规则文件`markdown-1.2.2.vba.gz`
使用vim打开规则文件(不需解压)

	>$ vim markdown-<version>.vba.gz
	>输入  :source %

完成。此时用你的vim打开markdown,md等文件均会出现markdown语法高亮。



此文非常简单，为熟悉Markdown语法所写,如果能帮上您，不胜荣幸。
