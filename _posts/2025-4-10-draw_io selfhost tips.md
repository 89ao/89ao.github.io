---
title: 自建drawio记录
date: 2025-4-10 8:0:00 +0800
lastUpdateTime: 2025-5-13 19:12:00 +0800
name: draw_io selfhost tips
author: "motorao"
layout: post
tags: 
    - 优化
    - 容器
categories: life
publish: true
subtitle: Draw.io self-hosted tips
---
    
 

> [Draw.io](http://draw.io/) 是一款强大的开源流程图和图表绘制工具，支持在线使用和本地部署，广泛用于创建各种类型的技术和业务图表。自从挺多服务都开始本地部署了之后，就更倾向于把服务控制在自己手上，因此看了下文档，Drawio还是比较容易本地部署的，只是在访问的时候，由于带宽的原因会有一些大元素加载的比较慢，需要用cos加速一下。

# 配置

首先看docker-compose.yaml

```docker
services:
  drawio:
    image: docker.cnb.cool/motorao/hub:drawio
    container_name: drawio
    restart: always
    user: root
    ports:
        - "38006:8080"
    environment:
      CITY: SHANGHAI
      STATE: SHANGHAI
      COUNTRY_CODE: CN
    volumes:
         - ./drawiojs/PreConfig.js:/usr/local/tomcat/webapps/draw/js/PreConfig.js
```

# 优化：

由于在客户端打开的时候，会因为几个json文件太大导致打开的太慢，因此将整个/js/的文件迁移到cos桶中，下载的速度由30s→3s。（cos开启防盗链避免流量浪费）

然后在nginx里对整个js目录做转发：

```bash
    location ^~ /js/ {
        return 301 https://static.motorao.cn$request_uri;
    }
```

同时，为了避免跨站的阻拦，需要在PreConfig.js中更新配置（最好是传到cos里覆盖默认配置可以做到免配置拉起）：

```javascript
(function() {
  try {
            var s = document.createElement('meta');
            s.setAttribute('content', 'default-src \'self\'; script-src \'self\' https://storage.googleapis.com https://apis.google.com https://docs.google.com https://code.jquery.com https://static.motorao.cn \'unsafe-inline\'; connect-src \'self\' https://*.dropboxapi.com https://api.trello.com https://api.github.com https://raw.githubusercontent.com https://*.googleapis.com https://*.googleusercontent.com https://graph.microsoft.com https://*.1drv.com https://*.sharepoint.com https://gitlab.com https://*.google.com https://fonts.gstatic.com https://fonts.googleapis.com; img-src * data:; media-src * data:; font-src * about:; style-src \'self\' \'unsafe-inline\' https://fonts.googleapis.com; frame-src \'self\' https://*.google.com;');
            s.setAttribute('http-equiv', 'Content-Security-Policy');
            var t = document.getElementsByTagName('meta')[0];
      t.parentNode.insertBefore(s, t);
  } catch (e) {} // ignore
})();
window.DRAWIO_BASE_URL = 'https://draw.motorao.cn';
window.DRAWIO_VIEWER_URL = 'https://draw.motorao.cn/js/viewer.min.js';
window.DRAWIO_LIGHTBOX_URL = 'https://example:8716';
window.DRAW_MATH_URL = 'math/es5';
//window.DRAWIO_CONFIG = null;
window.DRAWIO_CONFIG = {"defaultVertexStyle":{"fontSize":"14","strokeWidth":"1.5"},"defaultEdgeStyle":{"rounded":"1","fontSize":"14","strokeWidth":"1.5"}};
urlParams['sync'] = 'manual'; //Disable Real-Time
urlParams['db'] = '0'; //dropbox
urlParams['gh'] = '0'; //github
urlParams['tr'] = '0'; //trello
urlParams['gapi'] = '0'; //Google Drive
urlParams['od'] = '0'; //OneDrive
urlParams['gl'] = '0'; //Gitlab
urlParams['lang'] = 'zh';
urlParams['offline'] = '1'; //取消从模版创建
```


