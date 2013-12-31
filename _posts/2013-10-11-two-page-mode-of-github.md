---
author: pandao
comments: false
date: 2013-10-11
layout: post
slug: two-page-mode-of-github
title: GitHub的两种pages模式
categories:
- Git
tags:
- git
---



##两种pages模式
  
    
    
####User/Organization Pages 个人或公司站点


1. 使用自己的用户名，每个用户名下面只能建立一个；

2. 资源命名必须符合这样的规则username/username.github.com；

3. 主干上内容被用来构建和发布页面


####Project Pages 项目站点


1. gh-pages分支用于构建和发布；

2. 如果user/org pages使用了独立域名，那么托管在账户下的所有project pages将使用相同的域名进行重定向，除非project pages使用了自己的独立域名；

3. 如果没有使用独立域名，project pages将通过子路径的形式提供服务username.github.com/projectname；

4. 自定义404页面只能在独立域名下使用，否则会使用User Pages 404；

5. 创建项目站点步骤：


    >git clone https://github.com/USERNAME/PROJECT.git PROJECT    
    >git checkout --orphan gh-pages   
    >git rm -rf .   
    >git add .   
    >git commit -a -m "First pages commit"   
    >git push origin gh-pages   
  

####可以通过User/Organization Pages建立主站，而通过Project Pages挂载二级应用页面。
