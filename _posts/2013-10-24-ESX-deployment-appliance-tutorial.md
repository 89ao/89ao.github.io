---
layout: post
title: "自动化部署ESX方案EDA"
categories:
- Linux
tags:
- VMWARE
- virtualization


---

###你可以在这里下载到这个包：

[EDA-v1.05](http://virtuall.eu/download-document/eda-v1.05.zip)

**Quick startup and troubleshooting guide**

The current version is 1.05. This guide is written for pre 1.0 versions but except for some first-time wizards, it still applies to the newest release. If you have anything to say about this appliance, don't hesitate and go to the VMTN forum for this appliance. To search through everybody's issues and solutions, have a look at the whole thread in PDF format. Also, there's some troubleshooting tips, right at the bottom of this article.

**Getting started**

**First startup**

When the appliance is started for the first time, it will request a static IP address. After configuring it, start a browser and point it to the address shown. When requested a username password, fill in 'root' and 'root' and the configuration window will show.

**Configuration**

First go to 'Configure Appliance' and change root and user password if necessary, apply the settings and go to 'Configure DHCP server'. Do this always! The option 'domain-name' is used for the ESX host dns domainname. If the DHCP server of the appliance will not be used it can be switched off here. If some other unix DHCP server is used, set the 'next-server' to the appliance IP address and the 'filename' to 'pxelinux.0'. If a Windows DHCP server is used, change the scope settings 66 and 67 to those values.

**Adding hosts**

Now start adding ESX hosts. Use hostnames only! Whether or not the DHCP server of the appliance is used, the option 'domain-name' will be used to create a FQDN for the ESX hosts. After that, start setting the generic ESX values and if needed, change the partition table. Now it's time to build a configuration script.

**Adding a script**

Configuring the ESX host is easy with the scriptbuilder from the appliance. Just hoover over the button and it will show what values to fill in before the button adds scriptparts to the script window.

**Adding files to the appliance**

When files are needed for the ESX deployment (like HP or Dell agents), point a windows explorer to `\\[IP address]\DL$` (the R/W share). Fill in the root user and password and you can write files to the appliance. The scriptbuilder uses the ESX host's smbclient to get the files to the host through `\\[IP address]\DL` (this is a readonly share, public readable or accessible with user 'user' by adding `-U 'user%[userpassword]'` to the scriptpart).

**Adding an ESX CDrom**

The appliance will put a red line 'CD not mounted' on the main page until an ESX CD has been fed to the appliance. It will automatically mount the CD once it's connected (this can either be a physical CDrom connected through the host running the appliance or a ISO image (which is much faster)). A refresh on the main page will remove the red warning. Once the CD is connected, click 'import PXE bootfiles' to import the files from the CD. This will put the bootfiles on the correct location in the appliance but also remove the SAN drivers from these bootimages to safely install ESX servers that are connected to a SAN. Once the window pops up showing this has been succesful (can take some time) it's time to boot the first ESX host.

**Installing an ESX host**

If network boot isn't the first bootoption on a server, hit F12 at boottime to start the PXE boot process. When the bootscreen shows, type in the name of this perticular ESX host and watch the installer do it's thing. After a couple of minutes the server is ready. Add it to a VirtualCenter if you have one and check the network and storage settings. Add it to a VC cluster and you're set.

**Troubleshooting**

When copying the appliance it will generate a new Mac address. In previous versions, this would result in a new network device 'eth1' instead of 'eth0'. This would result in an empty IP address on the appliance console which can be confusing. A workaround for this issue is to hit 'ctrl-F1', log in with 'root' and the root password, type 'rm /etc/udev/rules.d/70-persistent-net.rules' and reboot (ctrl-alt-ins, or type 'reboot').

If there's no DHCP server available on first boot (which would make sense if the appliance is going to fulfil that job), it will default to 192.168.1.99/24. To configure it, change a client's IP address to something in this range and configure the appliance.

When using VLAN's in your environment, follow the next rules:

- make sure the ESX ip addresses are in the SAME ip range as the EDA. very important, it will not work if they're on different subnets.

- only if you can enter a VLAN tag in your BIOS for pxe (like some dell machines can), can you use EDA on a tagged network. in all other cases, you HAVE to use native vlan tagging for pxe boot. that means that when EDA runs on a ESX server, you create a portgroup with no vlan tags and have the physical switches add the tag (called native in Cisco language). the service console portgroup can not be tagged either. if you absolutely cannot have an EDA in your service console network you need to add a second console vswif and remove the first, all from the script. this is possible because once the script starts, the ESX server is running and can be on another subnet than the EDA. we leave the EDA at our customers as a disaster recovery system (or even a quick upgrade system;)* upgrading to U4 by reinstalling it with EDA is much faster than a remediate :)) and it's usually considered part of the management network wether it runs DHCP or not..

- when installing an ESX server, the network gets initiated 3 times before the first reboot. unfortunately the NIC detection routines differ slightly which causes the network order to change. so when pxe starts, your first onboard nic could be considered eth0 while the second step sees it as eth1. in the EDA there's an option to specifically set the ksdevice. you could try changing that from eth0 to eth1 or higher and see if that helps

- as for WDS, that's a very strange toolset from microsoft. even if the DHCP server points to something else, the WDS server still reponds to pxe and tftp queries. very annoying tool. i need to disable it most of the time before i can install my servers. even if i add the mac addresses of the hosts i'm installing as reservations in the dhcp scope, WDS keeps coming through.
