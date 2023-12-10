##### curl
```shell
# 自定义请求 Header
--header / -H

# 携带 cookie 请求
--cookie 或 -b 参数

# 详细输出请求信息
-v

# 代理请求
-x, --proxy [protocol://]host[:port]

# 测试服务端支持的 TLS 版本
curl https://google.com -kv --tlsv1 --tls-max 1.0
curl https://google.com -kv --tlsv1.3 --tls-max 1.3

# 指定 DNS 解析 IP 请求
curl https://google.com --resolve google.com:443:1.1.1.1 -v

# 验证 ssl 证书
openssl s_client -servername your.domain.com -connect 127.0.0.1:443


# 模拟 websocket 请求
curl http://127.0.0.1:9999 -H 'Upgrade: websocket' -H 'Connection: Upgrade' -H'Sec-WebSocket-Key: eeZn6lg/rOu8QbKwltqHDA==' -H'Sec-WebSocket-Version: 13'

# timing
curl -L -w "time_namelookup: %{time_namelookup}\ntime_connect: %{time_connect}\ntime_appconnect: %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect: %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}\n" https://example.com/
###
time_namelookup: %{time_namelookup}
time_connect: %{time_connect}
time_appconnect: %{time_appconnect}
time_pretransfer: %{time_pretransfer}
time_redirect: %{time_redirect}
time_starttransfer: %{time_starttransfer}
time_total: %{time_total}
###

```

##### openssl
```shell
# install 
apt install openssl

# get crt info
openssl x509 -dates -text -noout -in xxx.crt

```

##### sar
```shell
# install 
apt install sysstat
# use
sar [options] [delay [count]]
sar -r 1 10

# cpu 
-u     Report CPU utilization
-q     Report queue length and load averages
-P (cpu_list|ALL)    Report per-processor statistics for the specified processor or processors
-w     Report task creation and system switching activity

# memory
-r     Report memory utilization statistics
-S     Report swap space utilization statistics
-W     Report swapping statistics

# network 
-n (DEV|ICMP|IP|SOCK|TCP|UDP)   Report network statistics

# I/O statistics
-b     Report I/O and transfer rate statistics
-d     Report activity for each block device 
-p     Pretty-print device names

# others
-v     Report status of inode, file and other kernel tables
-y     Report TTY devices activity
-o | -f [filename]

```

##### strace
```shell
# install 
apt install sysstat

#
strace -c ls

```

##### systemd
```shell
# journalctl
# tailf and unit log
journalctl -u prometheus.service -f

```

##### systemtap
```shell
# install
apt install systemtap

# example 
tee helloword.stp << "EOF"
probe begin
{
  print ("hello world\n")
  exit ()
}
EOF
stap hellword.stp

# network monitor
tee tcp.stp << "EOF"
#!/usr/bin/env stap
probe syscall.connect {
if(uaddr_ip_port=="443"){
    printf("ip: %s port: %s cmd: %s pid: %d ppid: %d\n", uaddr_ip, uaddr_ip_port, execname(), pid(), ppid())
}

if(uaddr_ip_port=="1521"){
    printf("Time:%s remote_ip:%s remote_port:%s local_cmd:%s pid:%d local_pcmd:%s ppid:%d euid:%d egid:%d env_PWD:%s  \n",
       tz_ctime(gettimeofday_s()),uaddr_ip, uaddr_ip_port,execname(),pid(),pexecname(),ppid(),euid(),egid(),env_var("PWD"))
}

}
EOF
stap -v tcp.stp


# get container pid info
tee sg.stp << "EOF"
global target_pid = 7942
probe signal.send{
  if (sig_pid == target_pid) {
    printf("%s(%d) send %s to %s(%d)\n", execname(), pid(), sig_name, pid_name, sig_pid);
    printf("parent of sender: %s(%d)\n", pexecname(), ppid())
    printf("task_ancestry:%s\n", task_ancestry(pid2task(pid()), 1));
  }
}
EOF
stap -v sg.stp

```

##### trap
```shell
# 捕获 ctrl+c 信号，执行对应命令，只生效于当前环境
trap "exit" SIGINT
trap "echo 'Received SIGINT signal'" SIGINT

# 忽略信号
trap "" SIGINT

# 恢复默认信号处理方式
trap - SIGINT


```

##### vmstat
```shell
# install
apt install procps
# use
vmstat [options] [delay [count]]


# probe uninterrupted every 2 seconds
vmstat 2
# probe 10 times per second
vmstat 1 10


# Displays a table of various event counters and memory statistics
vmstat -s
# The -f switch displays the number of forks since boot
vmstat -f
# Report disk statistics
vmstat -d -t 

# 
vmstat -ant 1

```



> 1. [Official systemtap Doc](https://sourceware.org/systemtap/documentation.html)
> 2. [Ubuntu Install systemtap](https://wiki.ubuntu.com/Kernel/Systemtap#Systemtap_Installation)
> 3. [IBM Documentation](https://www.ibm.com/docs/zh/power9/9080-M9S?topic=commands-vmstat-command)
> 4. [timeing-with-curl](https://susam.net/blog/timing-with-curl.html