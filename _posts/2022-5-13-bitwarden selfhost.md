---
title: 享受云计算时代的红利-自建密码管理仓库bitwarden
date: 2022-5-13 8:0:00 +0800
lastUpdateTime: 2024-12-14 10:56:00 +0800
name: bitwarden selfhost
author: "motorao"
layout: post
tags: 
    - 技术
categories: tech
publish: true
subtitle: selfhosted bitwarden 
---
    
## 前言

互联网大爆炸时代，每个人在不同的应用系统中都有不同的身份认证。
与日俱增的应用，带来了铺天盖地的密码，而他们的复杂度又在安全性和易用性的互相较量中螺旋上升。
为了减少管理密码过程中带来的精力损耗，各大操作系统或浏览器也提供了种种密码管理工具。然而由其覆盖范围的有限，及各个系统之间的天然割裂，还是会带来一些不便。
从我个人的观点出发，我认为一个好的解决方案应该是这样的：

1. **一个程序只做一件事，并且做好**：浏览器就只做浏览器，密码管理的工作交给专业的系统去管；

1. **与其记住所有密码，不如忘掉密码：与其在创造密码**，**记住密码**和**找回密码**过程中浪费精力，还不如干脆忘掉密码，扔给系统去管理以释放自己。

## 痛点

笔者曾经的使用经历如下：

1. 最开始尝试使用过1password等服务，但可能彼时密码管理服务尚不是很成熟，不能满足我的需求（跨系统多终端及同步体验）。---而后来的1password泄露事件也算侥幸逃过一劫。

1. 退而求其次采用了离线管理的方式，通过iCloud+坚果云进行密码库文件多设备同步。

1. 后来apple出了keychain，其系统匹配度，流程完整性非常完善，正好几乎所有设备都是apple生态圈，于是用keychain管理了很久，倒也没有什么跨设备的问题。

1. 随着Chrome用的越来越多，问题来了：keychain不支持chrome，chrome的密码无法导入keychain，导致密码仍然需要分开两处管理，那么换个终端比如说手机ipad的时候，混乱了多次最后只好给两个不同的浏览器约定不同的分工（比如工作类和视频类在chrome，学习类和娱乐类在Safari），但是这样仍然无法避免登陆之前总是要多想一下“在chrome还是Safari？”的卡顿。

梳理过去使用密码管理过程中遇到的**痛点转换成需求**，列表如下：

1. 安全的密码保护系统（加密方式，数据存取方式，两步认证）

1. 多平台，多系统，数据同步能力（macOS，iOS，windows，Linux，maybe android）；

1. 良好的密码管理策略（新密码自动储存，目标域名密码自动输入，同domain下的二级域名统一管理）；

1. 便捷的使用流程（新系统部署简单，使用顺畅）

1. 支持本地部署（避免供应商跑路，拖库撞库-- lastpass曾出现过入侵事件）

1. 开放的数据导入导出支持（easy in easy out，避免绑架）

## 解决方案

偶然在[v站](http://v2ex.com/)看到bitwarden，拿来试了试的确挺符合需求的，在此推荐一下：

### intro

Bitwarden offers the easiest and safest way for teams and individuals to store and share sensitive data from any device.  -- 来自官网

[https://bitwarden.com](https://bitwarden.com/)

![](https://static.motorao.cn/assets/pic/15c66a14-2144-8082-8cb9-c3c7cab47533.webp)

### 开源

无需多言

### 安全

支持端到端AES-256加密。
支持进行密码安全检测（被公开的密码，重复的密码，弱密码，被泄露的密码等）

![](https://static.motorao.cn/assets/pic/15c66a14-2144-80cd-95e5-e1d2ccd82d06.webp)

### 全平台支持

BitWarden 支持 Windows 、MacOS 和 Linux 三大 pc操作系统和 Android，iOS 两大手机OS， Chrome，Firefox，Opera，Edge 等近十款浏览器的扩展，甚至还有命令行管理模式，可以说是全平台覆盖了。

![](https://static.motorao.cn/assets/pic/15c66a14-2144-801a-bb6d-ffae45d85a0a.webp)

### 本地部署

支持本地部署（及容器化部署）

### 全面的数据导入导出支持

可以查看一下bitwarden支持的密码格式：

![](https://static.motorao.cn/assets/pic/15c66a14-2144-8013-9636-d8fce94186eb.webp)

## 后记

经过一段时间的使用，的确在便捷，安全，效率上达到了一个很好的平衡。

![](https://static.motorao.cn/assets/pic/15c66a14-2144-8010-9767-d671da200418.webp)

美中不足就是服务器在海外同步起来稍微有点慢，有空给他整成本地部署再分享一下。

> ps. 腾讯云有提供打包好的开源应用，欢迎使用：bitwarden_rs  --- 已失效
