---
author: pandao
comments: false
date: 2012-12-12 11:05:38+00:00
layout: post
slug: vmware-vsphere-faq-summary-ii
title: Vmware vSphere常见问题汇总二
thread: 177
categories:
- Virtualization
---

**1****、启用客户机操作系统和远程控制台之间的复制和粘贴操作**


解决方法：要在客户机操作系统和远程控制台之间进行复制和粘贴，必须使用 vSphere Client 启用复制和粘贴操作。




步骤




a、使用 vSphere Client 登录到 vCenter Server 系统并选择虚拟机。




b、在摘要选项卡中，单击编辑设置。




c、选择选项 > 高级 > 常规，然后单击配置参数。




d、单击添加行，并在“名称”和“值”列中键入以下值。




名称值




isolation.tools.copy.disable false




isolation.tools.paste.disable false




注意这些选项将替代在客户机操作系统的 VMware Tools 控制面板中做出的任何设置。




e、单击确定以关闭“配置参数”对话框，然后再次单击确定以关闭“虚拟机属性”对话框。




f、重新启动虚拟机。







**2****、****sco****系统迁移过去之后找不到启动列表**




解决方法：目前解决方法：使用软驱制作应急盘，通过应急盘来找到启动列表，如果不行的话，只能使用，现成的虚拟镜像导入vmware中，但是这种方法，要自己设置与自己相关的应用。










**3****、****linux****做迁移时手动添加的逻辑分区（****LVM****卷），迁移过去之后找不到这些分区**




解决方法：：给虚拟机额外添加硬盘后融合，然后将数据重新拷入加入的硬盘中。







**4****、安装****esxi****的时候找不到万兆网卡**




解决方法：解决方法：安装各个厂商OEM的esxi版本。







**5****、迁移时提示****vss****原卷不能克隆**




解决方法：解决方法：查看是否有额外的设备插在服务器上，如usb设备。







**6****、****Windows****迁移之后，配置网卡的时候，会提示“****IP****已经被分配给其他的适配器”**




解决方法：打开命令行窗口（运行cmd），输入：
（1）、set DEVMGR_SHOW_NONPRESENT_DEVICES=1




（2）、devmgmt.msc




在弹出的“设备管理器”窗口。选择“查看（V）”---“显示隐藏的设备（W）”，然后展开“网络适配器”子项，可以看到一些透明图标显示的网卡信息，这些信息是源服务器的物理网卡信息。然后选择透明的设备卸载，RAS同步适配器为系统正常设备，不需要将其卸载。







**7****、****Asianux3.0****迁移之后不能显示图形化界面**




解决方法：解决方法：cp /etc/X11/xorg.conf /etc/X11/xorg.conf.bak




          vi /etc/X11/xorg.conf




将xorg.conf文件中的selection “Devices”字段中Driver对应的值修改为“vmware”即可，修改完成后通过startx启动图形化界面。




** **




**8****、迁移域控主机后发生当虚拟机开启后，物理机就断网**




解决方法：单播和多播的问题







**9****、在****VC****中虚拟机的鼠标全屏之后，不能控制整个屏幕**




解决方法：当时安装的是esxi 4.1，将esxi4.1升级到esxi4.1upd01 ，同时要将VC client也升级到对应的版本。







**10****、迁移过去的****win2003****的系统，隔段时间之后会蓝屏或重启**




解决方法：查看系统日志，有可能是杀毒软件的原因，将杀毒软件卸载重装。




                                           




**11****、使用****FT****功能需同时具备以下条件**




解决方法：1 所有ESX必须为4.0以上，Build版本相同，以及在同一个HA Cluster中




2 服务器的CPU要求是同一系列(并且要求是AMD Barcelona+, Intel Penryn+的CPU)




3 BIOS中要启用VT及禁用Hyperthreading（超线程）,最好同时禁用电源管理




4 每个VM只能分配1颗vCPU




5 要有专门的千兆网络负责FT




6 VM要放在共享存储上




7 VM的配置文件必须为版本7




8 Guest OS不要启用Paravirtualized




9 启用FT的VM不支持自动DRS




10 启用FT的VM不支持Snapshot




11 启用FT的VM不支持 MS Cluster




12 启用FT的VM不支持物理RDM Mapping




13 启用FT的VM的虚拟CD-ROM最好断开




14 启用FT的VM不支持NPIV (N-Port ID Virtualization)




15 启用FT的VM不支持Device HotAdd/HotPlug




大型虚拟机可能会阻止使用容错




如果虚拟机太大（大于 15GB）或内存的变化速率大于 VMotion 通过网络进行复制的速率，




则启用容错或使用VMotion 迁移正在运行的容错虚拟机时可能会失败。







**12****、****如何确认克隆后的系统SID是否更新****
**解决方法：Windows2003/2008 、windows 7可使用本地账户登录系统，输入“whoami /user”查看Windows xp没有whoami命令，可通过注册表查看







**13****、****vSphere****所需要开放的端口**




解决方法：**80**  vCenter Server需要端口80用于直接HTTP连接。端口80会将请求重定向到HTTPS端口 443。如果意外使用了http://server而不是https://server，此端口将非常有用。




**389**  此端口在vCenter Server的本地和所有远程实例上必须处于打开状态。这是vCenter Server组的目录服务的LDAP端口号。vCenter Server系统需要绑定端口389，即使没有将此 vCenter Server实例加入到




链接模式组。如果此端口上正在运行另一服务，则最好移除该服务，或将其端口更改为其他端口。可以在从1025到65535的任一端口上运行LDAP服务。如果此实例充当Microsoft Windows活动目录，请将端口号从389 、更改为从 1025 到 65535 的任一可用端口。




**443**  vCenter Server系统用于侦听来自vSphere Client的连接的默认端口。要使vCenter Server从vSphere Client接收数据，请在防火墙中打开443端口。vCenter Server系统还使用端口443侦听从vSphere Web Access Client和其他SDK客户端传输的数据。如果对HTTPS使用另一个端口号，则登录vCenter Server系统时必须使用<ip-address>:<port>。




**636 ** 对于vCenter链接模式，这是本地实例的 SSL端口。如果此端口上正在运行另一服务，则最好移除该服务，或将其端口更改为其他端口。可以在从1025到65535的任一端口上运行 SSL服务。




**902**  vCenter Server系统用于将数据发送到受管主机的默认端口。受管主机也会通过UDP端口902定期向vCenter Server系统发送检测信号。服务器和主机之间或各个主机之间的防火墙不得阻止此端口。




**902/903**  不得在vSphere Client和主机之间阻塞端口902和903。这些端口由vSphere Client 使用以显示虚拟机控制台。




**8080**  Web服务HTTP。用于VMware VirtualCenter Management Webservices。




**8443**  Web服务HTTPS。用于VMware VirtualCenter Management Webservices。




**60099**  Web服务更改服务通知端口




如果希望vCenter Serve 系统使用不同的端口接收vSphere Client数据，请参见《VMware vSphere 数据中心管理指南







**14****、虚拟机文件有哪些**




解决方法：




.vmx         _vmname_.vmx     虚拟机配置文件




.vmxf        _vmname_.vmxf    其他虚拟机配置文件




.vmdk        _vmname_.vmdk    虚拟磁盘特性




-flat.vmdk  _vmname_-flat.vmdk 预分配虚拟磁盘




.nvram       _vmname_.nvram 或 nvram 虚拟机 BIOS




.vmsd        _vmname_.vmsd 虚拟机快照




.vmsn        _vmname_.vmsn 虚拟机快照数据文件




.vswp        _vmname_.vswp 虚拟机交换文件




.vmss        _vmname_.vmss 虚拟机挂起文件




.log         vmware.log 当前虚拟机日志文件




-#.log       vmware-#.log（其中 # 表示从 1 开始的编号） 旧的虚拟机日志条目




** **




**15****、如何更改vSphere Center****的生成日志**




解决方法：




修改“vpxd.cfg”文件，然后添加如下内容：




 <directory>D:\VMware\Logs</directory>




 调整日志文件的大小：




 <maxFileSize>10485760</maxFileSize>




 <maxFileNum>10</maxFileNum>




保存之后，重启vCenter Server之后，即可生效







**16****、windows****迁移必须在迁移机上开启的服务**




解决方法：




需要注意5个服务不能被禁用




1）windows installer




2）volume shadow




3）TCP/IP netBIOS




4）server




5）workstation




如果 Converter Standalone 连接远程 Windows XP 计算机失败，并发出 bad username/password 的错误消息，




请确保 Windows 防火墙没有阻止文件和打印机共享。步骤




1 选择开始 > 设置 > 控制面板 > 管理工具 > 本地安全策略。




2 在左侧的安全设置列表中，选择本地策略 > 安全选项。




VMware vCenter Converter Standalone 用户指南




3 在右侧的策略列表中，选择网络访问：本地帐户的共享和安全模式。




4 确保选中经典 - 本地用户以自己的身份验证。







Windows Server 2008（确保启用了 Computer Browser Windows Service）




Windows XP(需要打开简单文件共享，启用文件和打印机共享)







**17****、****Linux****迁移注意事项**




1）关闭防火墙（service \etc\init.d\iptables stop）




2）SSH 必须打开(sshd start)




3）迁移时需要在help address时为虚拟机设置一个IP地址




redflag 迁移之后没有图形化界面，通过Xconfigurator来重新配置。




redhat 迁移之后没有图形化界面，通过system-config-display来重新配置。




4）迁移后的系统不带IP，需要手动设置




5）数据库或域需要关闭




6）建议冷迁







**18****、****ESXi****不能解析主机名**




解决方法：




1） Login to ESXi host




2） vi /etc/hosts




3） Key in every ESXi host in Cluster as the following format




   IP Address            ESXi hostname




   192.168.10.10      esx01




   192.168.10.11      esx02




    ... ...




   192.168.10.9        vCenter01




4） Repeat all the above editing in all ESXi hosts




5）Login in to vCenter




6）Edit /Windows/System32/drive/etc/hosts







** **




********


**19****、****SCO****迁移后添加网卡不能使用**


********


解决方法：


********


迁移完成之后，通过netconfig来把原来的网卡删除掉，(如果进入的是图形界面，选tool-unix进入命令窗口）不要把上面的HW SCO TCP/IP Loopback driver 这个网卡删掉。


********


删除下面的那个网卡，删除完成之后，后提示你重新配置内核，然后重新启动。选择sco虚拟机--编译-添加网卡。重启之后，通过netconfig来添加网卡，添加的是AMD PCNet-PCI Adapter Compatiable……的网卡，然后配置IP。


********


注意配置IP的时候那个broadcast address不要改，这个是广播地址。网关不需要配置。


********



********


**20****、****Linux****下安装****VMware-tools****出现****"/etc/vmware-tools/locations"****错误**


********


故障内容:


********


 A previous installation of VMware software has been detected.


********


The previous installation was made by the tar installer (version 3).


********


Keeping the tar3 installer database format.


********


Error: Unable to find the binary installation directory (answer BINDIR)


********


   in the installer database file "/etc/vmware-tools/locations".


********


解决方法：


********


1、删除etc/vmware-tools目录rm -rf vmware-tools


********


2. 删除/tmp/vm*   rm -rf vm*（注意不要把 VMwa*的也删除）  


********


3、然后用tar –zxvf解压


********



********



********


**21****、所有的虚拟机开启或****VMotion****出现“文件****<unspecified filename>****被锁定，无法访问”**


********


故障内容：环境的所有VM运行出现异常缓慢，关机后的虚拟机开机或VMotion出现“文件<unspecified filename>被锁定，无法访问”


********


解决方法:检查日志，特别是存储上LUN的占用情况，如果有存储使用空间接近预警状态，请登陆存储查看，一般这种情况，是存储空间已经没有空余导致，由于vSpherer4的BUG,有时候在没有报警的情况下，存储空间就已经满了情况。请增加存储或移除部分虚拟机。


********



****










**22****、****Windows****系统的虚拟机无法进入安全模式**




解决方法：选中虚拟机右键“编辑设置”---“选项”**-**---“引导选项”，在“启动引导延迟”填上“1000”（1秒=1000毫秒，数字可以随便填，稍大一点即可）。然后启动按F8即可进入安全模式。




转自：http://saturn.blog.51cto.com/184463/667895



