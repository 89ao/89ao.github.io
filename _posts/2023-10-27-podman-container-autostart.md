---
title: podman容器自启
date: 2023-10-27 8:0:00 +0800
lastUpdateTime: 2024-12-14 11:23:00 +0800
name: podman-container-autostart
author: "motorao"
layout: post
tags: 
    - 技术
    - 容器
categories: tech
subtitle: Podman Container autostart
---
    
> 背景：
今天发现云主机 oom 重启之后podman 的容器没有自动运行，大概看了一下，是因为 Podman 不试用 Daemon 守护进城，所以 podman 启动后不自动启动容器。
这里试用 systemd 进行自启动管理。

## 方案

可以使用`podman generate systemd`生成并管理

### 生成 systemd 文件

```shell
# podman generate systemd --restart-policy=always -t 1 --name -f vaultwarden
WARN[0000] Container ad911cfea63127a434d135106d89ccbe5158d169a5f787596cbc93968d84e676 has restart policy "always" which can lead to issues on shutdown: consider recreating the container without a restart policy and use systemd's restart mechanism instead
/root/container-vaultwarden.service
```

这里有提示使用`restart=always`可能会导致 pod 关闭失败。

### 配置 systemd

将文件复制到`/etc/systemd/system/`目录，并make enable：

```shell
# mv /root/container-vaultwarden.service /etc/systemd/system/
# systemctl daemon-reload
# systemctl enable container-vaultwarden
Created symlink /etc/systemd/system/default.target.wants/container-vaultwarden.service → /etc/systemd/system/container-vaultwarden.service.
```

至此，容器重启后的 pod 会通过 systemd自动拉起并运行。
