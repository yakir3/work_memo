
timewait 连接数

ip_conntrack 表 full

内网 arpPing 表缓冲



#### ulimit
/etc/security/limits.conf
```shell
#<domain>      <type>  <item>         <value>
# max number of processes
*        soft    noproc 655350
*        hard    noproc 655350
# max number of open file descriptors
*        soft    nofile 655350
*        hard    nofile 655350

```


#### sysctl
/etc/sysctl.conf
/etc/sysctl.d/\*.conf
/proc/sys/...
```shell
# Controls the System Request debugging functionality of the kernel
kernel.sysrq = 0
# Controls whether core dumps will append the PID to the core filename.
# Useful for debugging multi-threaded applications.
kernel.core_uses_pid = 1
# Controls the default maxmimum size of a mesage queue
kernel.msgmnb = 65536
# # Controls the maximum size of a message, in bytes
kernel.msgmax = 65536
# Controls the maximum shared segment size, in bytes
kernel.shmmax = 68719476736
# Controls the maximum number of shared memory segments,in pages
kernel.shmall = 4294967296

# system open files
fs.file-max = 655350

# Controls source route verification
net.ipv4.conf.default.rp_filter = 1
net.ipv4.ip_nonlocal_bind = 1
net.ipv4.ip_forward = 1
# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0
# Controls the use of TCP syncookies
net.ipv4.tcp_syncookies = 1
# Disable netfilter on bridges.
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0


# TCP kernel paramater
net.ipv4.tcp_mem = 786432 1048576 1572864
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_sack = 1
# socket buffer
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_abort_on_overflow = 0    # 全连接队列满时内核行为 = 0为丢弃，1为reset
net.core.somaxconn = 65535    # 全连接队列 = min(backlog, somaxconn)
net.core.optmem_max = 81920
# TCP conn
net.ipv4.tcp_max_syn_backlog = 262144    # 半连接队列 = (backlog, tcp_max_syn_backlog, somaxconn)
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 15
# tcp conn reuse
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_max_tw_buckets = 20000
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syncookies = 1    # 不使用半连接队列建立连接 = 0为不开启，1为仅半连接队列满时启用，2为直接启用
# keepalive conn
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.ip_local_port_range = 10001 65000


# swap
vm.overcommit_memory = 0
vm.swappiness = 10   # default 60, 0 is donot swap memory
#net.ipv4.conf.eth1.rp_filter = 0
#net.ipv4.conf.lo.arp_ignore = 1
#net.ipv4.conf.lo.arp_announce = 2
#net.ipv4.conf.all.arp_ignore = 1
#net.ipv4.conf.all.arp_announce = 2
```
