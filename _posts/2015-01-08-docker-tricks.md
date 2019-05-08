---
layout: post
title: "一些docker的技巧和秘诀"
categories:
- Linux
tags:
- docker


---

关于docker容器和镜像的关系

无论容器里做什么操作，写文件，删文件。该容器的基本镜像都不会有任何改变。这是因为Docker从父镜像建立增量镜像，只存储每个容器的更改。因此，如果你有一个300MB的父镜像，如果你在容器中安装了50MB的额外应用或服务，你的容器只有50MB，父镜像还是300MB。
但是可以使用Dockfile或commit命令来，把增量镜像和父镜像一起生成一个新的镜像。

	dock top -- 显示容器中运行的进程

查看容器的root用户名和密码

	docker logs <容器名orID> 2>&1 | grep '^User: ' | tail -n1
因为docker容器启动时的root用户的密码是随机分配的。所以，通过这种方式就可以得到redmine容器的root用户的密码了。

实时查看容器日志

	docker logs -f <容器名orID>

删除所有容器

	docker rm $(docker ps -a -q)


停止、启动、杀死一个容器

	docker stop <容器名orID>
	docker start <容器名orID>
	docker kill <容器名orID>

查看所有镜像

	docker images

删除所有镜像

	docker rmi $(docker images | grep none | awk '{print $3}' | sort -r)

移除所有的容器和镜像（大扫除）

用一行命令大扫除：

	docker kill $(docker ps -q) ; docker rm $(docker ps -a -q) ; docker rmi $(docker images -q -a) 

注：shell 中的 $() 和`command`类似，会先执行这里面的内容，上面的脚本会出现如下 docker kill "pids" ; docker kill 在 docker 中用于停止容器，docker rm 删除容器， docker rmi 删除镜像

当没有运行的容器或者是根本没有容器的时候，这只会提示一个警告信息。当你想尝试的时候，这就是个非常好的单行命令。如果你仅仅想删除所有的容器，你可以运行如下命令：

	docker kill $(docker ps -q) ; docker rm $(docker ps -a -q) 
不在 Shell 上运行命令

如果你使用需要Shell 的扩展项的 docker run 命令处理某些事情，比如 docker run --rm busybox ls '/var/log/*', 这个命令将失败。这个失败的原因我花了工夫才弄明白。这个陷阱在这里：你原来没有 Shell ， 而 ```* 是 Shell 的扩展项，因此你需要一个能使用的 Shell 。正确方法为：

	docker run --rm busybox sh -c 'ls /var/log/*'

多程序开机自动运行方法：

docker容器每次启动时，开机自启动的命令都要在启动容器前指定。如 docker run -I -t debian /bin/bash命令，只会运行/bin/bash程序，其它的程序都不会运行，对于要跑多个程序的容器特别纠结。可把前面所说的启动命令换成

	dockerrun -I -t debian /etc/rc.local

在容器中把所有需要开机自的启动命令放在/etc/rc.local中，就可以达到多程序开机自启动了。

后台运行则是：

	docker run -d -p 50001:22 debian /etc/rc.local

退出时删除容器

如果你仅仅想在一个容器中快速的运行一个命令，然后退出，并且不用担心容器状态，把 `--rm` 参数加入 run 命令后面,这将结束很多你保存了的容器，并且清理它们。

	docker run --rm -i -t busybox /bin/bash

运行一个新容器，同时为它命名、端口映射、文件夹映射。以redmine镜像为例

	docker run --name redmine -p 9003:80 -p 9023:22 -d -v /var/redmine/files:/redmine/files -v /var/redmine/mysql:/var/lib/mysql sameersbn/redmine

一个容器连接到另一个容器

	docker run -i -t --name sonar -d -link mmysql:db   tpires/sonar-server
	sonar

容器连接到mmysql容器，并将mmysql容器重命名为db。这样，sonar容器就可以使用db的相关的环境变量了。


##镜像的保存与导入
当需要把一台机器上的镜像迁移到另一台机器的时候，需要保存镜像与加载镜像。
机器a

	docker save busybox-1 > /home/save.tar

使用scp将save.tar拷到机器b上，然后：

	docker load < /home/save.tar

构建自己的镜像

	docker build -t <镜像名> <Dockerfile路径>

如Dockerfile在当前路径：

	docker build -t xx/gitlab .

重新查看container的stdout

	# 启动top命令，后台运行
	$ ID=$(sudo docker run -d ubuntu /usr/bin/top -b)
	# 获取正在running的container的输出
	$ sudo docker attach $ID
	top - 02:05:52 up  3:05,  0 users,  load average: 0.01, 0.02, 0.05Tasks:   1 total,   1 running,   0 sleeping,   0 stopped,   0 zombie
	Cpu(s):  0.1%us,  0.2%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
	Mem:    373572k total,   355560k used,    18012k free,    27872k buffers
	Swap:   786428k total,        0k used,   786428k free,   221740k cached
	^C$
	$ sudo docker stop $ID

后台运行(-d)、并暴露端口(-p)

	docker run -d -p 127.0.0.1:33301:22 centos6-ssh

从container中拷贝文件出来

	sudo docker cp 7bb0e258aefe:/etc/debian_version .

拷贝7bb0e258aefe中的/etc/debian_version到当前目录下。
注意：只要7bb0e258aefe没有被删除，文件命名空间就还在，可以放心的把exit状态的container的文件拷贝出来
