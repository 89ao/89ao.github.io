---
author: pandao
comments: false
date: 2013-07-31 23:21:24+00:00
layout: post
slug: monsterwm-on-the-linux-desktop-is-minimized-and-customized
title: MonsterWM兼谈 Linux 桌面最小化及定制
thread: 229
categories:
- linux
---

name: inverse
    layout: true
    class: center, middle, inverse
    ---
    # MonsterWM
    
    -- 兼谈 Linux 桌面最小化及定制
    
    ~toy
    
    2013.8.10
    ---
    layout: false
    ## 个人简介
    
    - 网名：Toy
    
    - 真名：徐小东
    
    - 2005：GNU/Linux 用户
    
    - 2006：创办 Linuxtoy.org
    
    - 2008：Gentoo 用户
    
    - 2013：在乐看网工作
    ---
    layout: false
    ## 三个使用阶段
    
    - 传统桌面：开箱即用/不够灵活
    
    ![gnome](img/gnome.png)
    ![kde](img/kde.png)
    ![xfce](img/xfce.png)
    
    - 轻量级窗口管理器：轻快灵活/多需配置
    
    ![fluxbox](img/fluxbox.png)
    ![openbox](img/openbox.png)
    
    - 动态平铺式窗口管理器：做好本职/重塑习惯
    
    ![awesome](img/awesome.png)
    ![i3](img/i3.png)
    ![dwm](img/dwm.png)
    ---
    layout: false
    ## 窗口管理的方法学
    
    - 堆栈式：窗口重叠/内容遮挡/鼠标操纵
    
    [![stack](img/stack-thumb.png)](img/stack.png)
    ---
    layout: false
    ## 窗口管理的方法学
    
    - 平铺式：一目了然/省心省力/键盘操控
    
    [![tile](img/tile-thumb.png)](img/tile.png)
    ---
    layout: false
    ## 终极选择
    
    - MonsterWM + Bar + Dmenu + Feh + Scripts
    
    [![monsterwm](img/monsterwm-thumb.png)](img/monsterwm.png)
    ---
    layout: false
    ## 选择理由
    
    - 极度轻量级
    
    - 动态平铺管理窗口
    
    - 无需鼠标，全键盘控制
    
    - 多种预设布局
    
      - 平铺 Tile
    
      - 底栈 Bottom stack
    
      - 网格 Grid
    
      - 全屏 Monocle
    
      - 浮动 Float
    
    - 多显示器支持
    ---
    layout: false
    ## 桌面组件
    
    - 窗口管理器 - MonsterWM
    
      - 管理窗口位置
      
      - 调整窗口大小 
    
      - 窗口边框及标题栏
    
    - 任务栏 - Bar + Scripts
    
      - 启动应用
    
      - 切换桌面
    
      - 系统托盘
    
      - 状态信息
    
    - 文件管理器 - URxvt
    
    - 会话管理及其他
    ---
    layout: false
    ## MonsterWM 安装
    
    - 准备依赖：libX11
    
    ```bash
    # apt-get install libx11-dev # Debian/Ubuntu
    # yum install libX11-devel   # Fedora
    # pacman -S libx11           # Arch Linux
    # emerge libX11              # Gentoo
    ```
    
    - 获取源码
    
    ```bash
    % git clone https://github.com/c00kiemon5ter/monsterwm.git
    ```
    
    - 编辑配置
    
    ```bash
    % cd monsterwm
    % cp config.def.h config.h
    % vim config.h
    ```
    
    - 编译安装
    
    ```bash
    % make
    # make install
    ```
    ---
    layout: false
    ## MonsterWM 配置
    
    - 修饰键
    
    ```c
    #define MOD1            Mod1Mask    /* ALT key */
    #define MOD4            Mod4Mask    /* Super/Windows key */
    #define CONTROL         ControlMask /* Control key */
    #define SHIFT           ShiftMask   /* Shift key */
    
    ```
    
    - 一般设置
    
    ```c
    #define MASTER_SIZE     0.52
    #define SHOW_PANEL      True      /* show panel by default on exec */
    #define TOP_PANEL       True      /* False means panel is on bottom */
    #define PANEL_HEIGHT    13        /* 0 for no space for panel, thus no panel */
    #define DEFAULT_MODE    BSTACK    /* initial layout/mode: TILE MONOCLE BSTACK GRID FLOAT */
    #define BORDER_WIDTH    2         /* window border width */
    #define FOCUS           "#956d9d" /* focused window border color    */
    #define UNFOCUS         "#222222" /* unfocused window border color  */
    #define INFOCUS         "#9c3885" /* focused window border color on unfocused monitor */
    #define MINWSZ          50        /* minimum window size in pixels  */
    #define DESKTOPS        4         /* number of desktops - edit DESKTOPCHANGE keys to suit */
    ```
    
    - 常用应用
    
    ```c
    static const char *termcmd[] = { "urxvtc",   NULL };
    ```
    ---
    layout: false
    ## MonsterWM 配置
    
    - 预设桌面
    
    ```c
    static const AppRule rules[] = { \
        /*  class     desktop  follow  float */
        { "Dwb",        -1,    True,   False },
        { "Firefox",     1,    True,   False },
        { "Gimp",        2,    True,   True },
    };
    
    ```
    
    _Tip_：`xprop` 可获得应用的 class 名。
    
    - 习惯按键
    
    ```c
    static Key keys[] = {
    /* modifier          key            function           argument */
    {  MOD4,             XK_b,          togglepanel,       {NULL}},
    {  MOD4,             XK_BackSpace,  focusurgent,       {NULL}},
    {  MOD1|SHIFT,       XK_c,          killclient,        {NULL}},
    {  MOD1,             XK_j,          next_win,          {NULL}},
    {  MOD1,             XK_k,          prev_win,          {NULL}},
    {  MOD1,             XK_h,          resize_master,     {.i = -10}}, /* decrease size in px */
    {  MOD1,             XK_l,          resize_master,     {.i = +10}}, /* increase size in px */
    {  MOD1,             XK_o,          resize_stack,      {.i = -10}}, /* shrink   size in px */
    {  MOD1,             XK_p,          resize_stack,      {.i = +10}}, /* grow     size in px */
    {  MOD1|CONTROL,     XK_h,          rotate,            {.i = -1}},
    ```
    ---
    layout: false
    ## 最佳拍档 
    
    - Bar：状态栏
    
    _安装_：
    
    ```bash
    % git clone https://github.com/LemonBoy/bar.git
    % cd bar
    % cp config.def.h config.h
    % vim config.h
    % make
    # make install
    ```
    
    _配置_：
    
    ```c
    #define BAR_HEIGHT  13
    #define BAR_UNDERLINE 1
    #define BAR_UNDERLINE_HEIGHT 2
    #define BAR_BOTTOM 0
    #define BAR_FONT       "-*-ohsnap.icons-medium-r-*-*-11-*-*-*-*-*-*-*","-*-ohsnap-medium-r-*-*-11-*-*-*-*-*-*-*"
    #define COLOR0  0x1A1A1A /* background */
    #define COLOR1  0xA9A9A9 /* foreground */
    #define COLOR2  0x222222
    #define COLOR3  0x8E5C4E
    #define COLOR4  0x6C7E55
    #define COLOR5  0xB89F63
    #define COLOR6  0x7FB8D8
    ```
    ---
    layout: false
    ## 最佳拍档 
    
    - Mobar：启动脚本
    
    ```bash
    #!/bin/bash
    
    ff="/tmp/monsterwm.fifo"
    [[ -p $ff ]] || mkfifo -m 600 "$ff"
    
    # desktop names
    ds=("º dev" "© www" "¦ gfx" "Ï etc")
    
    # layout names
    ms=("þ" "û" "ü" "ú" "ý")
    
    while read -t 1 -r wmout || true; do
      if [[ $wmout =~ ^(([[:digit:]]+:)+[[:digit:]]+ ?)+$ ]]; then
        read -ra desktops <<< "$wmout" && unset r
        for desktop in "${desktops[@]}"; do
          IFS=':' read -r d w m c u <<< "$desktop"
          ((c)) && fg="\\f7" i="${ms[$m]}" || fg="\\f9"
          r+="$fg${ds[$d]} \\f9 "
        done
        r="${r%*}"
      fi
      printf "\\\l%s\\\r%s\n" "$r\\f4$i" "\\f8ê \\f3$(nowplaying) \\f8Ñ \\f4$(cpu) \\f8Æ \\f4$(mem) \\f8Ý \\f7$(net down) \\f8Ü \\f7$(net) \\f8­ \\f7$(wifi) \\f8Ì \\f5$(gmail) \\f8ð \\f5$(batter) \\f8í \\f5$(volume) \\f8· \\f1$(date +"%a, %b %d \\f8/ \\f1%R")"
    done < "$ff" | bar &
    
    # pass output to pipe and print to stdout
    monsterwm > "$ff"
    ```
    ---
    layout: false
    ## 最佳拍档 
    
    - Scripts：cpu、mem、net、wifi、bat、gmail、volume、nowplaying
    
    ```ruby
    #!/usr/bin/env ruby
    #
    # name     : cpu, cpu information for mobar
    # author   : Xu Xiaodong <xxdlhy@gmail.com>
    # license  : GPL
    # created  : 2012 Jul 31
    # modified : 2012 Jul 31
    #
    
    def total
      stat_file = '/proc/stat'
      File.open(stat_file) do |f|
        values = f.readline.split(/\s+/)[1 .. 4].map(&:to_i)
        idle = values.last
        total = values.inject(0, &:+)
        return [idle, total]
      end
    end
    
    prev_idle, prev_total = total
    sleep 0.5
    cur_idle, cur_total = total
    cpu = (((cur_total - prev_total) - (cur_idle - prev_idle)).to_f / (cur_total - prev_total).to_f * 100).to_i
    
    puts "#{cpu}%"
    ```
    ---
    layout: false
    ## 如何启动
    
    - ~/.xinitrc
    
    ```bash
    #!/bin/sh
    #
    # author   : Xu Xiaodong <xxdlhy@gmail.com>
    # modified : 2013 Jul 23
    #
    
    #-- font --#
    xset +fp /usr/share/fonts/ohsnap
    xset fp rehash
    
    #-- app --#
    xmodmap ~/.xmodmaprc &      # swap Caps_Lock and Control_L
    urxvtd -q -f -o             # urxvt daemon
    eval $(cat ~/.fehbg)        # set wallpaper
    urxvtc -e sh -c "tmuxen" &  # start tmux
    
    #-- wm --#
    exec mobar
    ```
    
    - ~/.xsession
    
    _Tip_：如果你有显示管理器，那么需用此文件代替 `.xinitrc`。
    ---
    layout: false
    ## MonsterWM 用法
    
    - 打开终端：Alt + Shift + Enter
    
    - 启动应用：Super + v (dmenu)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 切换桌面 (Tag)：Alt + F1 .. F4、Alt + Tab
    
    ![tag](img/tag.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 窗口管理之平铺：Alt + Shift + t
    
    [![tile-stack](img/tile-stack-thumb.png)](img/tile-stack.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 窗口管理之底栈：Alt + Shift + b
    
    [![bottom-stack](img/bottom-stack-thumb.png)](img/bottom-stack.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 窗口管理之网格：Alt + Shift + g
    
    [![grid](img/grid-thumb.png)](img/grid.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 窗口管理之全屏：Alt + Shift + m
    
    [![monocle](img/monocle-thumb.png)](img/monocle.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 窗口管理之浮动：Alt + Shift + f
    
    [![float](img/float-thumb.png)](img/float.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 切换窗口：Alt + j、Alt + k
    
    [![switch](img/switch-thumb.png)](img/switch.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 交换窗口：Alt + Enter
    
    [![swap](img/swap-thumb.png)](img/swap.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 窗口移动之平铺：Alt + Shift + j、Alt + Shift + k
    
    [![move](img/move-thumb.png)](img/move.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 窗口移动之浮动：Super + h, j, k, l
    
    [![float](img/move-float-thumb.png)](img/move-float.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 窗口移动之桌面：Alt + Shift + F1 .. F4
    
    [![desk](img/move-desk-thumb.png)](img/move-desk.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 调整窗口之平铺：Alt + l、Alt + h、Alt + o、Alt + p
    
    [![size](img/size-tile-thumb.png)](img/size-tile.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 调整窗口之浮动：Super + Shift + h, j, k, l
    
    [![size](img/size-float-thumb.png)](img/size-float.png)
    ---
    layout: false
    ## MonsterWM 用法
    
    - 关闭窗口：Alt + Shift + c
    
    [![gui](img/gui-thumb.png)](img/gui.png)
    ---
    layout: false
    ## 资源链接
    
    - MonsterWM 源码：https://github.com/c00kiemon5ter/monsterwm
    
    - Bar 源码：https://github.com/LemonBoy/bar
    
    - Dmenu 官网：http://tools.suckless.org/dmenu
    
    - Feh 官网：http://feh.finalrewind.org
    
    - 各种脚本：https://github.com/xuxiaodong/bin
    
    - 讨论：https://bbs.archlinux.org/viewtopic.php?id=132122
    
    - 幻灯源码、所用配置及脚本：https://github.com/xuxiaodong/mwm-slide
    ---
    template: inverse
    
    ## Q & A 
    ---
    template: inverse
    
    ## 谢谢大家！
    
