---
author: pandao
comments: false
date: 2013-07-11 22:52:33+00:00
layout: post
slug: build-the-perfect-monitoring-system
title: 搭建完美的监控系统
thread: 206
categories:
- linux
---




## 对于任何一个互联网公司来说，监控系统都是不可或缺的。监控系统的完善程度，直接影响到系统的稳定程度，性能等各个方面。









关于监控系统的搭建，网上已经有了很多方案，在规划公司的监控体系的时候，我也参考了很多解决方案。比较常见的有：nagios,cacti,icinga,zabbix,ganglia，还有收费的监控服务有如newrelic等。

考察了一圈下来，发现各有所长，又各有重叠。nagios的优势是报警功能非常成熟和强大，插件体系也非常简单易扩展，但是，对性能、流量等指标的 处理不给力。于是需要cacti来互补，cacti虽说不仅仅支持snmp，但是对于业务数据的监控（如页面pv量）支持仍然不是很好，icinga是 nagios的兼容升级版，遗憾的是，缺点还在。zabbix貌似保护了nagios+cacti，但是对于我们来说，显得大而全，略重，于是没细看。 ganglia貌似挺不错，flickr在用。

最后，我决定，使用collectd+statsd(statsite)+graphite+nagios来做我们的监控方案。

这套系统包含三个部分：


#### 一个是指标的收集


这里使用collectd和statsite，[collectd](http://collectd.org/)是一个非常 小巧清新（我喜欢）的指标收集系统，部署在所有机器上，它会定时将机器的各种指标（通过各种插件来实现）写到rrd文件中或者发送到其他系统（如 graphite或者另外一个collectd服务）。自带的几十个插件几乎覆盖了基础技术指标的所有方面，从磁盘读写到网络流量，从到load到内存再 到mysql。我们在所有机器上都部了collectd，然后将指标汇总到一台collectd服务器上。这个collectd再将数据写到 graphite中。于是，基础技术指标全来了。

[statsite](http://github.com/armon/statsite)（[statsd](http://github.com/etsy/stats)的 c语言版）也是一个指标收集系统，它和collectd一样小巧清新，不同的地方在于，collectd是定时主动去获取指标，而statsite则是需 要应用程序不断的将指标喂给它，这就非常适合业务数据的收集，如访问次数，响应时间等统计。来一条，往statsite记一条，statsite还会帮你 算平均值，次数等基本的统计。而且，还支持写到graphite中。真是爽啊。我们的应用中包含了一些统计代码，还有一大部分指标通过订阅日志来实时统 计。


#### 然后是指标的展示（绘制曲线）


我们选用了[graphite](http://graphite.wikidot.com/)这个工具，这个工具非常棒， 它只做数据指标的绘图，而且做到极致，非常符合我的口味。它可以将各种指标，经过运算得到你想要的曲线，并且支持简单的dashboard，不过，这个 dashboard略简陋，可以考虑自己弄，将它生成的图嵌进去即可。另外一个非常重要的功能是，对你配置好的曲线，可以通过HTTP接口获得数据。这就 为后面的工作提供了极大的方便。


#### 最后是报警


nagios再适合不过了，简单，稳定，通过nrpe监控了机器上的基本指标后，大部分的报警都是通过自己写的check_graphite插件来读我们配置好的图来完成。这样，我们任何一个系统出了问题，立刻短信就来了。

记住，Measure everything&monitor everything！

link：http://blog.dccmx.com/2012/12/build-perfect-monitoring-system/


