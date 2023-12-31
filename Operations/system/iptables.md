#### Introduction
##### Description
iptables(user space 下的工具，调用 netfilter 
netfilter(kernel space 下的 webhook 点)

+ Data packet connection state
NEW
ESTABLISHED
RELATED
INVALID

##### iptables rules
source(1.1.1.1)
destination(2.2.2.2)
匹配数据包后不再继续匹配直接到下一规则链
ACCEPT: 放行数据包
DROP：丢弃数据包
REJECT：拒绝数据包，响应拒绝信息
SNAT：
MASQUERADE
DNAT
RETURN
LOG
MARK
...

##### iptables chains
+ chains property
```textile
PREROUTING
INPUT
FORWARD
OUTPUT
POSTROUTING
```


+ chains priority
```textile
To Localhost: PREROUTING -> INPUT -> OUTPUT -> POSTROUTING
Forward: PREROUTING -> FORWARD -> POSTROUTING
To External: OUTPUT -> POSTROUTING
```


+ packet flow direction
```textile
1. 入站数据包走向
PREROUTING 链处理（是否修改数据包地址等），路由选择 routing decision 为本地，则内核将其传给 INPUT 链处理，如果通过则交给系统上层的应用程序。
2. 转发数据包走向
PREROUTING 链处理，路由选择 routing decision 是其它外部地址，则内核将其传递给 FORWARD 链处理（是否转发或拦截），然后再交给 POSTROUTING 链（是否修改数据包的地址等）处理。
3. 出站数据包走向
本机向外部地址发送的数据包，首先被 OUTPUT 链处理，路由选择 routing decision 后传递给 POSTROUTING 链（是否修改数据包的地址等）进行处理。
```

##### iptables tables
+ tables property
raw
mangle
nat
filter

+ tables chain
raw: PREROUTING, OUTPUT
mangle: PREROUTING, INPUT, FORWARD, OUTPUT, POSTROUTING
nat: PREROUTING, OUTPUT, POSTROUTING
filter: INPUT, FORWARD, OUTPUT

+ tables priority
raw -> mangle -> nat -> filter(default)

#### Command
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



