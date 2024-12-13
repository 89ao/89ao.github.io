---
author: pandao
comments: false
date: 2012-09-06 07:30:17+00:00
layout: post
slug: nginx-subdomains-perfect-solution
title: Nginx 二级子域名完美方案
thread: 117
categories:
- linux
---

在Nginx下实现二级域名匹配对应目录有一个非常简单的方法，在配置文件中添加两行即可实现

vim /etc/nginx/conf.d/default.conf

    
    if ( $host ~* (\b(?!www\b)\w+)\.\w+\.\w+ ) {
        set $subdomain /$1;
    }
    location / {
        root /html/$subdomain;
        index index.html;
    }


使用方法，请将上面代码复制到 server {} 标签中，然后重启nginx即可。

稍作解释，以上的正则表达式表示不匹配 “www” 但可以匹配包含 “www” 的子域名。
