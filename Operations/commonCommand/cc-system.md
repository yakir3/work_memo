#### iptables
##### introduction

![[iptables.png]]

##### command
```shell
# --list-rules 以命令的形式查看所有规则
iptables -S

# --list-rules 查看 INPUT 表中的所有规则
iptables -S INPUT

# -L 表示查看当前表的所有规则，相比 -S 它的显示效果要更 human-readable
# -n 表示不对 IP 地址进行反查，一般都不需要反查
iptables -nL

# 查看其他表的规则，如 nat 表
iptables -t nat -S
iptables -t nat -nL

# --add 允许 80 端口通过
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# ---delete 通过编号删除规则
iptables -D 1
# 或者通过完整的规则参数来删除规则
iptables -D INPUT -p tcp --dport 80 -j ACCEPT

# --replace 通过编号来替换规则内容
iptables -R INPUT 1 -s 192.168.0.1 -j DROP

# --insert 在指定的位置插入规则，可类比链表的插入
iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT

# 在匹配条件前面使用感叹号表示取反
# 如下规则表示接受所有来自 docker0，但是目标接口不是 docker0 的流量
iptables -A FORWARD -i docker0 ! -o docker0 -j ACCEPT

# --policy 设置某个链的默认规则
# 很多系统管理员会习惯将连接公网的服务器，默认规则设为 DROP，提升安全性，避免错误地开放了端口。
# 但是也要注意，默认规则设为 DROP 前，一定要先把允许 ssh 端口的规则加上，否则就尴尬了。
iptables -P INPUT DROP

# 清空系统 INPUT 链
iptables -F INPUT
# 清空自定义链
iptables -X 
```


#### journalctl
```shell
# tailf and unit log
journalctl -u prometheus.service -f

```



#### others
```shell
# add share lib search
# option1 for tmp 
LD_LIBRARY_PATH=/opt/pgsql/lib
export LD_LIBRARY_PATH
# option2 for persistent
echo "/opt/pgsql/lib" >> /etc/ld.so.conf.d/pgsql.conf
ldconfig


# add env and man path
# option1 for tmp
PATH=/usr/local/pgsql/bin:$PATH
export PATH
MANPATH=/usr/local/pgsql/share/man:$MANPATH
export MANPATH
# option2 for persistent
echo "PATH=/usr/local/pgsql/bin:$PATH" >> ~/.bashrc
source ~/.bashrc


# free vm memory
# 0：不释放（系统默认值）
# 1：释放页缓存
# 2：释放 dentries 和 inodes
# 3：释放所有缓存
# 释放完内存后将值改为0让系统重新自动分配内存
echo 0 > /proc/sys/vm/drop_caches


# position 
$#               # args len
${[*]}  ${[@]}   # foreach list
$*   # args list, when use "", all parameter as one world
$@   # args list


# truncate string
variable="Hello World"
echo "${variable#He}"   # output: llo World
echo "${variable%ld}"   # output: Hello Wor
echo "${variable:3:5}"  # output: lo Wo
echo "${variable#*o}"   # output: rld
echo "${#variable}"     # length
variable="path/to/some/file.txt"
result="${variable##*/}"   # longest match from start, get: file.txt
variable="path/to/some/file.txt"
result="${variable%%/*}"   # longest match from end, get: path
```

