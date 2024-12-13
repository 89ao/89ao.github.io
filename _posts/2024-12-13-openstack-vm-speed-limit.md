---
title: openstack虚拟机限速配置
date: 2024-12-13 8:0:00 +0800
lastUpdateTime: 2024-12-13 22:19:00 +0800
name: openstack-vm-speed-limit
author: "motorao"
tags: 
    - 云计算
    - 技术
categories: tech
subtitle: openstack虚拟机限速配置
---
    
目前与云主机限速相关的内容共有三处：

1. neutron qos-xxx命令，通过neutron qos的形式为云主机port绑定相应的网络限速策略（对应弹性公网IP）

1. 通过flavor对云主机进行默认限速：

```shell
命令如下：
nova flavor-key m1.small set quota:vif_inbound_average=10240
nova flavor-key m1.small set quota:vif_outbound_average=10240

```

这儿的网络QoS是直接使用libvirt提供的参数来实现的：（[http://www.libvirt.org/formatnetwork.html）](http://www.libvirt.org/formatnetwork.html%EF%BC%89)
最终落在libvirt里面实现的配置如下

```xml
  <forward mode='nat' dev='eth0'/>
  <bandwidth>
    <inbound average='1000' peak='5000' burst='5120'/>
    <outbound average='128' peak='256' burst='256'/>
  </bandwidth>

```

1. 云硬盘限速（动态）
由于不同规格云硬盘的限速要求差异，云硬盘采用公式进行限速；
对cinder进行二次开发后，在cinder.conf中配置相应的限速参数，根据创建的云硬盘大小不同，计算出不同的限速值，最后落到libvirt中生效如下：

```xml
 <disk type='network' device='disk'>
   <driver name='qemu' type='raw' cache='none' discard='unmap'/>
   <source protocol='rbd' name='ebs_ceph_ssd_sys/volume-6347f0d3-b2b1-41b2-a2b4-e75c19a9cba9'>
     <host name='10.203.135.1' port='6789'/>
     <host name='10.203.135.8' port='6789'/>
     <host name='10.203.135.15' port='6789'/>
   </source>
   <target dev='sda' bus='scsi'/>
   <iotune>
     <total_bytes_sec>146800640</total_bytes_sec>
     <total_iops_sec>2800</total_iops_sec>
   </iotune>
   <serial>6347f0d3-b2b1-41b2-a2b4-e75c19a9cba9</serial>
   <wwn>004439433801266d</wwn>
   <alias name='scsi0-0-0-0'/>
   <address type='drive' controller='0' bus='0' target='0' unit='0'/>
 </disk>

```

参考官方文档，flavor中支持以下tuning参数：
Optional metadata keys

|  |  |  |
| ---------- | ---------- | ---------- |
| CPU limits | quota:cpu_shares |  |
|  | quota:cpu_period |  |
|  | quota:cpu_limit |  |
|  | quota:cpu_reservation |  |
|  | quota:cpu_quota |  |
| Disk tuning | quota:disk_read_bytes_sec |  |
|  | quota:disk_read_iops_sec |  |
|  | quota:disk_write_bytes_sec |  |
|  | quota:disk_write_iops_sec |  |
|  | quota:disk_total_bytes_sec |  |
|  | quota:disk_total_iops_sec |  |
| Bandwidth I/O | quota:vif_inbound_average |  |
|  | quota:vif_inbound_burst |  |
|  | quota:vif_inbound_peak |  |
|  | quota:vif_outbound_average |  |
|  | quota:vif_outbound_burst |  |
|  | quota:vif_outbound_peak |  |
| Watchdog behavior | hw:watchdog_action |  |
| Random-number | generator	hw_rng:allowed |  |
|  | hw_rng:rate_bytes |  |
|  | hw_rng:rate_period |  |
|  |  |  |
