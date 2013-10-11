---
author: pandao
comments: false
date: 2013-07-05 14:33:41+00:00
layout: post
slug: replacing-apache-with-nginx-to-run-icinga
title: 用nginx替换apache来运行icinga
thread: 201
categories:
- linux
---

原文地址:[http://blog.fraktalgemuese.de/index.php/2011/02/08/icinga-nagios-auf-nginx/](http://blog.fraktalgemuese.de/index.php/2011/02/08/icinga-nagios-auf-nginx/)
参考下边配置即可。

server {
   listen   80;
   server_name *****;
   access_log /var/wwwaccess.log;
   error_log /var/wwwerror.log;

   location / {
       root   /usr/local/icinga/share;
       index  index.html;

       # fix image, css and javascript urls
       # FIXME: find smarter way to fix path
       rewrite ^/icinga/images/(.*)\.(.*) /images/$1.$2 break;
       rewrite ^/icinga/stylesheets/(.*)\.css /stylesheets/$1.css break;
       rewrite ^/icinga/js/(.*)\.(.*) /js/$1.$2 break;

       auth_basic              "Restricted";
       auth_basic_user_file    /usr/local/icinga/etc/htpasswd.users;

   }

   location ~ \.cgi$ {
       # define root directory for CGIs
       root /usr/local/icinga/sbin;
       rewrite ^/icinga/cgi-bin/(.*)\.cgi /$1.cgi break;

       include /etc/nginx/fastcgi_params;
       fastcgi_pass  127.0.0.1:49233;
       fastcgi_index index.php;
       fastcgi_param  SCRIPT_FILENAME  /usr/local/icinga/sbin/$fastcgi_script_name;

       auth_basic              "Restricted";
       auth_basic_user_file    /usr/local/icinga/etc/htpasswd.users;

       # without passing these parameters you will not be allowed to view/do anything
       fastcgi_param  AUTH_USER          $remote_user;
       fastcgi_param  REMOTE_USER        $remote_user;
   }
}
