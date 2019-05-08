---
layout: post
title: "解决Google字库以及useso字库访问慢的问题"
categories:
- git
tags:
- git
- jekyll

---

把Google开源字体库缓存到本地

解决google字体库修改为useso字体库之后仍然很慢的问题

原来因为google字体库（http://fonts.googleapis.com/） 访问很慢，于是把字体库改成了国内的useso（http://fonts.useso.com/） ，暂时的解决了问题。但是后来发现useso是由360支持的，也担心有一天会不稳定，想什么时候有空干脆把字体弄到本地好了，反正就3个英文字体，也不占多大空间。

这天打开博客的时候又响应很慢，要10s左右才有反应，定位一下，正是useso字体库响应慢。正好前几天本地的jekyll环境也弄好了，干脆择日不如撞日，今天搞定算了，也算一劳永逸。

1. 首先找到有哪些引用字体库的文件（其实只有两个css）

		viao@MacAo:~/git/89ao (coding-pages*%=) % grep -r useso ./
		.//_site/media/css/home.css:@import url(http://fonts.useso.com/css?family=Galdeano);
		.//_site/media/css/style.css:@import url(http://fonts.useso.com/css?family=Galdeano|Electrolize|Cuprum);
		..//media/css/home.css:@import url(http://fonts.useso.com/css?family=Galdeano);

1. 打开 http://fonts.useso.com/css?family=Galdeano 等链接，会发现形如如下内容：

		@font-face {
		font-family: 'Galdeano';
		font-style: normal;
		font-weight: 400;
		src: local('Galdeano Regular'), local('Galdeano-Regular'), url(http://fonts.gstatic.com/s/galdeano/v6/XWkZhyfrNgo9X-giTt_ZfXYhjbSpvc47ee6xR_80Hnw.woff) format('woff');}

1. 下载其中的 http://fonts.gstatic.com/s/galdeano/v6/XWkZhyfrNgo9X-giTt_ZfXYhjbSpvc47ee6xR_80Hnw.woff 等字体文件

1. 字体文件拷贝到自己jekyll的相应目录，算好push之后的url应该是如何的，做相应的规划:

		698* mv ~/Downloads/XWkZhyfrNgo9X-giTt_ZfXYhjbSpvc47ee6xR_80Hnw.woff galdeano/v6
		689* cd assets
		690* ls
		691* mkdir fonts
		692* cd fonts
		693* mkdir -p cuprum/v7/
		694* mv ~/Downloads/dS-oM09uC7agWFnFSCUGievvDin1pK8aKteLpeZ5c0A.woff cuprum/v7
		695* mkdir -p electrolize/v5/
		696* mv ~/Downloads/DDy9sgU2U7S4xAwH5thnJ7rIa-7acMAeDBVuclsi6Gc.woff electrolize/v5
		697* mkdir -p galdeano/v6/

1. 修改第一步中的css文件，把import xxx删掉，添加第二步中获取的内容，将url修改成push之后的url，类似：

		@font-face {
		font-family: 'Galdeano';
		font-style: normal;
		font-weight: 400;
		src: local('Galdeano Regular'), local('Galdeano-Regular'), url(http://89ao.coding.me/assets/fonts/galdeano/v6/XWkZhyfrNgo9X-giTt_ZfXYhjbSpvc47ee6xR_80Hnw.woff) format('woff');}

1. 完成！push and view吧！

		715* git push -u origin coding-pages
		713* git add .
		714* git commit -m "modify fonts css"

