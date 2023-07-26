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

# select link info
ip addr ls

# add ip to tun0，do not conflict other link
ip addr add 172.31.0.1/24 dev tun0
# startup tun0 link and add route table to 172.31.0.1/24
ip link set tun0 up


```