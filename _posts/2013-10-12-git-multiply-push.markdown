---
layout: post
slug: git-multiply-push
title: 我的elementaryOS设置
date: 2013-10-12 08:09
comments: true
categories: blog
tags:git
---
git同时push到多个仓库
By lidashuang at 8 个月前 , 324 次浏览
为防止一个git仓库由于各种原因造成无法访问，可以将代码push到多个仓库。

编辑本地仓库目录下面的.git目录下的config文件。

添加：

[remote "all"]
url = git@github.com:licess/licess.git
url = git@gitcafe.com:licess/licess.git

再push时，运行

git push all master
