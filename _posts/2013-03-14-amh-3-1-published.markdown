---
author: pandao
comments: false
date: 2013-03-14 00:47:23+00:00
layout: post
slug: '184'
title: '[最新消息] 国产LNMP面板 - AMH3.1发布'
thread: 184
categories:
- linux
---

**AMH3.1 版本更新日志：**

1、面板module模块扩展增加在线下载模块与删除模块。
2、更正FTP用户高级选项限制存在的问题、与改进面板FTP管理。
3、FTP被动模式支持。(用户反馈: zgzm)
4、Nginx错误日志关闭问题。 (用户反馈: 老虎会游泳)
5、精确硬盘容量取值与个别IP获取不准确问题。 (用户反馈: 小白很白、shylocker110)
6、面板登录验证码大写问题。
7、取消AMH3.0版本Nginx默认安装第三方模块，以保持扩展AMH模块独立性。
8、使用最新稳定版本Nginx-1.2.7
9、使用最新稳定版本PHP-5.3.22
10、面板还原重载Nginx、PHP。 (用户反馈: Edit)
11、面板备份功能新增任务计划、modules模块与iptables，无缝备份恢复。


**安装硬件需求** ---------------

最低需要内存:
32Bit: 128MB + 128Swap
64Bit: 256MB + 384Swap

小内存建议使用32Bit系统。
32Bit系统128MB内存可以安装，但至少需要128MB Swap交换区。
如无Swap交换区需128MB以上的内存。

硬盘空间：>2GB


**安装AMH** -------------------
执行安装脚本:  wget [http://amysql.com/file/AMH/3.1/amh.sh;](http://amysql.com/file/AMH/3.1/amh.sh;) chmod 775 amh.sh; ./amh.sh 2>&1 | tee amh.log;
根据提示输入选择1~3选项。1为安装amh，2为卸载amh，3为退出不做操作。
输入1回车，接着输入MySQL与AMH密码即进入安装流程，安装过程大约需10~20分钟(以服务器性能为准)，
最后如看到安装成功提示，说明系统已安装完成。
访问http://ip:8888 即可进入AMH web端管理，默认账号为admin。



**SSH命令管理** -------------------



	
  * Host : amh host

	
  * PHP : amh php

	
  * Nginx : amh nginx

	
  * MySQL : amh mysql

	
  * FTP : amh ftp

	
  * Backup : amh backup

	
  * Revert : amh revert

	
  * SetParam : amh SetParam

	
  * Module : amh module

	
  * Info : amh info


面板演示：[http://amysql.com/AMH/demo.htm](http://amysql.com/AMH/demo.htm)
官方主页：[http://amysql.com/AMH.htm](http://amysql.com/AMH.htm)
