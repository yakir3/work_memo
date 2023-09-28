#### systemd
```shell
# journalctl
# tailf and unit log
journalctl -u prometheus.service -f

```


#### systemtap
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


#### trap
```shell
# 捕获 ctrl+c 信号，执行对应命令，只生效于当前环境
trap "exit" SIGINT
trap "echo 'Received SIGINT signal'" SIGINT

# 忽略信号
trap "" SIGINT

# 恢复默认信号处理方式
trap - SIGINT


```



> 1. [Official systemtap Doc](https://sourceware.org/systemtap/documentation.html)
> 2. [Ubuntu Install systemtap](https://wiki.ubuntu.com/Kernel/Systemtap#Systemtap_Installation)