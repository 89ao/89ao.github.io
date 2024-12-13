---
author: pandao
comments: false
date: 2013-08-16 23:31:42+00:00
layout: post
slug: tomcat-production-server-performance-optimization
title: Tomcat 生产服务器性能优化
thread: 240
categories:
- linux
---

**介绍**

试想以下这个情景：你已经开发好了一个程序，这个程序的排版很不错，而且有着最前沿的功能和其他一些让你这程序增添不少色彩的元素。可惜的是，程序的性能不怎么地。你也十分清楚，若现在把这款产品退出市场，肯定会给客户骂得狗血淋头。因为不管样子多么好看，性能才是客户们最需要的。如果你在软件实际运行中使用了Tomcat服务器，那么这篇文章将能让你学到一些能提高Tomcat服务器性能的方法。在此我先得感谢 [ITWorld article](http://www.itworld.com/networking/83035/tomcat-performance-tuning-tips)提供的资源。我仔细地衡量了一下，觉得最新版的Tomcat和之前的版本相比，在性能跟稳定性都有所提高，所以大家都去用最新版吧。在这篇文章里分以下的七个步骤，按照这些步骤走，Tomcat服务器的性能就能改善哦。



	
  1. 增加JVM堆（heap）

	
  2. 解决内存泄漏问题

	
  3. 线程池（thread pool）的设置

	
  4. 压缩

	
  5. 调节数据库性能

	
  6. Tomcat原生库（native library）

	
  7. 其他选项












**第一步  – 提高JVM栈内存Increase JVM heap memory**

你使用过tomcat的话，简单的说就是“内存溢出”. 通常情况下，这种问题出现在实际的生产环境中.产生这种问题的原因是tomcat使用较少的内存给进程,通过配置TOmcat的配置文件(Windows 下的catalina.bat或Linux下的catalina.sh)可以解决这种问题.这种解决方法是通过增加JVM的栈内存实现的.也就是说，JVM通常不去调用垃圾回收器，所以服务器可以更多关注处理web请求，并要求尽快完成。要更改文件(catalina.sh) 位于"\tomcat server folder\bin\catalina.sh"，下面，给出这个文件的配置信息，


	JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8
	-server -Xms1024m -Xmx1024m
	-XX:NewSize=512m -XX:MaxNewSize=512m -XX:PermSize=512m
	-XX:MaxPermSize=512m -XX:+DisableExplicitGC"



-Xms – 指定初始化时化的栈内存
-Xmx – 指定最大栈内存
在重启你的Tomcat服务器之后，这些配置的更改才会有效。下面将介绍如何处理JRE**内存泄漏**.



**第2步 - 解决JRE内存泄漏**

另一个影响Tomcat 性能的因素是内存泄露,就像我前面提及的,可以通过更新到最新版本的Tomcat来获得较好性能和可扩展性.现在这句话将成为事实。如果我们使用最新的 tomcat 服务器版本[6.0.26 ](http://tomcat.apache.org/download-60.cgi)或更高版本，可以解决此类错误。因为它包含一个{敏感词}来处理 JRE 和 permgen 内存泄漏。这里使用的{敏感词}是，




	<Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />





你可以找到上述{敏感词}类配置文件 server.xml 在"tomcat project folder/conf/server.xml"中的。下一步我们将介绍如何调整连接器属性"maxThreads"



**第三步 – 线程池设置**

线程池指定Web请求负载的数量，因此，为获得更好的性能这部分应小心处理。可以通过调整连接器属性“maxThreads”完成设置。maxThreads的值应该根据流量的大小，如果值过低，将有没有足够的线程来处理所有的请求，请求将进入等待状态，只有当一个的处理线程释放后才被处理；如果设置的太大，Tomcat的启动将花费更多时间。因此它取决于我们给maxThreads设置一个正确的值。



	<Connector port="8080" address="localhost"
	maxThreads="250" maxHttpHeaderSize="8192"
	emptySessionPath="true" protocol="HTTP/1.1"
	enableLookups="false" redirectPort="8181" acceptCount="100"
	connectionTimeout="20000" disableUploadTimeout="true" />






在上述配置中，maxThreads值设定为“250”，这指定可以由服务器处理的并发请求的最大数量。如果没有指定，这个属性的默认值为“200”。任何多出的并发请求将收到“拒绝连接”的错误提示，直到另一个处理请求进程被释放。错误看起来如下，


	org.apache.tomcat.util.threads.ThreadPool logFull SEVERE: All threads (250) are
	currently busy, waiting. Increase maxThreads (250) or check the servlet status




如果应用提示上述错误，务必检查上述错误是否是由于单个请求花费太长时间造成的，这个问题的原因是这样的，有时候如果数据库连接不释放的话，进程将不会处理其它请求。



**注意: **如果请求的数量超过了“750”，这将不是意味着将maxThreads属性值设置为“750”，它意外着最好使用“Tomcat集群”的多个实例。也就是说，如果有“1000”请求，两个Tomcat实例设置“maxThreads= 500”，而不在单Tomcat实例的情况下设置maxThreads=1000。

根据我的经验，准确值的设定可以通过将应用在在各种环境中测试得出。接下来，我们来看看如何压缩的MIME类型。



**第4步- 压缩**

Tomcat有一个通过在server.xml配置文件中设置压缩的选项。压缩可以在connector像如下设置中完成，



	<Connector port="8080" protocol="HTTP/1.1"
	connectionTimeout="20000"
	redirectPort="8181" compression="500"
	compressableMimeType="text/html,text/xml,text/plain,application/octet-stream" />





在前面的配置中，当文件的大小大于等于500bytes时才会压缩。如果当文件达到了大小但是却没有被压缩，那么设置属性compression="on"。否则Tomcat默认设置是“off”。接下来我们将看看如何调优数据库。









**第五步- 数据库性能调优**

Tomcat性能在等待数据库查询被执行期间会降低。如今大多数应用程序都是使用可能包含“命名查询”的关系型数据库。如果是那样的话，Tomcat会在启动时默认加载命名查询，这个可能会提升性能。另一件重要事是确保所有数据库连接正确地关闭。给数据库连接池设置正确值也是十分重要的。我所说的值是指Resource要素的最大空闲数（maxIdle），最大连接数（maxActive）,最大建立连接等待时间（maxWait）属性的值。因为配置依赖与应用要求，我也不能在本文指定正确的值。你可以通过调用数据库性能测试来找到正确的值。



**第6步 – Tomcat原生库**

Tomcat的原生库基于Apache可移植运行时（Apache Portable Runtime简称APR），给程序员提供了超强的扩展性和性能，在产品运作中帮助融合原生的服务器技术以展现最佳的性能。想知道安装说明的朋友请参考[Tomcat Native Library – (APR) Installation](http://www.techbrainwave.com/?p=1017)。

**第7步 – 其他选项**

这些选项是：



	
  * 开启浏览器的缓存，这样读取存放在webapps文件夹里的静态内容会更快，大大推动整体性能。

	
  * 每当开机时，Tomcat服务器应当自动地重启。

	
  * 一般情况下HTTPS请求会比HTTP请求慢。如果你想要更好的安全性，即使慢一点我们还是要选择HTTPS。


### 





就这么多啦。在这篇文章里，我教给了大家一些提高Tomcat服务器性能的方法。如果你觉得这篇文章有用，或者你对提高Tomcat服务器性能有别的看法，请不要忘记留下宝贵的评论。祝你今天编程愉快！




### 英文原文：[Tomcat Production Server – Performance Tuning](http://www.techbrainwave.com/?p=836)



