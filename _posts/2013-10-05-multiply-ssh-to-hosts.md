---
layout: post
title: "方便ssh登陆多个主机的shell"
categories:
- Shell
tags:
- Shell
- ssh


---

1，事先在管理机上做好每个host的ssh key认证

2，脚本如下

project@pdc-linux2:~> vim /home/project/bin/s

	#!/bin/bash
	#
	# ssh to the server 
	#
	# Source function library
	#. /etc/rc.d/init.d/functions
	
	prog=s
	
	ip=$1
	case "$ip" in
	1|2|3|4|5|6|7|8|9|10)
	   echo "It's going to ssh to project-serv$ip..."
	   let ip=10+$ip
	   ssh 10.11.96.$ip
	   ;;
	
	21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|101|102|103|104|105|106)
	   echo "It's going to ssh to project-serv$ip..."
	   ssh 10.11.96.$ip
	   ;;
	
	mysql1)
	   echo "Starting ssh to project-mysql1..."
	   ssh 10.11.103.11
	   ;;
	
	mysql2)
	    echo "Starting ssh to project-mysql2..."
	   ssh 10.11.103.101
	   ;;
	
	mongo1)
	    echo "Starting ssh to project-mongo1..."
	    ssh 10.11.103.21
	    ;;
	...
	mongo5)
	    echo "Starting ssh to project-mongo5..."
	    ssh 10.11.103.42
	    ;;
	*)
	    echo "Usage: $prog {1~10|21~40|101~106|mysql1|mysql2|mongo1|mongo2}
	        1:nginx1                     |||   101:service
	          nginx-log1                 |||       #nginx
	          zookemoduleer              |||       #nginx-log
	        2:timer-task-1               |||       zk-tomcat
	          timer-manager-1            |||       zookemoduleer
	          auth-redis                 |||   102:rose
	          			     |||       storage-service
	          #elasticsearch             |||       timer-manager
	        3:authenticationserver-1     |||       timer-task
	          service-2                  |||   103:file-server
	        4:module-1                   |||       
	          service-redis              |||       fs
	          	                     |||   104:module
	        5:module189                  |||       poi-timer
	          storage-service-2          |||       poi-task
	          rose-2                     |||   105:portal-campus(include seed portal)
	        6:fileserver-1               |||       portal-callme
	          	                     |||       portal-goldenGateBridge
	          module-2                   |||       portal-timeMachine
	        7:storage-service-1          |||       portal-wciphone
	          storage-service-new-1      |||       mysql2redis
	          zookemoduleer              |||       #authenticationServer
	        8:service-1                  |||       zk-service
	          fileserver-2               |||   106:elasticSearch
	        9:hadoop/statistics          |||   
	          timer-task-2               |||   
	        10:nginx-2                   |||   
	           nginx-log-2               |||   
	           zookemoduleer             |||   
	           zookemoduleer portal      |||   
	        ----------------------------------------------------------------------------
	        21:nginx、tomcat-zookemoduleer
	        22:authentication、fileserver、mongo2redis、redis、zookemoduleer
	        23:service
	        24:module(1)
	        25:module(2)
	        26:rose-manager
	"
	        ;;
	
	esac
	exit 0
	
