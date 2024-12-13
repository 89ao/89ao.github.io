---
layout: post
title: "docker数据交互与网络配置"
categories:
- Linux
tags:
- docker


---

##1. 挂载一个主机目录作为数据卷

使用-v标记也可以指定挂载一个本地主机的目录到容器中去。

	$ sudo docker run -d -P --name web -v /src/webapp:/opt/webapp training/webapp python app.py

上面的命令加载主机的/src/webapp目录到容器的/opt/webapp目录。这个功能在进行测试的时候十分方便，比如用户可以放置一些程序到本地目录中，来查看容器是否正常工作。本地目录的路径必须是绝对路径，如果目录不存在 Docker 会自动为你创建它。

*注意：Dockerfile 中不支持这种用法，这是因为 Dockerfile 是为了移植和分享用的。然而，不同操作系统的路径格式不一样，所以目前还不能支持。

Docker 挂载数据卷的默认权限是读写，用户也可以通过:ro指定为只读。

	$ sudo docker run -d -P --name web -v /src/webapp:/opt/webapp:ro
	training/webapp python app.py

加了:ro之后，就挂载为只读了。

##2. 数据卷容器

如果你有一些持续更新的数据需要在容器之间共享，最好创建数据卷容器。

数据卷容器，其实就是一个正常的容器，专门用来提供数据卷供其它容器挂载的。

首先，创建一个命名的数据卷容器 dbdata：

	$ sudo docker run -d -v /dbdata --name dbdata training/postgres echo Data-only container for postgres

然后，在其他容器中使用--volumes-from来挂载 dbdata 容器中的数据卷。

	$ sudo docker run -d --volumes-from dbdata --name db1 training/postgres
	$ sudo docker run -d --volumes-from dbdata --name db2 training/postgres

还可以使用多个--volumes-from参数来从多个容器挂载多个数据卷。 也可以从其他已经挂载了容器卷的容器来挂载数据卷。

	$ sudo docker run -d --name db3 --volumes-from db1 training/postgres

*注意：使用--volumes-from参数所挂载数据卷的容器自己并不需要保持在运行状态。
如果删除了挂载的容器（包括 dbdata、db1 和 db2），数据卷并不会被自动删除。如果要删除一个数据卷，必须在删除最后一个还挂载着它的容器时使用docker rm -v命令来指定同时删除关联的容器。 这可以让用户在容器之间升级和移动数据卷。

##3. 外部访问容器

容器中可以运行一些网络应用，要让外部也可以访问这些应用，可以通过-P或-p参数来指定端口映射。

当使用 -P 标记时，Docker 会随机映射一个49000~49900的端口到内部容器开放的网络端口。

使用docker ps可以看到，本地主机的 49155 被映射到了容器的 5000 端口。此时访问本机的 49115 端口即可访问容器内 web 应用提供的界面。

	$ sudo docker run -d -P training/webapp python app.py
	$ sudo docker ps -l
	CONTAINER ID  IMAGE                   COMMAND       CREATED        STATUS        PORTS                    NAMES
	bc533791f3f5  training/webapp:latest  python app.py 5 seconds ago  Up 2 seconds  0.0.0.0:49155->5000/tcp  nostalgic_morse

同样的，可以通过docker logs命令来查看应用的信息。

	$ sudo docker logs -f nostalgic_morse
	* Running on http://0.0.0.0:5000/
	10.0.2.2 - - [23/May/2014 20:16:31] "GET / HTTP/1.1" 200 -
	10.0.2.2 - - [23/May/2014 20:16:31] "GET /favicon.ico HTTP/1.1" 404 -

-p（小写的）则可以指定要映射的端口，并且，在一个指定端口上只可以绑定一个容器。支持的格式有ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort。

映射所有接口地址

使用hostPort:containerPort格式本地的 5000 端口映射到容器的 5000 端口，可以执行

	$ sudo docker run -d -p 5000:5000 training/webapp python app.py

此时默认会绑定本地所有接口上的所有地址。

映射到指定地址的指定端口

可以使用ip:hostPort:containerPort格式指定映射使用一个特定地址，比如 localhost 地址 127.0.0.1

	$ sudo docker run -d -p 127.0.0.1:5000:5000 training/webapp python app.py

映射到指定地址的任意端口

使用ip::containerPort绑定 localhost 的任意端口到容器的 5000 端口，本地主机会自动分配一个端口。

	$ sudo docker run -d -p 127.0.0.1::5000 training/webapp python app.py

还可以使用 udp 标记来指定 udp 端口

	$ sudo docker run -d -p 127.0.0.1:5000:5000/udp training/webapp python app.py

查看映射端口配置

使用docker port来查看当前映射的端口配置，也可以查看到绑定的地址

	$ docker port nostalgic_morse 5000
	127.0.0.1:49155.

注意：
容器有自己的内部网络和 ip 地址（使用docker inspect可以获取所有的变量，Docker 还可以有一个可变的网络配置。）
-p 标记可以多次使用来绑定多个端口

例如

    $ sudo docker run -d -p 5000:5000  -p 3000:80 training/webapp python app.py

##4. 容器互联

使用--link参数可以让容器之间安全的进行交互。

下面先创建一个新的数据库容器。

	$ sudo docker run -d --name db training/postgres

删除之前创建的 web 容器

	$ docker rm -f web

然后创建一个新的 web 容器，并将它连接到 db 容器

	$ sudo docker run -d -P --name web --link db:db training/webapp python app.py

此时，db 容器和 web 容器建立互联关系。

--link参数的格式为--link name:alias，其中name是要链接的容器的名称，alias是这个连接的别名。

使用docker ps来查看容器的连接

	$ docker ps
	CONTAINER ID  IMAGE                     COMMAND               CREATED             STATUS             PORTS                    NAMES
	349169744e49  training/postgres:latest  su postgres -c '/usr  About a minute ago  Up About a minute  5432/tcp                 db, web/db
	aed84ee21bde  training/webapp:latest    python app.py         16 hours ago        Up 2 minutes       0.0.0.0:49154->5000/tcp  web

可以看到自定义命名的容器，db 和 web，db 容器的 names 列有 db 也有 web/db。这表示 web 容器链接到 db 容器，web 容器将被允许访问 db 容器的信息。

Docker 在两个互联的容器之间创建了一个安全隧道，而且不用映射它们的端口到宿主主机上。在启动 db 容器的时候并没有使用-p和-P标记，从而避免了暴露数据库端口到外部网络上。

Docker 通过 2 种方式为容器公开连接信息：

* 环境变量
* 更新/etc/hosts文件

使用env命令来查看 web 容器的环境变量

	$ sudo docker run --rm --name web2 --link db:db training/webapp env
	. . .
	DB_NAME=/web2/db
	DB_PORT=tcp://172.17.0.5:5432
	DB_PORT_5000_TCP=tcp://172.17.0.5:5432
	DB_PORT_5000_TCP_PROTO=tcp
	DB_PORT_5000_TCP_PORT=5432
	DB_PORT_5000_TCP_ADDR=172.17.0.5
	. . .

其中 DB_ 开头的环境变量是供 web 容器连接 db 容器使用，前缀采用大写的连接别名。

除了环境变量，Docker 还添加 host 信息到父容器的/etc/hosts的文件。下面是父容器 web 的 hosts 文件

	$ sudo docker run -t -i --rm --link db:db training/webapp /bin/bash
	root@aed84ee21bde:/opt/webapp# cat /etc/hosts
	172.17.0.7  aed84ee21bde
	. . .
	172.17.0.5  db

这里有 2 个 hosts，第一个是 web 容器，web 容器用 id 作为他的主机名，第二个是 db 容器的 ip 和主机名。 可以在 web 容器中安装 ping 命令来测试跟db容器的连通。

	root@aed84ee21bde:/opt/webapp# apt-get install -yqq inetutils-ping
	root@aed84ee21bde:/opt/webapp# ping db
	PING db (172.17.0.5): 48 data bytes
	56 bytes from 172.17.0.5: icmp_seq=0 ttl=64 time=0.267 ms
	56 bytes from 172.17.0.5: icmp_seq=1 ttl=64 time=0.250 ms
	56 bytes from 172.17.0.5: icmp_seq=2 ttl=64 time=0.256 ms

用 ping 来测试db容器，它会解析成172.17.0.5。 *注意：官方的 ubuntu 镜像默认没有安装 ping，需要自行安装。

用户可以链接多个子容器到父容器，比如可以链接多个 web 到 db 容器上。 
