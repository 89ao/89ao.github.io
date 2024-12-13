---
author: pandao
comments: false
date: 2012-08-06 15:42:02+00:00
layout: post
slug: apache-experiment-vhosts-fcontext-authentication
title: apache实验(考察虚拟主机,上下文,基于用户的身份认证)
thread: 100
categories:
- linux
---

1.基于名称的虚拟主机，其中多个主机都指向同一个IP地址，但是web服务器根据用于到达站点的主机名提供具有不同内容的不同站点，web服务器将其配置 文件中查看每个传入请求的IP地址的第一个VirtualHost块，其中ServerName 或ServerAlias与请求所使用的主机名相匹配，他将根据匹配的VirtualHost的配置提供的内容，如果主机名在任何块中都不匹配，那么默认情况下将使用请求的IP地址的第一个VirtualHost块。

	题目：部署两个虚拟主机，要求如下：
	1）虚拟主机1：http://serverX.example.com, 发布目录：/var/www/virtual
	2）虚拟主机2：http://wwwX.example.com，发布目录：/www2/virtual
	3）其中/www/virtual/private是受保护区域，需要用户验证，用户名：user1密码：user1
	4）下载CGI文件ftp：//instructor/pub/gls/special.cgi，并将其安装为http://wwwX.example.com/cgi-bin/special.cgi

（1）修改配置文件

	vi /etc/httpd/conf/httpd.conf
	NameVirtualHost *:80(前面的注释去掉，指定在其中启用基于地址名称的虚拟主机)
	DocumentRoot /var/www/html
	ServerName desktop2.example.com(指定服务器的名称，在使用基于名称的虚拟主机>的情况下，此处的名称必须和客户端的请求完全一致的)
	ServerAlias desktop2
	
	ServerAdmin webmaster@example.com（指定管理电子邮件的客户帐号web页面出错将提供此电子邮件的地址）
	DocumentRoot /www2/virtual（定义提供内容的目录）
	ServerName www2.example.com
	ServerAlias www2
	ErrorLog logs/dummy-host.example.com-error_log
	CustomLog logs/dummy-host.example.com-access_log common

（2）mkdir /www2/virtual -p	
然后给/www2/virtual赋予安全上下文的权限，

	chcon –reference=/var/www/html/ /www2 -R（

或者是使用命令`semanage fcontext -a -t httpd_sys_content_t “/www(/.*)?” "`和`restorecon -VvFR /www2`或者是一条命令`chcon -t httpd_sys_content_t -R`）

(3) cd /www2/virtual	
echo `pwd` > index.html	
cd /var/www/html	
echo `pwd` > index.html	

(4)在你主机上添写解析：

	192.168.0.2 desktop2.example.com
	192.168.0.2 www2.example.com(注意写解析的时候要先写IP再写域名，否则解析不过去)

(5)重启服务:/etc/init.d/httpd restart

打开浏览器：输入desktop2.example.com显示：	
/var/www/html	
输入www2.example.com显示：	
/www2/virtual	

实验2：倘若/www/virtual/private是受保护区域，需要用户验证，用户名：user1 密码：user1	

（1）修改配置文件

	vi /etc/httpd/conf/httpd.conf
	NameVirtualHost *:80
	
	DocumentRoot /var/www/html
	ServerName desktop2.example.com
	ServerAlias desktop2
	
	ServerAdmin webmaster@example.com
	DocumentRoot /www2/virtual
	ServerName www2.example.com
	ServerAlias www2
	ScriptAlias /cgi-bin/ “/www2/virtual/cgi-bin/” //将指定的/www2/virtual/cgi-bin可以用/cgi-bin。也就是说你输入/cgi-bin和输入/www2/virtual/cgi-bin是一样
	//以下是关于私有文件的访问控制。
	authname “user1shan”
	authtype basic
	authuserfile /etc/httpd/.htpasswd
	require user user1
	
	ErrorLog logs/dummy-host.example.com-error_log
	CustomLog logs/dummy-host.example.com-access_log common
	
（2）mkdir /www2/virtual/cgi-bin	
mkdir /www2/virtual/private	
cd /www2/virtual/cgi-bin	
wget ftp://instructor/pub/gls/special.cgi .	
chcon –reference=/var/www/cgi-bin /www2/virtual/cgi-bin -R	
cd /www2/virtual/private	
echo private > index.html	
chcon –reference=/var/www/html /www2/virtual/private -R		
(3)htpasswd -cm /etc/httpd/.htpasswd user1(输入密码)	

（4）service httpd restart	

（5）写解析

	192.168.0.2 desktop2.example.com	
	192.168.0.2 www2.example.com	

(6)测试：

http：//desktop2.example.com 输出/var/www/html	
http：//www27.example.com 输出/www2/virtual	
http://www27.example.com/cgi-bin/special.cgi 输出hello	
http://www2.example.com/private/ 输出private，不过此时要输入密码 的哦！（你刚才设置的）		
另外你也可以用elinks -dump http://desktop2.example.com		
elinks -dump http://www2.example.com		
附加：Apache LDAP 用户身份验证，在此配置中,用户账户和密码存储在远程 LDAP 目录服务中。此配置的优势在于多个 Web 服务器可以使用一个目录服务来存储用户账户和密码,从而可以更加轻松地保持两者的同步性。配置如下：	

(1)配置客户端 LDAP 身份验证,将 instructor.example.com 用作 LDAP 服务器, dc=example,dc=com并使用在 ftp://instructor.example.com/pub/example-ca.crt 上的证书 , 选择 LDAP 密码。

(2)下载 LDAP 证书 ftp://instructor.example.com/pub/example-ca.crt ,并将其复制到 /etc/httpd
wget ftp://instructor.example.com/pub/example-ca.crt -P /etc/httpd

（3）假设之前定义 VirtualHost 块,请将诸如以下内容添加至 VirtualHost 块:

	LDAPTrustedGlobalCert CA_BASE64 /etc/httpd/example-ca.crt # 此选项不能在 Virtualhost语句块中
	
	……
	
	authname “secret”
	authtype basic
	authbasicprovider ldap
	authldapurl “ldap://instructor.example.com/dc=example,dc=com” TLS
	require valid-user //合法用户
	
（4）重启 apache 服务,并使用 Web 浏览器测试访问http://www2.example.com/private/index.html,以用户 ldapuser1 和密码 password 登录。
