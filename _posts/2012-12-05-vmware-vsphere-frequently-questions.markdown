---
author: pandao
comments: false
date: 2012-12-05 04:29:37+00:00
layout: post
slug: vmware-vsphere-frequently-questions
title: Vmware vSphere常见问题
thread: 167
categories:
- Virtualization
---

清除vSphere Client的登录记录
使用vSphere Client连接多了,下拉列表里有很多的历史记录,看着有点烦.
搜索了下,找到了E文的操作办法
定位注册表到
HKEY_CURRENT_USER\Software\VMware\VMware Infrastructure Client\Preferences
清除
RecentConnections 的记录即可

Linux系统VMXNET3虚拟网路卡时UDP包被Drop掉
故障状态:
ESXi 5.x系统上的Linux虚拟机，虚拟网路卡选择为VMXNET3时，UDP包被Drop掉了；
故障分析:
这是一个技术bug，VMware正在着手解决；
解决方案:
作为变通手段，只需要将VMXNET3改为E1000这个虚拟网路卡类型即可。

恢复孤立的虚拟机
故障状态：
虚拟机显示在 vSphere Client 清单列表中，其中 (orphaned) 附加到其名称。
故障分析：
在极少数情况下，位于由 vCenter Server 管理的 ESXi 主机上的虚拟机可能会变为孤立状态。 vCenter Server 数据库中存在这些虚拟机，但 ESXi 主机不再能识别出它们。 故障原因：
如果主机故障切换失败，或直接在主机上取消对虚拟机的注册时，虚拟机可能会变为孤立状态。如果发生这种情况， 请将孤立的虚拟机移动到数据中心（ 该数据中心可访问其中存储着虚拟机文件的数据存储） 中的其他主机。
解决方案：
1 在 vSphere Client 清单列表中，右键单击虚拟机，然后选择重定位。此时将显示可用主机列表。
2 选择要在其中放置虚拟机的主机。如果没有可用主机，请添加可访问其中存储着虚拟机文件的数据存储的主机。
3 单击确定保存更改。虚拟机已连接到新的主机，并显示在清单列表中。

从模板克隆或部署后未打开虚拟机电源
故障状态：
当从模板中克隆或部署虚拟机时，可以在“即将完成”页面上选中创建后打开此虚拟机电源复选框。但虚拟机在创建后可能不会自动打开电源。
故障分析：
创建虚拟机磁盘时，未预留交换文件大小。
解决方案:
n 减小虚拟机所需的交换文件的大小。可以通过增加虚拟机内存预留空间来实现。
a 在 vSphere Client 清单中，右键单击虚拟机并选择编辑设置。
b 选择资源选项卡，然后单击内存。
c 使用“预留”滑块增加分配给虚拟机的内存量。

d 单击确定。 |
n 或者，可以通过将其他虚拟机磁盘从交换文件正在使用的数据存储中移出来增加交换文件的可用空间量。
a 在 vSphere Client 清单中，选择一个数据存储，然后单击虚拟机选项卡。
b 对于每个要移动的虚拟机，右键单击虚拟机，然后选择迁移。
c 选择更改数据存储。
d 继续完成迁移虚拟机向导。
n 另外，可以通过将交换文件位置更改为具有足够空间的数据存储来增加交换文件的可用空间量。
a 在 vSphere Client 清单中，选择主机，然后单击配置选项卡。
b 在“软件”下，选择虚拟机交换文件位置。
c 单击编辑。
注意 如果主机属于指定虚拟机交换文件与虚拟机存储在同一目录的群集，则无法单击 编辑。您必须使用“群集设置”对话框更改群集的交换文件位置策略。
d 从列表中选择数据存储，然后单击确定。

通过NAT连接的vCenter和ESXi主机每隔30～60秒左右自动断开
故障状态:
通过NAT地址转换后的vCenter和ESXi主机之间的通信每30～60秒左右会中断；
故障分析:
这个问题一般都是由于在vCenter和ESXi主机之间无法通过NAT进行正常通信导致；
解决方案:
导致上述问题的原因是UDP 902端口适用于心跳的，而这个端口打开之后，2008服务器的防火墙可能会锁掉Edge Traversal，因此需要激活Allow Edge Traversal选项，步骤如下：
1、进入到2008系统的管理工具面板里；
2、点击Windows Firewall with Advanced Security后点击Inbound Rules；
3、找到VMware vCenter Server - Host heartbeat规则，点击Advanced页标签；
4、点击Allow Edge Traversal选项后，点击OK；
5、然后重启相关服务后重新删除/添加ESXi主机到vCenter Server即可。

为虚拟机添加PCI设备
步骤如下：
1、利用vSphere Client登录系统之后，找到要添加PCI设备的虚拟机；
2、右击Virtual Machine->Edit Settings；
3、在Hardware页标签点击Add；
4、选择PCI Device然后点击Next进入下一步，悬着passthrough设备，然后点击Next进入下一步；
5、如果确认没啥问题则点击Finish完成。

数据库sa密码变更后修改vCenter Server的sa访问密码方法
出于安全等方面考虑，SQL数据库的sa密码发生了变更，那么，这时它关联的vCenter Server这边也应该相应调整，那么，不重装就可以调整的方式如下：
1、管理员权限登录到vCenter Server所在Windows 操作系统；
2、进入入到如下目录：C:\Program Files\VMware\Infrastructure\VirtualCenter Server\，执行如下命令：

vpxd -P <new_Password>
3、重启VirtualCenter Server services相关服务即可。

“虚拟设备的数目超过给定控制器的最大值”的错误
故障状态:

克隆虚拟机的时候出现如下的报错：

“虚拟设备的数目超过给定控制器的最大值”
故障分析:
这个问题一般都是由于在克隆虚拟机的时候，对源虚拟机做了虚拟硬件的操作导致
解决方案：

重新克隆虚拟机，在克隆的时候不要对源虚拟机进行虚假硬件的操作。

vCenter Operations Manager 5.0自动锁定了admin账户的解决方案
故障状态:

密码重试次数过多，导致了admin账户被锁定，无法再登录，解决思路如下：
解决方案：
首先，确认admin账户是否真的被锁定：
1、用root账户登录，然后执行如下命令：

su admin

如果该账户被锁定，则系统将会显示类似如下信息：

Account locked due to XX failed login....

2、然后再在Analytics虚拟机上重复上述步骤；
当确认admin账户被锁定后，解除锁定步骤如下：
1、root账户登录，然后执行如下命令：

pam_tally --user admin --reset

2、再在Analytics虚拟机上重复这个步骤即可。
备注：
如果想要一劳永逸的禁止掉自动锁定账户的功能则可以参考如下步骤：
1、root账户登录，然后执行如下命令：

/etc/pam.d/common-auth:auth requisite pam_tally.so deny=3

2、再在Analytics虚拟机上重复上述步骤即可。

79、 解决由于esx.conf文件锁定导致ESXi从vCenter Server断开连接的问题
故障状态:
1、ESXi 5.0主机莫名其妙无响应从vCenter Server断开；
2、SSH或DCUI登录ESXi主机失败；
3、vmkernel.log文件里没有任何问题，执行esxtop命令是可以看到CPU消耗率为100%；
4、在hostd.log日志文件里有类似如下信息：

1. 2012-07-07 T10:10:32.170Q [2D2D7B90 verbose 'ThreadPool'] usage : total=19 max=62 workrun=18

iorun=1 workQ=933 ioQ=0 maxrun=24 maxQ=934 cur=I 2012-07-07 T19:17:25.641Z [2CA47B90 verbose

'ThreadPool'] usage : total=20 max=62 workrun=18 iorun=2 workQ=933 ioQ=0 maxrun=24 maxQ=934 cur=I

2012-07-07 T10:10:32.442Q [2CA47B90 verbose 'SoapAdapter'] Responded to service state request

故障分析:
这个问题可能由于esx.conf文件被锁定导致；
解决方案:
解除esx.conf文件的锁定状态，方法如下：
1、登录到ESXi主机的本地命令行界面后执行如下命令：

1. #ls -l /etc/vmware/esx.conf.LOCK

2、执行如下命令删除掉该文件：

1. #rm /etc/vmware/esx.conf.LOCK

3、执行如下命令重启管理服务：

1. $/sbin/services.sh restart
