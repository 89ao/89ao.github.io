---
layout: post
title: "Docker的安装和使用笔记"
categories:
- Linux
tags:
- docker


---


##一，安装docker
安装docker包

	$ sudo zypper in docker

现在它安装好了，让我们来启动docker进程

	$ sudo systemctl start docker

如果我们想要开机启动docker，你需要这样：

	$ sudo systemctl enable docker

此时docker命令仍然只能`sudo`使用，于是将普通用户加入docker组，具备相应权限：

	$ sudo usermod -a -G docker <username>

来确认一切都是否按照预期工作：

	$ docker search centos -- 以centos为关键词在线搜索镜像
	$ docker pull centos -- 下载名为centos的镜像
	$ docker images -- 检查本地存在的镜像


###使用docker

##1,修改镜像
运行容器，并且在容器内运行bash，`-i -t`开一个tty终端，保持交互模式，输入exit退出容器。

	$ docker run -i -t centos /bin/bash
	[root@96c974e9fcb6 /]# 

在容器中进行修改

	$[root@96c974e9fcb6 /]#	yum install vim -y

完成后使用exit退出，现在容器已经被修改，产生一个中间态。但是尚未保存到image中，此时使用上面的命令再次运行容器，仍然是从未修改的image运行一个容器，即修改未生效。
所以我们要使用如下的命令提交修改，并生成一个新的image:

	$ docker commit -m "xxx changed" -a "89ao" 96c974e9fcb6 centos/test:1
	e7403d481716ec871a2cecdd287c619eb24524f7aa5e45dc3f3e524416a7953e

-m 指定提交的信息说明；-a指定提交更新的用户信息;之后是用来创建镜像的容器的 ID；最后指定目标镜像的仓库名和 tag 信息。创建成功后会返回这个镜像的 ID 信息。

此时可以用docker images查看新创建的镜像，并运行之：

	$ docker images
	REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
	centos/test         v1                  589db3192b33        3 seconds ago       224 MB
	centos              latest              8efe422e6104        3 days ago          224 MB
	training/webapp     latest              31fa814ba25a        7 months ago        278.6 MB
	$ docker run -i -t centos/test:v1 /bin/bash
	[root@e4580a698173 /]# 

##2. 利用 Dockerfile 来创建镜像

使用docker commit来扩展一个镜像比较简单，但是不方便在一个团队中分享。我们可以使用docker build来创建一个新的镜像。为此，首先需要创建一个 Dockerfile，包含一些如何创建镜像的指令。

新建一个目录和一个 Dockerfile

	$ mkdir sinatra
	$ cd sinatra
	$ touch Dockerfile

Dockerfile 中每一条指令都创建镜像的一层，例如：

	# This is a comment
	FROM ubuntu:14.04
	MAINTAINER Docker Newbee <newbee@docker.com>
	RUN apt-get -qq update
	RUN apt-get -qqy install ruby ruby-dev
	RUN gem install sinatra

Dockerfile 基本的语法是

    使用#来注释
    FROM指令告诉 Docker 使用哪个镜像作为基础
    接着是维护者的信息
    RUN开头的指令会在创建中运行，比如安装一个软件包，在这里使用 apt-get 来安装了一些软件

编写完成 Dockerfile 后可以使用docker build来生成镜像。

	$ docker build -t="ouruser/sinatra:v2" .

其中-t标记来添加 tag，指定新的镜像的用户信息。 “.” 是 Dockerfile 所在的路径（当前目录），也可以替换为一个具体的 Dockerfile 的路径。

*注意一个镜像不能超过 127 层

此外，还可以利用ADD命令复制本地文件到镜像；用EXPOSE命令来向外部开放端口；用CMD命令来描述容器启动后运行的程序等。例如

	# put my local web site in myApp folder to /var/www
	ADD myApp /var/www
	# expose httpd port
	EXPOSE 80
	# the command to run
	CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]

现在可以利用新创建的镜像来启动一个容器。

	$ docker run -t -i ouruser/sinatra:v2 /bin/bash
	root@8196968dac35:/#

还可以用docker tag命令来修改镜像的标签。

	$ docker tag 5db5f8471261 ouruser/sinatra:devel
	$ docker images ouruser/sinatra
	REPOSITORY          TAG     IMAGE ID      CREATED        VIRTUAL SIZE
	ouruser/sinatra     latest  5db5f8471261  11 hours ago   446.7 MB
	ouruser/sinatra     devel   5db5f8471261  11 hours ago   446.7 MB
	ouruser/sinatra     v2      5db5f8471261  11 hours ago   446.7 MB

*注：更多用法，请参考 [Dockerfile](http://dockerpool.com/static/books/docker_practice/dockerfile/README.html) 章节。

##3. 导出导入镜像

如果要导出镜像到本地文件，可以使用docker save命令。

	$ docker images
	REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
	centos              v1                  c4ff7513909d        5 weeks ago         225.4 MB
	...
	$docker save -o centos_test.tar centos:v1

可以使用docker load从导出的本地文件中再导入到本地镜像库，例如

	$ docker load --input centos_test.tar

或

	$ docker load < centos_test.tar

这将导入镜像以及其相关的元数据信息（包括标签等）。

##4. 移除本地镜像

如果要移除本地的镜像，可以使用docker rmi命令。注意docker rm命令是移除容器。

	$ docker rmi training/sinatra

*注意：在删除镜像之前要先用docker rm删掉依赖于这个镜像的所有容器。

新建并启动

所需要的命令主要为docker run。

	$ docker run -t -i centos:v1 /bin/bash
	root@af8bae53bdd3:/#

其中，-t选项让Docker分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上，-i则让容器的标准输入保持打开。

当利用docker run来创建容器时，Docker 在后台运行的标准操作包括：

    检查本地是否存在指定的镜像，不存在就从公有仓库下载
    利用镜像创建并启动一个容器
    分配一个文件系统，并在只读的镜像层外面挂载一层可读写层
    从宿主主机配置的网桥接口中桥接一个虚拟接口到容器中去
    从地址池配置一个 ip 地址给容器
    执行用户指定的应用程序
    执行完毕后容器被终止

##5. 启动已终止容器

可以利用docker start命令，直接将一个已经终止的容器启动运行。

容器的核心为所执行的应用程序，所需要的资源都是应用程序运行所必需的。除此之外，并没有其它的资源。可以在伪终端中利用ps或top来查看进程信息。

	root@ba267838cc1b:/# ps
	  PID TTY          TIME CMD
	    1 ?        00:00:00 bash
	   11 ?        00:00:00 ps

可见，容器中仅运行了指定的 bash 应用。这种特点使得 Docker 对资源的利用率极高，是货真价实的轻量级虚拟化。

##6. 守护态运行

更多的时候，需要让 Docker 容器在后台以守护态（Daemonized）形式运行。此时，可以通过添加-d参数来实现。

例如下面的命令会在后台运行容器。

	$ docker run -d centos:v1 /bin/sh -c "while true; do echo hello world; sleep 1; done"
	1e5535038e285177d5214659a068137486f96ee5c2e85a4ac52dc83f2ebe4147

容器启动后会返回一个唯一的 id，也可以通过docker ps命令来查看容器信息。

	$ docker ps
	CONTAINER ID  IMAGE         COMMAND               CREATED        STATUS       PORTS NAMES
	1e5535038e28  centos:v1     /bin/sh -c 'while tr  2 minutes ago  Up 1 minute        insane_babbage

要获取容器的输出信息，可以通过docker logs命令。

	$ docker logs insane_babbage
	hello world
	hello world
	hello world
	. . .

##7. 终止容器

可以使用docker stop来终止一个运行中的容器。

此外，当Docker容器中指定的应用终结时，容器也自动终止。 例如对于上一章节中只启动了一个终端的容器，用户通过exit命令或Ctrl+d来退出终端时，所创建的容器立刻终止。

终止状态的容器可以用docker ps -a命令看到。例如

	docker ps -a
	CONTAINER ID        IMAGE                    COMMAND                CREATED             STATUS                          PORTS               NAMES
	ba267838cc1b        centos:v1                "/bin/bash"            30 minutes ago      Exited (0) About a minute ago                       trusting_newton
	98e5efa7d997        training/webapp:latest   "python app.py"        About an hour ago   Exited (0) 34 minutes ago                           backstabbing_pike

处于终止状态的容器，可以通过docker start命令来重新启动。

此外，docker restart命令会将一个运行态的容器终止，然后再重新启动它。

##8. attach 命令进入容器

docker attach是Docker自带的命令。下面示例如何使用该命令。

	$ docker run -idt centos
	243c32535da7d142fb0e6df616a3c3ada0b8ab417937c853a9e1c251f499f550
	$ docker ps
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
	243c32535da7        centos:latest       "/bin/bash"         18 seconds ago      Up 17 seconds                           nostalgic_hypatia
	$docker attach nostalgic_hypatia
	root@243c32535da7:/#

但是使用attach命令有时候并不方便。当多个窗口同时 attach 到同一个容器的时候，所有窗口都会同步显示。当某个窗口因命令阻塞时,其他窗口也无法执行操作了。

##9. 导出和导入容器

导出容器

如果要导出本地某个容器，可以使用docker export命令。

	$ docker ps -a
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                    PORTS               NAMES
	7691a814370e        centos:v1           "/bin/bash"         36 hours ago        Exited (0) 21 hours ago                       test
	$ docker export 7691a814370e > centos.tar

这样将导出容器快照到本地文件。

导入容器快照

可以使用docker import从容器快照文件中再导入为镜像，例如

	$ cat centos.tar | docker import - test/centos:v1.0
	$ docker images
	REPOSITORY          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
	test/centos         v1.0                9d37a6082e97        About a minute ago   171.3 MB

此外，也可以通过指定 URL 或者某个目录来导入，例如

	$docker import http://example.com/exampleimage.tgz example/imagerepo

*注：用户既可以使用docker load来导入镜像存储文件到本地镜像库，也可以使用docker import来导入一个容器快照到本地镜像库。这两者的区别在于容器快照文件将丢弃所有的历史记录和元数据信息（即仅保存容器当时的快照状态），而镜像存储文件将保存完整记录，体积也要大。此外，从容器快照文件导入时可以重新指定标签等元数据信息。

##10. 删除容器

可以使用docker rm来删除一个处于终止状态的容器。 例如

	$docker rm  trusting_newton
	trusting_newton

如果要删除一个运行中的容器，可以添加-f参数。Docker 会发送SIGKILL信号给容器。

