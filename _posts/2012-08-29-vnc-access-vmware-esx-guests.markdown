---
author: pandao
comments: false
date: 2012-08-29 16:00:53+00:00
layout: post
slug: vnc-access-vmware-esx-guests
title: Use VNC to Access VMware ESX guests
thread: 134
categories:
- linux
---

While browsing through the ESX 4.0 screens, I stumbled on the firewall option to enable or disable access to a VNC server. That was reason for me lookup a way to use this VNC server. It appears that ESX 4.0 has a built-in VNC Server which you can use to manage your virtual machines. You can login from machines that you don’t have the vSphere client installed on. For example, Linux systems or that nice little HP Thin Client I have here. Some may even use it as a backdoor.
Basics

This VNC connection is a console view, just like when you’re using a KVM switch.
Yes, you can access the BIOS.
It’s a pretty basic way of accessing guests. It does not have advanced functions like poweron/poweroff, reconfiguration and stuff. Use the VMWare Server Console or the VMWare MUI web interface for that.
It must be enabled per-guest.
Connect to the IP/hostname of the ESX server – not the IP/hostname of the guest!
The VNC server for each VM guest you connect to will have a different display number.
Display numbers and tcp port numbers are linked: display 0 = port 5900, display 1 = port 5901

How it works

Switch off your VM Guest.
Add a few lines to its configuration.
Switch on your VM Guest
Connect to the IP/hostname of the ESX server – not the IP/hostname of the guest!

The actual configuration
RemoteDisplay.vnc.enabled = “TRUE” RemoteDisplay.vnc.password = “your_password” RemoteDisplay.vnc.port = “5900″ You can apply these settings by editting the .vmx file manually using ssh or the Datastore browser. Or you can use the gui:

Select the right VM Guest in your vSphere client.
Right click and choose “Edit settings”
Go to the “Options” tab
Under “Advanced”, choose “General”.
Click on the “Configuration Parameters” button.
Add the configuration parameters
Click OK
Click OK
That’s all folks.

Firewall
You will need to open the firewall to allow incoming VNC connections. You can find this in the ESX hosts configuration > Software:Security profile > Properties. Or you could run “esxcfg-firewall -e vncServer”

from:http://www.geeklab.info/2010/01/use-vnc-to-access-vmware-esx-guests/
