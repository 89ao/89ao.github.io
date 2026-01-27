---
title: **Clawdbot**安装手册（qwen+iMessage）
date: 2026-1-27 8:0:00 +0800
lastUpdateTime: 2026-1-27 19:26:00 +0800
name: clawdbot install guide
author: "motorao"
layout: post
tags: 
    - AI
    - MacOS
categories: life
publish: true
subtitle: clawdbot install tutorial
---
    
# Clawdbot 安装手册

## 简介

Clawdbot 是一个功能强大的个人助手和自动化工具，能够与您的系统深度集成，执行各种任务，包括文件管理、系统命令执行、应用控制、消息处理等。

互联网众多安装文档大而全，反倒带来比较多的干扰项，因此本文以最简单的模式，先将整个clawdbot部署run起来，如有需要再进行了解后横向扩展即可。

## 系统要求

* macOS 12.0 +

* Node.js 18.0 +

## 安装步骤

### 1. 安装依赖

首先确保系统已安装 Node.js 和 npm：

```bash
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"
# Download and install Node.js:
nvm install 24


# Verify the Node.js version:
node -v # Should print "v24.13.0".
# Verify npm version:
npm -v # Should print "11.6.2".
```

### 2. 安装 Clawdbot

```bash
# 由于网络问题，首先将npm仓库指向国内镜像
npm config set registry https://registry.npmmirror.com

# 使用 npm 全局安装
npm install -g clawdbot@latest
```

### 3. 初始化配置

注册好 [https://chat.qwen.ai/](https://chat.qwen.ai/) 并登陆。

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-802e-a009-ea5b3e28538c.webp)

运行 Clawdbot 并进行初始化：

```bash
clawdbot onboard --install-daemon
```

此命令将引导您完成基本配置，包括：

* 设置 API 密钥（如需要）

* 配置消息通道

* 设置权限选项

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-80b4-9ddf-c6388b121ef2.webp)

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-805c-8eeb-f13d7b56e17a.webp)

当出现以下提示时，访问文本框中的链接，使用qwenapi的OAuth进行认证。

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-809d-b675-d2e403c2897a.webp)

channel选择iMessage

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-8056-874c-e8f5242fd85a.webp)

由于没有准备其他token，本部分所有选项都选No：

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-80a6-85d9-e33778533ec0.webp)

最后一步，启用boot-md，command-logger，session-memory三个hook，确保基础能力完整。

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-80d7-b4d5-ce96a01cb746.webp)

继续往下则为安装完成，选择“Open the Web UI”或者“Do this later”jun ke

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-80e3-8719-dcfdd9df903e.webp)

记录以上的“Web UI (with token)”。

### 4. 完成安装

浏览器中访问，将token输入红框并选择Connect，右上角**红灯转绿**为正常。

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-8010-8027-c3b696bea5a7.webp)

此时可在Chat标签中做基本测试，可以让它访问下日历、待办事项、本地文件等触发权限请求。

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-8006-bcfa-e2e949de31d9.webp)

到这一步为止，clawdbot本体部署完成，但由于macOS权限限制问题，还需要进行以下一些操作放开nodejs需要的相应权限。



## macOS权限设置

为了正常使用所有功能，需要为 Clawdbot 设置适当的权限：

### 系统权限

1. **辅助功能权限**：允许 Clawdbot 控制其他应用
    * 系统偏好设置 > 安全性与隐私 > 辅助功能
    * 添加 Terminal 或 Node 应用

1. **完全磁盘访问权限**：允许访问系统文件
    * 系统偏好设置 > 安全性与隐私 > 完全磁盘访问权限
    * 添加 Terminal 或 Node 应用

### 应用特定权限

* **日历权限**：允许访问日历事件

* **提醒事项权限**：允许管理提醒事项

* **通讯录权限**：允许访问联系人信息

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-8056-be77-dbbf588a69d9.webp)

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-800a-a84e-e93f1c02c543.webp)

### 修改配置和重启服务

当您修改了配置后，需要重启服务以使更改生效：

```bash
# 重启服务以应用新配置
clawdbot gateway restart

# 或者使用配置命令应用更改
clawdbot gateway apply-config

# 检查服务状态
clawdbot gateway status
```

如果您启用了新功能（如 iMessage 或新的模型配置），必须重启让其生效。

以上配置完成后，使用**另一个iMessage**发送消息即可发送任务命令：

**服务端：**

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-8080-bdd0-d6d1d0699176.webp)

**客户端：**

![](https://static.motorao.cn/assets/pic/2f59fe61-9db0-809b-8e53-f05305757f42.webp)

## 功能概览

### 文件系统操作

* 读取、写入和编辑文件

* 搜索文件内容

* 管理文件权限

### 应用控制

* 控制 macOS 原生应用（日历、提醒事项等）

* 通过 AppleScript 与第三方应用交互

### 网络功能

* 网页搜索和内容提取

* 浏览器自动化

* API 调用

### 消息处理

* 支持多种消息平台（Telegram、Signal 等）

* 自动化消息响应

## 故障排除

### 日志查看

```bash
# 查看服务日志
clawdbot gateway logs
```

## 更新和维护

### 更新 Clawdbot

```bash
# 更新到最新版本
npm update -g clawdbot

# 或重新安装最新版本
npm install -g clawdbot@latest

```

### 配置备份

建议定期备份配置文件，通常位于 `~/.clawdbot/` 目录下。

## 结语

Clawdbot 是一个功能强大的个人助手，通过适当配置可以极大提升工作效率。如有疑问，请参考官方文档或社区支持。
