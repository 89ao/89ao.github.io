---
author: pandao
comments: false
date: 2011-09-26 07:56:15+00:00
layout: post
slug: failed-to-get-i915-symbols
title: failed to get i915 symbols, graphics turbo disabled error on boot
thread: 77
categories:
- linux
---

從終端機下指令 （最好加 sudo 以免因權限問題失敗）
sudo echo “blacklist intel_ips” >> /etc/modprobe.d/blacklist.conf
sudo echo -e “i915/nintel_ips” >> /etc/modules

註:
1. echo- 顯示一行文本
2. -e 允許對下面列出的加反斜線轉義的字符進行解釋.
3. >> 附加在後面這個檔案的最後一行

資料來源
echo - display a line of text
add i915 and intel_ips to /etc/modules

從終端機下指令
sudo gedit /etc/modules
加上
i915
intel_ips
分列兩行在該檔案後面

其它英文是說明文字
