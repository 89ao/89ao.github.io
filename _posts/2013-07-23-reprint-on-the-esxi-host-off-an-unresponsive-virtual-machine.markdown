---
author: pandao
comments: false
date: 2013-07-23 12:46:32+00:00
layout: post
slug: reprint-on-the-esxi-host-off-an-unresponsive-virtual-machine
title: '[转载]在ESXi主机上关闭无响应的虚拟机'
thread: 216
categories:
- linux
- Virtualization
---

## 在ESXi主机上关闭无响应的虚拟机







#### 适用情况





该方法适用于以下情况:



	
  * ESXi主机上的虚拟机不能关闭。

	
  * 虚拟机无响应且不能停止。








#### 目的





这篇文章描述在ESXi环境中如何正确的关闭一台无响应的虚拟机。

**注意：** 这篇文章只适用于ESXi主机，不适用于ESX主机。对于ESX主机，请参考 [Powering off an unresponsive virtual machine on an ESX host (1004340)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1004340).

**注意：** 如果你尝试查找造成虚拟机无响应的原因，首先应当收集性能变化规律，然后中止虚拟机运行，从而收集更多的故障信息。要获得更多信息，请参考 [Troubleshooting a virtual machine that has stopped responding: VMM and Guest CPU usage comparison (1017926)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1017926) 或者 [Troubleshooting a virtual machine that has stopped responding (1007819)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1007819).








#### 解决方案





** 警告：** 请严格按照文章中的步骤操作。每一步操作对虚拟机都有一定的影响，所以请不要跳过其中任何一步！


### 用vSphere Client关闭虚拟机


用客户端尝试顺利关闭虚拟机：



	
  1.     用vSphere Client或者 VI Client连接 VMware vCenter Server或VirtualCenter Server。

	
  2.     右键单击要关闭的虚拟机，从弹出的快捷菜单中选择“电源->关闭客户机”。如果操作失败并提示“正在处理另一个任务”，请等待任务完成，或者参考 [Powering off a virtual machine fails with the error: Cannot power Off: Another task is already in progress (1027040)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1027040) 或 [vCenter operation times out with the error: Operation failed since another task is in progress (1004790)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1004790).

	
  3.     如果虚拟机依然在运行，请尝试在主机上进行相同的操作。

	
  4.     用vSphere Client或者 VI Client 直接连接ESXi主机来运行虚拟机。

	
  5.     右键单击要关闭的虚拟机，从弹出的快捷菜单中选择“电源->关闭客户机”。


如果虚拟机使用客户端不能正常关机，请选用以下任一种命令行模式。


### 安装 vSphere Command-Line Interface 工具


vSphere Command-Line Interface (vCLI) 会在本文的某些步骤中用到，所以在使用前请确保你已经正确的安装了它。



	
  * 对于ESXi 3.5 主机， 请在 [Remote Command-Line Interface Installation and Reference Guide](http://www.vmware.com/pdf/vi3_35/esx_3/r35u2/vi3_35_25_u2_rcli.pdf)中参考_Remote CLI Installation and Execution_ 。

	
  * 对于ESXi 4.0 主机， 请在 [vSphere Command-Line Interface Installation and Reference Guide](http://www.vmware.com/pdf/vsphere4/r40/vsp_40_vcli.pdf)中参考_vSphere CLI Installation, Execution, and Command Overviews_ 。

	
  * 对于 ESXi 4.1主机，请参考 [vSphere Command-Line Interface Installation and Scripting Guide](http://www.vmware.com/pdf/vsphere4/r41/vsp4_41_vcli_inst_script.pdf)。

	
  * 对于ESXi 5.0 主机，请参考 [vSphere Command-Line Interface Documentation](https://www.vmware.com/support/developer/vcli/)。


** 注意：** 对于ESXi 4.x 和 ESX 5.0主机，远程命令行接口程序会通过vSphere Management Assistant (vMA) 访问。 如果你偏爱这个工具，请在 [vSphere Command-Line Interface Installation and Reference Guide](http://www.vmware.com/pdf/vsphere4/r40/vsp_40_vcli.pdf)中参考 _Installing vMA and Running Commands from vMA_ 。


### 确认虚拟机的位置


请确认虚拟机是在哪个主机上运行。你可以通过vSphere Client中虚拟机的“摘要”选项卡来查看相关信息。随后将在虚拟机所在的主机上运行相关命令来关闭虚拟机。


### 使用ESXi 5.0 主机的esxcli 命令来关闭虚拟机


`esxcli` 命令能够在本地或远程来关闭运行在ESXi 5.0主机上的虚拟机。要获得更多信息，请参考 [vSphere Command-Line Interface Reference](http://pubs.vmware.com/vsphere-50/topic/com.vmware.vcli.ref.doc_50/esxcli_vm.html)中_esxcli vm Commands_ 章节。



	
  1.     打开ESXi Shell、vSphere Management Assistant (vMA)或vSphere Command-Line Interface (vCLI) 客户端，只要`esxcli`工具能够运行即可。

	
  2.     使用如下命令获取正在运行的虚拟机清单，该清单由World ID、UUID、Display Name和 `.vmx` 配置文件所在路径构成：

`esxcli vm process list`

	
  3.     用如下命令关闭一台虚拟机：

`esxcli vm process kill --type=_[soft,hard,force]_` `--world-id=_WorldNumber_`

**注意：** 有三种关闭虚拟机的方法，Soft 程度最低，hard 为立即执行，如果依然不能关闭，则可以使用force 模式。

	
  4.     执行步骤2来检查虚拟机是否已不再运行。

	
  5.     在 ESXi 控制台，进入技术支持模式，用root用户登录。 更多信息请参考 [Tech Support Mode for Emergency Support (1003677)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1003677).

	
  6.     使用如下命令获取正在运行的虚拟机清单，该清单由VMID、Display Name和 `.vmx` 配置文件所在路径构成：

`vim-cmd vmsvc/getallvms`

	
  7.     获取虚拟机的当前状态：

`vim-cmd vmsvc/power.getstate` `_VMID_`

	
  8.     使用第2步获取的VMID 来关闭虚拟机：

`vim-cmd vmsvc/power.shutdown` `_VMID_`

**Note**: 如果虚拟机还是不能关闭，请尝试以下命令：

vim-cmd vmsvc/power.off _VMID_




### 使用 ESXi 命令行工具 vim-cmd 来关闭虚拟机




### 在ESXi主机上发送信号来关闭虚拟机


虚拟机能够在命令行模式下停止相关进程从而关闭。

** 警告：**这个操作对ESXi 主机有潜在的危险。 如果你不能正确的辨别进程ID，而误杀了其它进程，这极有可能引起不可预知的结果。如果你不能有把握的执行以下操作，请给VMware 技术支持部门发送支持请求，并在问题描述中说明本知识库的文档编号（1014165）。要获取更多信息，请参考[How to Submit a Support Request](http://www.vmware.com/support/policies/howto.html)。

在 ESXi 3.5-5.0主机中， 你可以使用 `kill` 命令来中止一个虚拟机进程。



	
  1.     在 ESXi 控制台，进入技术支持模式，用root用户登录。 更多信息请参考 [Tech Support Mode for Emergency Support (1003677)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1003677).

	
  2.     要知道ESXi 主机上是否有虚拟机进程在运行，可使用如下命令：

`ps | grep vmx`

输出如下所示：

`**7662 7662**` `vmx /bin/vmx`
`7667`  `**7662**` `vmx /bin/vmx`
`7668`  `**7662**` `mks:VirtualMachineName /bin/vmx`
`7669`  `**7662**` `vcpu-0:VirtualMachineName /bin/vmx`

每一个vmx进程都会返回一行。 请仔细辨别目标虚拟机的vmx父进程。第一列为进程ID(PID)，第二列即为父进程ID （parent's PID）。 请确保你只中止了父进程。 父进程ID (PID)在每一行的第二列， 在本例中都用粗体标识。请记住这个号码，它将在下面的步骤中用到。

**警告：** 请确保你已经确认了要修复的虚拟机所在的行。如果你是对除了有问题的虚拟机以外的虚拟机进行这些操作，那么极有可能引起这些机器宕机。

	
  3.     如果 `vmx` 进程在列表中，使用如下命令即可终止该进程：

`kill` `_ProcessID_`

	
  4.     等待30秒然后重复步骤2来检查进程是否已终止。

	
  5.     如果进程依然没有终止，可使用以下命令：

`kill -9` `_ProcessID_`

	
  6.     等待30秒然后重复检查进程是否已终止。


在ESXi 4.1-ESXi 5.0主机中，你可以使用 `esxtop`中的 `k` 命令来终止一个正在运行中的虚拟机进程。



	
  1.     在 ESXi 控制台，进入技术支持模式，用root用户登录。 更多信息请参考 [Tech Support Mode for Emergency Support (1003677)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1003677).

	
  2.     使用以下命令来运行 `esxtop` 工具：

`esxtop`

	
  3.     按 **c** 选择 CPU 资源利用界面。

	
  4.     按 **f** 显示信息列表。

	
  5.     按 `**c**` 添加 Leader World ID列。

	
  6.     通过虚拟机名称和Leader World ID (`LWID`)确认我们要修复的虚拟机。

	
  7.     按 **k****。**

	
  8.     在 `World to kill` 提醒后面，输入第6步确认的Leader World ID，然后按**Enter**。

	
  9.     等待30秒然后验证进程是否已经结束。







#### 附加信息





如果使用以上方法均不能关闭虚拟机，则说明问题可能是由于ESXi主机或者它的硬件问题所引起的。

如果怀疑是由于ESXi主机问题引起的虚拟机不能关闭， 请使用vMotion将所有未受影响的虚拟机迁移到其它主机，然后强制关闭主机并使用硬件诊断工具检测问题。 更多信息请参考 [Using hardware NMI facilities to troubleshoot unresponsive hosts (1014767)](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1014767).
