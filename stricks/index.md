---
title: 脚本秀-Shell Tricks
layout: page
comments: no

---



此处收集经典好用的Shell技巧，以便查阅分享

闲话不说，Enjoy Shell！~



```shell
find ./ -name '*.md' | awk -F "." '{print $2}' | xargs -i -t git mv ./{}.md ./{}.markdown
```
`find ./ -name '*.md' | awk -F "." '{print $2}' | xargs -i -t git mv ./{}.md ./{}.markdown`

批量修改文件名



```shell
rm -rf !(\*.html)   
```


删除除了\*.html之外的所有文件



```shell
ping -c3 www.tecmint.com && links www.tecmint.com	
```


成功则执行



```shell
apt-get update || links tecmint.com		
```
失败则执行



```shell
python -m SimpleHTTPServer
```
用python生产一个简单的http服务器显示当前目录结构，可以通过浏览器在端口8000访问



```shell
mtr google.com
```
合并ping和traceroute的命令



```shell
nl
```
显示行书的cat(等同于cat -n)



```shell
^foo^bar
```
将上个命令中的foo修改成bar，并执行



```shell
ctrl+r
```
在历史记录中搜索



```powershell
echo "2:12 PM" | at 2:12 PM
```
at命令



```shell
ls -l > /dev/pts/4
```
将命令结果输出到pts/4终端上。



```shell
_command
```
前面加空格符号执行的命令不会记录到history中



```shell
stat stricks.md
```
察看文件或者文件系统的状态信息。



```shell
mount | column -t
```
格式化输出所有挂在的文件系统。



```shell
ctrl+l
```
清理终端，等同于clear



```shell
yes "dum ass"
```
持续输出字符串，直到发出终止信号(和> /dev/pts/4一起用很好玩)



```shell
ping -i 60 -a www.google.com
```
每60sping一次google，一旦连通就发出声音。



```shell
cmatrix
```
这个很酷!黑客帝国矩阵



```shell
${variable:0:5}
```
截取前5个字符



```shell
mkdir -p /home/user/{test,test1,test2}
```
创建多个目录



```shell
dd if=/dev/zero of=/tmp/output.img bs=8k count=256k; rm -rf /tmp/output.img
```
测试硬盘写入速度。



```shell
hdparm -Tt /dev/sda
```
测试硬盘读取速度



```shell
xmllint --noout file.xml
```
检查xml格式



```shell
cp some_file_name{,.bkp}
```
快速备份文件



```shell
watch -d -n 1 ps aux
```
监视ps aux的输出，每秒输出一次，用不同的颜色显示变化的区域。



```shell
mount -o remount,rw /
```
修改挂载参数。



```shell
mount -t tmpfs tmpfs /tmpram -o size=512m
```
创建临时RAM文件系统



```shell
nmap -p 8081 172.20.0.0/16
```
扫描网络寻找开放的端口



```shell
ls | shuf -n1
```
随机选择一个文件名输出



```shell
ssh user@server bash < /path/to/local/script.sh
```
ssh到远程服务器执行一个脚本，此命令可以避免将脚本上传到远程服务器



```shell
ssh user@host cat /path/to/remotefile | diff /path/to/localfile -
```
比较远程文件和本地文件的差异



```shell
vim scp://username@host//path/to/somefile
```
vi一个远程文件



```shell
curl ifconfig.me
```
在内网下查看公网ip



```shell
echo ${#a}
```
取变量字符个数



```shell
tmp_file_name=$(mktemp TMP.XXXXXX)
```
生成一个随机文件名的临时文件。

使用ctrl+n补齐变量名。

---

