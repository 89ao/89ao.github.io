---
author: pandao
comments: false
date: 2012-08-30 06:17:48+00:00
layout: post
slug: vnc-access-esxi
title: VNC登陆esxi5的笔记
thread: 115
categories:
- linux
---

用vclient连接上esxi或者vcenter server 在虚拟机关机的情况下，鼠标右击选择 “Edit settings”；
选择 “Options” 标签页；
在 “Advanced” 下选择 “General”；
点击 “Configuration Parameters” 按钮；
最后加入如下配置参数：

    
    RemoteDisplay.vnc.enabled = “true”
    RemoteDisplay.vnc.password = “redhat”
    RemoteDisplay.vnc.port = “5901″


此时使用vnc客户端还无法连接到这个vnc服务器，这时应该编辑防火墙设置，开放5901端口

第一步，创建一个新的防火墙规则，如下:


    
    ~ # cat /etc/vmware/firewall/vnc.xml
     <!-- Firewall configuration information for VNC -->
     <ConfigRoot>
      <service>
       <id>VNC</id>
        <rule id='0000'>
         <direction>inbound</direction>
         <protocol>tcp</protocol>
         <porttype>dst</porttype>
         <port>5901</port>
        </rule>
        <rule id='0001'>
         <direction>outbound</direction>
         <protocol>tcp</protocol>
         <porttype>dst</porttype>
         <port>
          <begin>0</begin>
          <end>65535</end>
         </port>
        </rule>
        <enabled>true</enabled>
        <required>false</required>
      </service>
     </ConfigRoot>



 

 然后刷新防火墙规则，检查是否正确载入了这条规则


    
    ~ # esxcli network firewall refresh
    ~ # esxcli network firewall ruleset list | grep VNC



打开虚拟机，此时就可以用vnc客户端正常访问了。
