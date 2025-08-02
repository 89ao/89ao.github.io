---
title: MacOS关盖休眠设置
date: 2025-7-23 8:0:00 +0800
lastUpdateTime: 2025-8-2 13:10:00 +0800
name: hibernatemode of macos
author: "motorao"
layout: post
tags: 
    - MacOS
categories: life
publish: true
subtitle: MacOS change hibernatemode to save battery
---
    
# 背景：

很长的一段时间以来都是使用[hammerspoon](https://www.hammerspoon.org/)做一些操作上的自定义，其中就包含了禁止休眠的功能（少装一个caffine这样的app）。

但是这几天发现合盖之后电脑放在包里，第二天早上笔记本有些发热，电池也掉到了个位数。开电脑一看，原来根本没有进入休眠模式，发热逐步积攒起来了导致的结果。



# Hammerspoon脚本

既然明确是这个原因，以后也不想手动的再做修改了，于是更新了hammerspoon的配置：

1. 在接入电源的情况下，启用caffine禁止休眠

1. 在使用电池的情况下，禁用caffine允许休眠省电降温

1. 自动检测当前电源状态并切换



代码在这里：

```lua
-- Hammerspoon 配置文件
-- 电源状态监听器 - 自动管理系统休眠策略

local powerWatcher = nil
local menuBarItem = nil
local lastPowerState = nil  -- 记录上次的电源状态

-- 显示定位提示的辅助函数
local function showPositionedAlert(message, duration)
    hs.alert.closeAll(0)
    alert.defaultStyle.atScreenEdge = 0
    local screen = hs.screen.mainScreen():frame()
    hs.alert.show(message, {x = screen.w/2, y = screen.y + screen.h * 0.2}, duration or 2)
    alert.defaultStyle.atScreenEdge = 1
end

-- 处理电源状态变化
function handlePowerChange()
    local isPluggedIn = hs.battery.isCharged() or hs.battery.isCharging()
    
    -- 只在状态真正变化时才处理
    if lastPowerState == isPluggedIn then
        return
    end
    
    lastPowerState = isPluggedIn
    
    -- 安全地设置休眠策略
    local function setCaffeinate(setting, value)
        local success, error = pcall(function()
            hs.caffeinate.set(setting, value, true)
        end)
        if not success then
            print("设置 " .. setting .. " 失败: " .. tostring(error))
        end
    end
    
    if isPluggedIn then
        -- 接入电源，禁止休眠
        setCaffeinate("displayIdle", true)
        setCaffeinate("systemIdle", true)
        
        -- 更新菜单栏图标
        if menuBarItem then
            menuBarItem:setIcon("~/.hammerspoon/icon/caffeine-on.pdf")
            menuBarItem:setTooltip("电源已连接 - 已禁止休眠")
        end
        
        showPositionedAlert("🔌 已接入电源 - 禁止休眠")
        print("Power connected - Sleep disabled")
    else
        -- 使用电池，允许休眠
        setCaffeinate("displayIdle", false)
        setCaffeinate("systemIdle", false)
        
        -- 更新菜单栏图标
        if menuBarItem then
            menuBarItem:setIcon("~/.hammerspoon/icon/caffeine-off.pdf")
            menuBarItem:setTooltip("使用电池 - 允许休眠")
        end
        
        showPositionedAlert("🔋 使用电池 - 允许休眠")
        print("On battery - Sleep enabled")
    end
end

-- 初始化电源监听器
function initPowerWatcher()
    -- 停止现有的监听器
    if powerWatcher then
        powerWatcher:stop()
        powerWatcher = nil
    end
    
    -- 重置状态
    lastPowerState = nil
    
    -- 创建菜单栏项目
    if not menuBarItem then
        menuBarItem = hs.menubar.new()
        if menuBarItem then
            menuBarItem:setClickCallback(function()
                local isPluggedIn = hs.battery.isCharged() or hs.battery.isCharging()
                local message = isPluggedIn and "🔌 当前状态：电源已连接 - 已禁止休眠" or "🔋 当前状态：使用电池 - 允许休眠"
                showPositionedAlert(message)
            end)
        else
            print("创建菜单栏项目失败")
        end
    end
    
    -- 创建新的电源监听器
    powerWatcher = hs.battery.watcher.new(handlePowerChange)
    if powerWatcher then
        powerWatcher:start()
        -- 初次启动时静默设置状态（不显示通知）
        local isPluggedIn = hs.battery.isCharged() or hs.battery.isCharging()
        lastPowerState = isPluggedIn
        
        -- 静默设置初始状态
        local function setCaffeinate(setting, value)
            pcall(function()
                hs.caffeinate.set(setting, value, true)
            end)
        end
        
        if isPluggedIn then
            setCaffeinate("displayIdle", true)
            setCaffeinate("systemIdle", true)
            if menuBarItem then
                menuBarItem:setIcon("~/.hammerspoon/icon/caffeine-on.pdf")
                menuBarItem:setTooltip("电源已连接 - 已禁止休眠")
            end
            print("Power connected - Sleep disabled (初始状态)")
        else
            setCaffeinate("displayIdle", false)
            setCaffeinate("systemIdle", false)
            if menuBarItem then
                menuBarItem:setIcon("~/.hammerspoon/icon/caffeine-off.pdf")
                menuBarItem:setTooltip("使用电池 - 允许休眠")
            end
            print("On battery - Sleep enabled (初始状态)")
        end
        
        print("Power monitor initialized")
    else
        print("创建电源监听器失败")
    end
end

-- 清理函数
function cleanupPowerWatcher()
    if powerWatcher then
        powerWatcher:stop()
        powerWatcher = nil
    end
    
    if menuBarItem then
        menuBarItem:delete()
        menuBarItem = nil
    end
    
    -- 恢复默认状态（允许休眠）
    pcall(function()
        hs.caffeinate.set("displayIdle", false, true)
        hs.caffeinate.set("systemIdle", false, true)
    end)
    
    print("Power monitor cleaned up")
end

-- 启动电源监听
initPowerWatcher()

-- 显示启动完成提示
showPositionedAlert("Hammerspoon Realoaded")
print("Hammerspoon config loaded")
```



配置在这里：[update caffine by power state](https://github.com/89ao/.hammerspoon/commit/1b70ad584619dbe0422372e7af2ebacb98230c71)



# 如果想对系统默认的休眠模式进行修改



```shell
# pmset -g custom
Battery Power:
 Sleep On Power Button 1
 lowpowermode         0
 standby              1
 ttyskeepawake        1
 hibernatemode        3
 powernap             1
 hibernatefile        /var/vm/sleepimage
 displaysleep         2
 womp                 0
 networkoversleep     0
 sleep                1
 lessbright           1
 tcpkeepalive         1
 disksleep            10
AC Power:
 Sleep On Power Button 1
 lowpowermode         0
 standby              1
 ttyskeepawake        1
 hibernatemode        3
 powernap             1
 hibernatefile        /var/vm/sleepimage
 displaysleep         10
 womp                 1
 networkoversleep     0
 sleep                1
 tcpkeepalive         1
 disksleep            10
```

## 说明如下：

* macOS 的睡眠有两种状态
    * 不断电，数据存储在内存中，可以快速恢复。我们称这种状态为睡眠（Sleep）
    * 断电，数据存储在硬盘中，恢复得较慢。我们称这种状态为休眠（Hibernate/Stand-by）

* 睡眠和休眠可以组合出三种模式，由 `hibernatemode` 控制
    * `hibernatemode = 0`，这是桌面设备的默认值。系统只睡眠，不休眠，不将数据存储在硬盘中。
    * `hibernatemode = 3`，这是移动设备的默认值。系统默认睡眠，在一定时间后或电量低于阈值将数据存储在硬盘中，而后休眠。这是所谓的安全睡眠（Safe-Sleep）。
    * `hibernatemode = 25`。只休眠，不睡眠。



可以通过`sudo pmset -b hibernatemode 3`（for Battery），或者`sudo pmset -c hibernatemode 3`（for AC Power）进行修改


