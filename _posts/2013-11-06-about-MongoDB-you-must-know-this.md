---
layout: post
title: "关于MongoDB你需要知道的几件事"
categories:
- Database
tags:
- MongoDB


---

Henrique Lobo Weissmann是一位来自于巴西的软件开发者，他是itexto公司的联合创始人，这是一家咨询公司。近日，Henrique在博客上撰文谈到了关于MongoDB的一些内容，其中有些观点值得我们，特别是正在和打算使用MongoDB的开发者关注。

到目前为止，MongoDB在巴西是最为流行的NoSQL数据库（至少根据关于MongoDB的博客数量以及文章所判断）。MongoDB是个非常棒的解决方案，不过困扰我们的是很少有人了解过关于它的一些限制。这样的事情正在不断上演：人们看到MongoDB的限制，心里却认为这些是它的Bug。

本文列举了颇让作者困惑的一些MongoDB限制，如果你也打算使用MongoDB，那么至少要提前了解这些限制，以免遇到的时候措手不及。

**消耗磁盘空间**

>这是我的第一个困惑：MongoDB会消耗太多的磁盘空间了。当然了，这与它的编码方式有关，因为MongoDB会通过预分配大文件空间来避免磁盘碎片问题。它的工作方式是这样的：在创建数据库时，系统会创建一个名为[db name].0的文件，当该文件有一半以上被使用时，系统会再次创建一个名为[db name].1的文件，该文件的大小是方才的两倍。这个情况会持续不断的发生，因此256、512、1024、2048大小的文件会被写到磁盘上。最后，再次创建文件时大小都将为2048Mb。如果存储空间是项目的一个限制，那么你必须要考虑这个情况。该问题有个商业解决方案，名字叫做[TokuMX](http://www.tokutek.com/products/tokumx-for-mongodb/)，使用后存储消耗将会减少90%。此外，从长远来看，repairDatabase与compact命令也会在一定程度上帮到你。

**通过复制集实现的数据复制效果非常棒，不过也有限制**

>MongoDB中数据复制的复制集策略非常棒，很容易配置并且使用起来确实不错。但如果集群的节点有12个以上，那么你就会遇到问题。MongoDB中的复制集有12个节点的限制，这里是问题的描述，你可以追踪这个问题看看是否已经被解决了。

**主从复制不会确保高可用性**

>尽管已经不建议被使用了，不过MongoDB还是提供了另外一种复制策略，即主从复制。它解决了12个节点限制问题，不过却产生了新的问题：如果需要改变集群的主节点，那么你必须得手工完成，感到惊讶？看看这个[链接](http://docs.mongodb.org/manual/core/master-slave/)吧。

**不要使用32位版本**

>MongoDB的32位版本也是不建议被使用的，因为你只能处理2GB大小的数据。还记得第一个限制么？这是MongoDB关于该限制的[说明](http://blog.mongodb.org/post/137788967/32-bit-limitations)。

**咨询费非常非常昂贵（至少对于巴西的开发者与公司来说如此）**

>我不清楚其他国家的情况，不过至少在巴西MongoDB的咨询费是个天价。对于“[Lightning Consult](https://www.mongodb.com/products/consulting/lightning-consult)”计划来说，每小时的价格是450美金，而你至少需要购买两个小时的，换句话说，对于任何一家公司来说，每次咨询的价格至少是900美金。相比于RedHat和Oracle来说，这个价格太高了。

**差劲的管理工具**

>这对于初学者来说依然是个让人头疼的问题，MongoDB的管理控制台太差劲了。我所知道的最好的工具是[RoboMongo](http://robomongo.org/)，它对于那些初次使用的开发者来说非常趁手。

**了解官方的限制**

>让我感到惊讶的是，很少有人会查询关于他们将要使用的工具的限制。幸好，MongoDB的开发人员发布了一篇MongoDB所有限制的[博客](http://docs.mongodb.org/manual/reference/limits/)，你可以提前了解相关信息，避免在使用过程中难堪。

各位读者，现在使用MongoDB的公司也越来越多了，不妨与大家分享你在使用这个NoSQL数据库时的一些经验与教训。

via [InfoQ](http://www.infoq.com/cn/news/2013/11/mongodb-things)
