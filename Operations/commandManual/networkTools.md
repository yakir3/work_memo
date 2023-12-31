##### ab && wrk
```shell
# install ab
apt install apache2-utils
# use
ab -n 1000 -c 100 http://www.baidu.com


# install wrk
# http://github.com/wg/wrk.git
# use
# -t threads
# -c connections to keep open
# -d duration
wrk -t 100 -c 10000 -d 30 --latency http://www.google.com/

```

##### arp && arping
```shell
# install
apt install net-tools
apt install arping

# select arp table
arp -ne 
-e                       display (all) hosts in default (Linux) style
-n, --numeric            don\'t resolve names

# arping
arping 192.168.1.100
-c count
-i interface
-s MAC
-S IP
# get packets
tcpdump -ttttnvvvS -i ens160 arp 

```

##### dig
```shell
# select external local DNS address
dig xxx.debug.danuoyi.tbcache.com 

```

##### hping3
```shell
# install 
apt install hping3

# imitate syn flood
hping3 -S -p 8877 --flood 127.0.0.1


```

##### iftop
```shell
# iptop -h
   -n                  dont do hostname lookups
   -N                  dont convert port numbers to services
   -i interface        listen on named interface
   -t                  use text interface without ncurses
   Sorting orders:
   -o 2s                Sort by first column (2s traffic average)
   -o 10s               Sort by second column (10s traffic average) [default]
   -o 40s               Sort by third column (40s traffic average)
   -o source            Sort by source address
   -o destination       Sort by destination address
   The following options are only available in combination with -t
   -s num              print one single text output afer num seconds, then quit
   -L num              number of lines to print


# common
iftop -nN -i ens4 -o 10s
iftop -nN -s 5 -t
iptop -nN -L 5 -t
iftop -F 192.168.1.0/24


# inside keyboard keys
Host display:                          General:
 n - toggle DNS host resolution         P - pause display
 s - toggle show source host            h - toggle this help display
 d - toggle show destination host       b - toggle bar graph display
 t - cycle line display mode            B - cycle bar graph average
                                        T - toggle cumulative line totals
Port display:                           j/k - scroll display
 N - toggle service resolution          f - edit filter code
 S - toggle show source port            l - set screen filter
 D - toggle show destination port       L - lin/log scales
 p - toggle port display                ! - shell command
                                        q - quit
Sorting:
 1/2/3 - sort by 1st/2nd/3rd column
 < - sort by source name
 > - sort by dest name
 o - freeze current order

```

##### ip
```shell
# apt install iproute2

# select route table
ip route ls
# select info
ip addr ls
ip link ls

# add ip to tun0，do not conflict other link
ip addr add 172.31.0.1/24 dev tun0
# startup tun0 link and add route table to 172.31.0.1/24
ip link set tun0 up


### namespace 
# select namespace list
ip netns list
# add netns(in /var/run/netns/)
ip netns add net-yakir1
# exec in netns
ip netns exec net-yakir1 ip addr
# ip netns exec ns1 /bin/bash --rcfile <(echo "PS1=\"namespace net-yakir1> \"")
ip netns exec net-yakir1 ip link set lo up

# veth pair 
# execute in host
ip link add br0 type bridge
ip link set dev br0 up
ip netns add net0
ip netns add net1
ip link add veth-a0 type veth peer name veth-net0
ip link set dev veth-net0 master br0
ip link set dev veth-net0 up
ip link add veth-b0 type veth peer name veth-net1
ip link set dev veth-net1 master br0
ip link set dev veth-net1 up

# execute in net0
ip link set dev veth-a0 netns net0
ip netns exec net0 ip link set dev veth-a0 name eth0
ip netns exec net0 ip addr add 10.0.1.2/24 dev eth0
ip netns exec net0 ip link set dev eth0 up
# execute in net1
ip link set dev veth-b0 netns net1
ip netns exec net1 ip link set dev veth-b0 name eth0
ip netns exec net1 ip addr add 10.0.1.3/24 dev eth0
ip netns exec net1 ip link set dev eth0 up
# verify
ip netns exec net0 ping -c 3 10.0.1.3


```

##### netstat && ss
```shell
# netstat = apt install net-tools 
# count all tcp state number
netstat -tna | awk '/tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'


#####
#####
# ss = apt install iproute2
# count all tcp state number
ss -na | awk '/tcp/ {++S[$2]} END {for(a in S) print a, S[a]}'

# select all tcp connect
ss -tnap

# force kill tcp connect
ss -K dst 1.1.1.1 dport = 57156



```

##### nc && netcat
```shell
# install 
apt install netcat-openbsd

# listen and test
nc -l 9999 -k -c 'xargs -n1 echo'

# post 
echo -e "POST /post HTTP/1.1\r\nHost: httpbin.org\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 7\r\n\r\na=1&b=2\r\n" |nc 172.22.3.29 8877

```

##### tcpdump
```shell
# install
apt install tcpdump


# Listen on interface
-i interface
# Don't convert address
-n
# Print absolute, rather than relative, TCP sequence numbers
-S
# Don't print a timestamp on each dump line
-t
# Print the timestamp, as seconds since January 1, 1970, 00:00:00, UTC
-tt
# Print a delta (micro-second resolution) between current and previous line on each dump line
-ttt
# Print a timestamp, as hours, minutes, seconds, and fractions of a second since midnight, preceded by the date, on each dump line
-tttt
# Print a delta (micro-second resolution) between current and first line on each dump line.
-ttttt
# Even more verbose output
-v
-vv
-vvv
# Write the raw packages to file
-w file


# rotate every 100M and reserved 20
tcpdump -i eth0 port 8880 -w cvm.pcap -C 100 -W 20
# rotate every 120s and suffix
tcpdump -i eth0 port 31780 -w node-%Y-%m%d-%H%M-%S.pcap -G 120

# protocol
tcpdump [ip|tcmp|tcp|udp]
tcpdump 'tcp[tcpflags] & (tcp-syn|tcp-fin) != 0'
tcpdump -i ens4 -nStttv icmp and src 1.1.1.1

# source ip or dest ip 
tcpdump src 1.1.1.1 or dst 1.1.1.1 

# port 
tcpdump not port 80

# fileter timeout packet
tcpdump -r test.pcap 'tcp[tcpflags] & (tcp-rst) != 0' -nttt

# example
tcpdump -i eth0 -nStttvvv src 1.1.1.1 or dst 1.1.1.1 and port 80

```

##### tcpkill
```shell
# install
apt install dsniff

tcpkill -i <interface> host <destination_ip> and port <destination_port>
# example
tcpkill -i lo host 127.0.0.1 and port 

```


