---
author: pandao
comments: false
date: 2012-10-29 07:13:43+00:00
layout: post
slug: vmware-esxi-firewall-rules
title: Vmware esxi防火墙规则学习
thread: 158
categories:
- Virtualization
---

既然已经写了一个开放vnc的防火墙规则，那正好来整理下esxi的防火墙编写规则吧：

1.规则放置的地址为，

    
    /etc/vmware/firewall # pwd
    /etc/vmware/firewall


经测试，暂认为该目录下的所有文件都会被当作规则文件载入（测试.bak是这样的）。

2.规则编写的格式为xml文件，遵循xml一般语法格式

3.具体格式
这里摘取默认的配置文件（service.xml）中的一部分，以注释的形式说明：

    
    <!-- Firewall configuration information -->
    <ConfigRoot>
    
      <!-- Known and blessed servives -->
      ...
      <service id='0014'>   编号，从0000开始
        <id>faultTolerance</id>   服务名称，将会显示在vclient连接上之后的 配置-安全配置文件-防火墙 里面
        <rule id='0000'>    规则ID
          <direction>outbound</direction> 入站规则还是出站规则
          <protocol>tcp</protocol>        协议类型
          <porttype>dst</porttype>        端口类型
          <port>80</port>                 端口号，可以采用<port><begin>0</begin><end>65535</end></port>的形式添加端口段
        </rule>   
        <rule id='0001'>                  如果端口多个而且分散，采用多个rule id 的形式添加
          <direction>inbound</direction>
          <protocol>tcp</protocol>
          <porttype>dst</porttype>
          <port>8100</port>
        </rule>
        <rule id='0002'>
          <direction>outbound</direction>
          <protocol>tcp</protocol>
          <porttype>dst</porttype>
          <port>8100</port>
        </rule>
        <rule id='0003'>
          <direction>inbound</direction>
          <protocol>udp</protocol>
          <porttype>dst</porttype>
          <port>8200</port>
        </rule>
        <rule id='0004'>
          <direction>outbound</direction>
          <protocol>udp</protocol>
          <porttype>dst</porttype>
          <port>8200</port>
        </rule>
        <enabled>true</enabled>
        <required>false</required>
      </service>
      ... 
    </ConfigRoot>
