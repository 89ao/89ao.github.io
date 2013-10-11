---
author: pandao
comments: false
date: 2011-08-08 09:58:47+00:00
layout: post
slug: oracle-sets-tnsnames-ora
title: ORACLE10.2设置tnsnames.ora
thread: 51
categories:
- database
---

地址如下：C:\oracle\product\10.2.0\db_1\NETWORK\ADMIN

格式为：
`ORCL =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.42.130)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = ORCL)
    )
  )` 
注：这里只列出了几个关键设置，全部的配置请详见sample目录下的tnsnames.ora文件。
