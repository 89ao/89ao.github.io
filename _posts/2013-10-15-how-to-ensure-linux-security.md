---
layout: post
title: "如何保证Linux服务器的安全"
categories:
- Linux 
tags:
- Linux
- 安全


---

很少见有人马上为一台新安装的服务器做安全措施，然而我们生活所在的这个社会使得这件事情是必要的。不过为什么仍旧这么多人把它拖在最后？我也做过相同的事，这通常可以归结为我们想要马上去折腾那些有趣的东西。希望这篇文章将向大家展示，确保服务器安全没有你想得那样难。在攻击开始后，俯瞰你的“堡垒”，也相当享受。

这篇文章为 Ubuntu 12.04.2 LTS 而写，你也可以在任何其他 Linux 分发版上做相同的事情。

##我从哪儿开始？

如果服务器已经有了一个公有IP，你会希望立即锁定 root 访问。事实上，你得锁定整个ssh访问，并确保只有你可以访问。增加一个新用户，把它加入admin组（在/etc/sudoers预配置以拥有sudo访问权限）。

	$ sudo addgroup admin
	Adding group 'admin' (GID 1001)
	Done.
	 
	$ sudo adduser spenserj
	Adding user `spenserj' ...
	Adding new group `spenserj' (1002) ...
	Adding new user `spenserj' (1001) with group `spenserj' ...
	Creating home directory `/home/spenserj' ...
	Copying files from `/etc/skel' ...
	Enter new UNIX password:
	Retype new UNIX password:
	passwd: password updated successfully
	Changing the user information for spenserj
	Enter the new value, or press ENTER for the default
	    Full Name []: Spenser Jones
	    Room Number []:
	    Work Phone []:
	    Home Phone []:
	    Other []:
	Is the information correct? [Y/n] y
	 
	$ sudo usermod -a -G admin spenserj

你也将希望在你电脑上创建一个私有key，并且在服务器上禁用讨厌的密码验证。

	$ mkdir ~/.ssh
	$ echo "ssh-rsa [your public key]" > ~/.ssh/authorized_keys

**/etc/ssh/sshd_config**
	
	PermitRootLogin no
	PermitEmptyPasswords no
	PasswordAuthentication no
	AllowUsers spenserj

重新加载SSH，使用修改生效，之后尝试在一个新会话中登陆来确保所有事情正常工作。如果你不能登陆，你将仍然拥有你的原始会话来做修改。

	sudo service ssh restart
	ssh stop/waiting
	ssh start/running, process 1599

##更新服务器

既然你是访问服务器的唯一用户，你就不用担心黑客鬼鬼祟祟进入，再次正常呼吸。当有一些针对你服务器的更新时，正是修补的机会，所以动手吧，就现在。

	sudo apt-get update && sudo apt-get upgrade
	Reading package lists... Done
	Building dependency tree
	Reading state information... Done
	The following packages have been kept back:
	  linux-headers-generic-lts-quantal linux-image-generic-lts-quantal
	The following packages will be upgraded:
	  accountsservice apport apt apt-transport-https apt-utils aptitude bash ...
	73 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.
	Need to get 61.0 MB of archives.
	After this operation, 151 kB of additional disk space will be used.
	Do you want to continue [Y/n]? Y
	...
	Setting up libisc83 (1:9.8.1.dfsg.P1-4ubuntu0.6) ...
	Setting up libdns81 (1:9.8.1.dfsg.P1-4ubuntu0.6) ...
	Setting up libisccc80 (1:9.8.1.dfsg.P1-4ubuntu0.6) ...
	Setting up libisccfg82 (1:9.8.1.dfsg.P1-4ubuntu0.6) ...
	Setting up libbind9-80 (1:9.8.1.dfsg.P1-4ubuntu0.6) ...
	Setting up liblwres80 (1:9.8.1.dfsg.P1-4ubuntu0.6) ...
	Setting up bind9-host (1:9.8.1.dfsg.P1-4ubuntu0.6) ...
	Setting up dnsutils (1:9.8.1.dfsg.P1-4ubuntu0.6) ...
	Setting up iptables (1.4.12-1ubuntu5) ...
	...

##安装防火墙

安装现在正最流行的防火墙软件？好，行动吧。那就配置一个防火墙。之后你总是可以增加另一个异常，几分钟额外的工作并不会折腾死你。Iptables在Ubuntu里预装了，所以去设置一些规则吧。

	sudo mkdir /etc/iptables
	/etc/iptables/rules
	
	*filter
	:INPUT DROP [0:0]
	:FORWARD DROP [0:0]
	:OUTPUT DROP [0:0]
	 
	# Accept any related or established connections
	-I INPUT  1 -m state --state RELATED,ESTABLISHED -j ACCEPT
	-I OUTPUT 1 -m state --state RELATED,ESTABLISHED -j ACCEPT
	 
	# Allow all traffic on the loopback interface
	-A INPUT  -i lo -j ACCEPT
	-A OUTPUT -o lo -j ACCEPT
	 
	# Allow outbound DHCP request - Some hosts (Linode) automatically assign the primary IP
	#-A OUTPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT
	 
	# Outbound DNS lookups
	-A OUTPUT -o eth0 -p udp -m udp --dport 53 -j ACCEPT
	 
	# Outbound PING requests
	-A OUTPUT -p icmp -j ACCEPT
	 
	# Outbound Network Time Protocol (NTP) request
	-A OUTPUT -p udp --dport 123 --sport 123 -j ACCEPT
	 
	# SSH
	-A INPUT  -i eth0 -p tcp -m tcp --dport 22 -m state --state NEW -j ACCEPT
	 
	# Outbound HTTP
	-A OUTPUT -o eth0 -p tcp -m tcp --dport 80 -m state --state NEW -j ACCEPT
	-A OUTPUT -o eth0 -p tcp -m tcp --dport 443 -m state --state NEW -j ACCEPT
	 
	COMMIT

通过 `iptables-apply` 命令为规则集生效。如果你丢失连接，修补你的规则，在继续之前再试一下

	$ sudo iptables-apply /etc/iptables/rules
	Applying new ruleset... done.
	Can you establish NEW connections to the machine? (y/N) y
	... then my job is done. See you next time.

创建文件 /etc/network/if-pre-up.d/iptables，然后写入下面内容。当你启动服务器的时候，将自动载入你的iptables规则。

**/etc/network/if-pre-up.d/iptables**

	#!/bin/sh
	iptables-restore < /etc/iptables/rules

现在给它执行权限，执行文件，以确保它正常载入

	$ sudo chmod +x /etc/network/if-pre-up.d/iptables
	$ sudo /etc/network/if-pre-up.d/iptables

##用 Fail2ban 处理潜在黑客

当谈到安全的时，Fail2ban 是我最喜欢的工具之一，它将监控你的日志文件，并且可以临时禁止那些正在滥用你资源，或者正在强制肆虐你的SSH连接，或者正在dos攻击你web服务器的用户。

**Install Fail2ban**

	$ sudo apt-get install fail2ban
	[sudo] password for sjones:
	Reading package lists... Done
	Building dependency tree
	Reading state information... Done
	The following extra packages will be installed:
	  gamin libgamin0 python-central python-gamin python-support whois
	Suggested packages:
	  mailx
	The following NEW packages will be installed:
	  fail2ban gamin libgamin0 python-central python-gamin python-support whois
	0 upgraded, 7 newly installed, 0 to remove and 2 not upgraded.
	Need to get 254 kB of archives.
	After this operation, 1,381 kB of additional disk space will be used.
	Do you want to continue [Y/n]? y
	...

虽然 Fail2ban 安装一个默认配置(/etc/fail2ban/jail.conf)，但我们希望在 /etc/fail2ban/jail.local 写配置，所以把它拷贝到那儿。

	sudo cp /etc/fail2ban/jail.{conf,local}

##配置

把 ignoreip 行修改为你的ip，并且可以设置禁止恶意用户的时间量(默认是10分钟)。你也将希望设置一个destemail，这里我通常输入我自已的email地址，再在后面加上 ,fail2ban@blocklist.de。BlockList.de 是一个跟踪并且自动报告黑客IP的系统。

**/etc/fail2ban/jail.local**


	[DEFAULT]
	 
	# "ignoreip" can be an IP address, a CIDR mask or a DNS host
	ignoreip = 127.0.0.1/8
	bantime  = 600
	maxretry = 3
	 
	# "backend" specifies the backend used to get files modification. Available
	# options are "gamin", "polling" and "auto".
	# yoh: For some reason Debian shipped python-gamin didn't work as expected
	#      This issue left ToDo, so polling is default backend for now
	backend = auto
	 
	#
	# Destination email address used solely for the interpolations in
	# jail.{conf,local} configuration files.
	destemail = root@localhost,fail2ban@blocklist.de
	这有一些其他的你想检查的配置，尽管缺省配置已经相当不错了，所以，快速浏览这些，直到你读到Actions章节。


**Actions**

Actions 允许你对恶意行为作出反应，然而当我们想要它禁止和发邮件的时候，默认是禁用了 iptables。值得感谢的是，有一个预配置文件 action_wml，它恰恰是做这个的。

**/etc/fail2ban/jail.local**

	# Choose default action.  To change, just override value of 'action' with the
	# interpolation to the chosen action shortcut (e.g.  action_mw, action_mwl, etc) in jail.local
	# globally (section [DEFAULT]) or per specific section
	action = %(action_mwl)s

##Jails 监控

为了让Fail2ban工作，需要了解要监控哪些东西。这些已在Jails部分的配置文件，并且这有一些预载入而未启用的例子。既然到目前为止，你仅仅在服务器上启用了SSH访问，那我们就只启用SSH和SSH-DDos 监控，然而你还是会想给安装在这台服务器上的公共访问服务增加新的监控。

**/etc/fail2ban/jail.local**

	[ssh]
	enabled  = true
	port     = ssh
	filter   = sshd
	logpath  = /var/log/auth.log
	maxretry = 6
	[ssh-ddos]
	enabled  = true
	port     = ssh
	filter   = sshd-ddos
	logpath  = /var/log/auth.log
	maxretry = 6

###让变化生效

既然我们已经配置了Fail2ban，你将希望重新载入它，并且确保向iptables增加了合适的规则。

	$ sudo service fail2ban restart
	 * Restarting authentication failure monitor fail2ban
	   ...done.
	 
	$ sudo iptables -L
	Chain INPUT (policy DROP)
	target     prot opt source               destination
	fail2ban-ssh-ddos  tcp  --  anywhere             anywhere             multiport dports ssh
	fail2ban-ssh  tcp  --  anywhere             anywhere             multiport dports ssh
	...
	Chain fail2ban-ssh (1 references)
	target     prot opt source               destination
	RETURN     all  --  anywhere             anywhere
	 
	Chain fail2ban-ssh-ddos (1 references)
	target     prot opt source               destination
	RETURN     all  --  anywhere             anywhere

在任何时间，你都可以使用sudo iptables -L 来列出你的规则，随后列出所有当前禁止的 IP。此时，Fail2ban正在处理两个恶意的用户。

###Banned IPs

	DROP       all  --  204.50.33.22         anywhere
	DROP       all  --  195.128.126.114      anywhere

##保持最新更新

你可能现在拥有一个已经锁定并且准备投入使用的服务器，然而这并不是你安全之旅的终点。保持最新更新(并且总是首先在非产品环境下测试)，总是关闭你不需要的端口，定期检查你的日志，并且由内而外了解你的服务器。

##HackerNews 上的讨论

我的这篇文章，在 HackerNews 上有一些很好的评论，如果你对不同观点和更好的安全性感兴趣的话，我建议你去看看。这篇文章目的是作为服务器安全的新手指南，在这篇文章结束的时候，并不意味着你的服务器是无懈可击的。用本文来快速锁定一个新服务器，在它之上为你特有的情况建立其他措施。你可能希望查询 IPV6 安全，改变你的SSH端口(通过隐藏达到安全目的)，安全内核(SELinux和GRSecurity)，跟踪系统改变，并且如果你的服务器曾经不安全或已经在线相当长时间了的话，全面检查一番。一台服务器有好几百个入口点，并且每一个你安装的应用都带来了额外的潜在漏洞，但是通过合适的工具，你可以免去困扰，直接去睡大觉了。
