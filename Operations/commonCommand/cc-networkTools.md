##### ab && wrk
```shell
# apt install apache2-utils
ab -n 1000 -c 100 http://www.baidu.com

# http://github.com/wg/wrk.git
wrk -t 100 -c 10000 -d 30 --latency http://www.google.com/

```


##### tcpdump
```shell
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

# protocol
tcpdump [ip|tcmp|tcp|udp]
tcpdump 'tcp[tcpflags] & (tcp-syn|tcp-fin) != 0'

# source ip and dest ip 
tcpdump src 1.1.1.1 or dst 1.1.1.1 

# port 
tcpdump not port 80


tcpdump -i eth0 -nStttvvv src 1.1.1.1 or dst 1.1.1.1 and port 80

```

##### ncat
```shell
# listen and test
ncat -l 9999 -k -c 'xargs -n1 echo'
```

##### iproute2
```shell
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
