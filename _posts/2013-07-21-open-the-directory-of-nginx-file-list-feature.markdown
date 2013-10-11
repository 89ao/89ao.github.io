---
author: pandao
comments: false
date: 2013-07-21 09:06:58+00:00
layout: post
slug: open-the-directory-of-nginx-file-list-feature
title: 开启Nginx的目录文件列表功能
thread: 214
categories:
- Blog相关
- linux
---

### ngx_http_autoindex_module


此模块用于自动生成目录列表.

ngx_http_autoindex_module只在 ngx_http_index_module模块未找到索引文件时发出请求.

__配置实例__

    
    location  /  {
    : autoindex  on;
    }




## 指导





	
  * [#autoindex autoindex]

	
  * [#autoindex_exact_size autoindex_exact_size]

	
  * [#autoindex_localtime autoindex_localtime]




## autoindex


**syntax:** _autoindex [ on|off ]_

**default:** _autoindex off_

激活/关闭自动索引




## autoindex_exact_size


**syntax:** _autoindex_exact_size [ on|off ]_

**default:** _autoindex_exact_size on_

设定索引时文件大小的单位(B,KB, MB 或 GB)




## autoindex_localtime


**syntax:** _autoindex_localtime [ on|off ]_

**default:** _autoindex_localtime off_

开启以本地时间来显示文件时间的功能。默认为关（GMT时间）


## 参考


[Original Documentation](http://sysoev.ru/nginx/docs/http/ngx_http_autoindex_module.html)
