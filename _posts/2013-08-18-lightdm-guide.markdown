---
author: pandao
comments: false
date: 2013-08-18 15:22:55+00:00
layout: post
slug: lightdm-guide
title: LightDM指南
thread: 244
categories:
- linux
---

# What is LightDM?


[LightDM](http://www.freedesktop.org/wiki/Software/LightDM/) is a _display manager_. The most user visible aspect of the display manager is the login screen, however it also manages the X servers and facilitates remote logins using the XDMCP protocol. It was added as default display manager display manager in Ubuntu 11.10 (Oneric) replacing GDM which has been the display manager since the beginning. See the [blueprint](http://blueprints.launchpad.net/ubuntu/+spec/desktop-o-lightdm) for more details.




# Testing LightDM


**Note**: _Ubuntu is no longer testing LightDM, but the developer continues to work on this project. The remaining information should apply to newer releases, but there may be some minor differences if you are using Kubuntu, Lubuntu, Xubuntu, etc._

To test LightDM in Oneiric, Use the following command:

    
    sudo apt-get install lightdm lightdm-greeter-example-gtk


If using Ubuntu 11.04 (Natty) then use the the [LightDM PPA](http://launchpad.net/~lightdm-team/+archive/ppa) (No Longer Updated):

    
    sudo apt-add-repository ppa:lightdm-team/ppa
    sudo apt-get install lightdm lightdm-greeter-example-gtk


When installing the package you will be prompted to choose your default display manager. You can either run LightDM by default or on demand.




## Running LightDM by default


If you have LightDM as your default display manager then it will just be there when you boot! To switch the default run:

    
    sudo dpkg-reconfigure lightdm





## Running LightDM on demand


If you are using another display manager by default (e.g. GDM) then you will have to stop that and run LightDM on demand. Log out of any graphical sessions, go to a text terminal (alt-ctrl-F1) then switch display managers with the following commands:

    
    sudo stop gdm
    sudo start lightdm





## Running LightDM in test mode


You can also run LightDM in a test mode to try out the greeters (you cannot log into any accounts except your own). You do not need root access to do this. Open a terminal and enter:

    
    lightdm --test-mode





# Configuration and Tweaks


LighDM configuration is governed by the **lightdm.conf** file, however it's not suppose to be directly edited, instead use:



    
    lightdm-set-defaults


**Before you start configuring LighDM create a backup file**:



    
    sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.old





## Disabling Guest Login


If you want to disable guest login, use:



    
    sudo /usr/lib/lightdm/lightdm-set-defaults --allow-guest false


Or, you add it manually in the **[SeatDefaults]** section:



    
    allow-guest=false


The default for this option is true, so if unset, the guest account will be enabled.




## Hiding the User List


If you don’t want a user list to be displayed, you can enable this option. This should also be used with the enabling manual login ([below](http://wiki.ubuntu.com/LightDM#Show_Manual_Login_Box)) or logging in may be a challenge.



    
    sudo /usr/lib/lightdm/lightdm-set-defaults --hide-users true


Or, you can manually add the following line in the **[SeatDefaults]** section:



    
    greeter-hide-users=true


The default for this option is false, so if unset, you will get a user list in the greeter.




## Show Manual Login Box


If you previously hid your user list and would like a box where you can manually type in a user name you can enable it with:



    
    sudo /usr/lib/lightdm/lightdm-set-defaults --show-manual-login true


Or, you can manually add the following line in the **[SeatDefaults]** section:



    
    greeter-show-manual-login=true


The default for this option is false, so if unset, you won’t get a manual login box.




## Autologin


You can enable autologin by specifying the autologin user.



    
    sudo /usr/lib/lightdm/lightdm-set-defaults --autologin username


Or, you can manually add the following line in the **[SeatDefaults]** section:



    
    autologin-user=username


There are other autologin related options which you may want to set, but none of these can be set using lightdm-set-defaults:

To change how long the greeter will delay before starting autologin. If not set, the delay is 0, so if you want this to be 0, you don’t need to change it. Note: the default for all unset integers in the **[SeatDefaults]** section is 0.



    
    autologin-user-timeout=delay


To enable autologin of the guest account:



    
    autologin-guest=true


You could disable autologin by removing the configure item



    
    autologin-user=username


at /etc/lightdm/lightdm.conf




## Autorun a Command


You can run a command when the X Starts, when the greeter starts or when the user session starts




### Autorun a Command when X starts


When lightdm starts X you can run a command or script, like xset perhaps.



    
    display-setup-script=[script|command]





### Autorun a Command when the Greeter starts


You can do something similar when the greeter starts:



    
    greeter-setup-script=[script|command]





### Autorun a Command when the User Session starts


If you want to spawn something when the user session starts, you can do it with:



    
    session-setup-script=[script|command]





## Change the Default Session


If you want a different session for the default, you can modify this option. The greeter will default to give you the last session you chose, so this option will only change the default session. Note: The session switcher will only show up if you have more than one VALID session; a valid session is one that points to a valid executable. By default in 12.10 you will have a session file for gnome-shell, but gnome-shell won’t be installed, so the session is invalid, leaving you with a single valid session (Ubuntu), and hence no session selector!



    
    /usr/lib/lightdm/lightdm-set-defaults --session [session name]


Or, you can manually add the following line in the **[SeatDefaults]** section:



    
    user-session=true


The list of user sessions is in **/usr/share/xsessions**, although even that location is configurable (see Advanced Options).

You can change the default greeter in the same manner, using --greeter for lightdm-set-defaults or greeter-session for the config file. The list of installed greeters is in **/usr/share/xgreeters**.

* Note: The default greeter for Ubuntu is currently unity-greeter without lightdm in the name.




## Change the wallpaper




    
    gksudo leafpad /etc/lightdm/lightdm-gtk-greeter.conf





	
  * Replace **leafpad** with your favorite text editor




    
    background=/usr/share/lubuntu/wallpapers/lubuntu-default-wallpaper.png


Now replace the default wallpaper with the one you want. Then Save.




## Advanced Options


There is no manpage for lighdm.conf, but there is an example that lists all the options and a bit about what they do, just look in**/usr/share/doc/lightdm/lightdm.conf.gz**.

Running /usr/lib/lightdm/lightdm-set-defaults with no arguments will get a full picture of all the arguments it accepts.



    
    Usage:
    lightdm-set-defaults [OPTION...] - set lightdm default values
    
    Help Options:
    -h, --help Show help options
    
    Application Options:
    -d, --debug Enable debugging
    -k, --keep-old Only update if no default already set
    -r, --remove Remove default value if it's the current one
    -s, --session Set default session
    -g, --greeter Set default greeter
    -a, --autologin Set autologin user
    -i, --hide-users Set greeter-hide-users to true or false
    -m, --show-manual-login Set show-manual-login to true or false
    -l, --allow-guest Set allow-guest to true or false


-R, --show-remote-login Set show-remote-login to true or false1

1. This option is unavailable at this time.




# Debugging LightDM


LightDM writes verbose logs to /var/log/lightdm. Please check these if there appears to be a problem. If you are running it from the command line (e.g. in test mode) you can also get debugging information by running with the --debug flag.




# What to do if things go wrong


If things go horribly wrong (we promise to try very hard to avoid this) you may need switch back to GDM. Some tricks to do this:



	
  * If you have no graphics, go to a text terminal using alt-ctrl-F1

	
  * Stop LightDM with _sudo stop lightdm_

	
  * Start GDM with _sudo start gdm_

	
  * Run _sudo dpkg-reconfigure lightdm_ to set the default display manager

	
  * Edit /etc/X11/default-display-manager and set it to /usr/sbin/gdm if you can't run the above

	
  * Uninstall LightDM and GDM will replace it after a reboot

	
  * If things go really bad, you may need to remote login using SSH or by using grub to enter a recovery mode (It should never get this bad and if it does then blame X).





# Reporting problems, feature requests


Use the [Launchpad project](http://launchpad.net/lightdm) and file bugs please. If you are using Oneiric or later please use:

    
    ubuntu-bug lightdm


so that all appropriate information/logs are attached. If you are using Natty you will have to report the bugs manually, please give the version of LightDM you are using.




# Developing greeters


Install liblightdm-gobject-0-dev or liblightdm-qt-0-dev for the LightDM greeter API. Look at the LightDM source for example greeters in greeters/.
