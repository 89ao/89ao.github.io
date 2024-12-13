---
layout: post
title: "Install Node.js on Linux"
categories:
- Linux
tags:
- node.js


---


 
#How to install Node.js on Linux

##Install Node.js on Debian

On Debian, you can install Node.js from its source as follows.

	sudo apt-get install python g++ make
	wget http://nodejs.org/dist/node-latest.tar.gz
	tar xvfvz node-latest.tar.gz
	cd node-v0.10.21 (replace a version with your own)
	./configure
	make
	sudo make install

##Install Node.js on Ubuntu or Linux Mint

Node.js is included in Ubuntu (13.04 and higher). Thus installation is straightforward. The following will install Node.js and npm.

	sudo apt-get install npm
	sudo ln -s /usr/bin/nodejs /usr/bin/node

While stock Ubuntu ships Node.js, you can install a more recent version from its PPA as follows.

	sudo apt-get install python-software-properties python g++ make
	sudo add-apt-repository -y ppa:chris-lea/node.js
	sudo apt-get update
	sudo apt-get install npm

##Install Node.js on Fedora

Node.js is included in the base repository of Fedora. Therefore you can use yum to install Node.js on Fedora.

	sudo yum install npm
If you want to install the latest version of Node.js, you can build it from its source as follows.

	sudo yum groupinstall 'Development Tools'
	wget http://nodejs.org/dist/node-latest.tar.gz
	tar xvfvz node-latest.tar.gz
	cd node-v0.10.21 (replace a version with your own)
	./configure
	make
	sudo make install

##Install Node.js on CentOS or RHEL

To install Node.js with yum package manager on CentOS, first enable EPEL repository,

###Enable EPEL repository


For CentOS 5.*:

	$ sudo rpm -Uvh http://mirrors.kernel.org/fedora-epel/5/i386/epel-release-5-4.noarch.rpm
For CentOS 6.*:

	$ sudo rpm -Uvh http://mirrors.kernel.org/fedora-epel/6/i386/epel-release-6-8.noarch.rpm

To verify that EPEL yum repository has been set up successfully, run the following command to list all available repositories on your system.

	$ yum repolist
	repo id          repo name                                                status
	base             CentOS-6 - Base                                           6,367
	epel             Extra Packages for Enterprise Linux 6 - x86_64           10,740
	extras           CentOS-6 - Extras                                            14
	updates          CentOS-6 - Updates                                          851
	repolist: 17,972

and then run:

	sudo yum install npm

If you want to build the latest Node.js on CentOS, follow the same procedure as in Fedora.

##Check the Version of Node.js

Once you have installed Node.js, you can check Node.js version as follows.

	node --version