---
author: pandao
comments: false
date: 2013-10-11
layout: post
slug: git-multiply-push
title: git同时push到多个仓库
categories:
  - git
tags:
  - git
---

为防止一个 git 仓库由于各种原因造成无法访问，可以将代码 push 到多个仓库。

编辑本地仓库目录下面的.git 目录下的 config 文件。

添加：

> [remote "all"]  
> url = git@github.com:licess/licess.git  
> url = git@gitcafe.com:licess/licess.git

再 push 时，运行

> git push all master
