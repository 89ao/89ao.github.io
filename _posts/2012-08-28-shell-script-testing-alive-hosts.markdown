---
author: pandao
comments: false
date: 2012-08-28 16:00:16+00:00
layout: post
slug: shell-script-testing-alive-hosts
title: Shell脚本之：检测局域网中存活的主机
thread: 123
categories:
- linux
---

#!/bin/bash
    #usage ：“ ./ping 192.168.100 ”
    prefix=$1
    for n in {1..254}
    do
    host=$1.$n
    ping -c2 $host > /dev/null
    if [ $? = 0 ];
    then
    echo “$host is up”
    else
    echo “$host is DOWN”
    echo “$host” >> $1down.txt
    fi
    done
