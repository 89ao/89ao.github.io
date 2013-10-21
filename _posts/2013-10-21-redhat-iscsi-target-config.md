---
layout: post
title: "redhat配置iscsi服务"
categories:
- Linux
tags:
- iscsi


---
配置流程如下，聊作记录：

	首先添加iscsi组    
	tgtadm -L iscsi -m target -o new -t 1 -T iqn.2001-01.com.rhcs:disk1    
	然后发布逻辑卷    
	tgtadm -L iscsi -m logicalunit -o new -t 1 -l 1 -b /dev/vdb5    
	tgtadm -L iscsi -m logicalunit -o new -t 1 -l 2 -b /dev/vdb6    
	然后设置ACL策略    
	tgtadm -L iscsi -m target -o bind -t 1 -I ALL    
	察看发布结果    
	tgt-admin -s    
	将配置dump出来以便下次使用    
	tgt-admin --dump > /etc/tgt/targets.conf    
