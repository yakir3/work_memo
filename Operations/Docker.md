#### Introduction
##### Description
```shell
# install docker engine
https://docs.docker.com/engine/install/debian/

```

##### Storage
```shell

```

##### Network
```shell
# 查看 docker 网络信息
docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
b2adc1fcf214   bridge    bridge    local
2ed9fbc8db3e   host      host      local
f1b2d749ed2c   none      null      local

# how to user
# bridge
--net bridge
# host
--net host
# none
--net none
# container
--net container:container_name|container_id

```

###### bridge 网络模式
```shell
# bridge
每个容器拥有独立网络协议栈，为每一个容器分配、设置 IP 等。将容器连接到虚拟网桥（默认为 docker0 网桥）。

# 1.在宿主机上创建 container namespace
xxx

# 2.daemon 进程利用 veth pair 技术，在宿主机上创建一对对等虚拟网络接口设备。veth pair 特性是一端流量会流向另一端。
# 一个接口放在宿主机的 docker0 虚拟网桥上并命名为 vethxxx
# 查看网桥信息
brctl show
bridge name     bridge id               STP enabled     interfaces
docker0         8000.0242db01d347       no              vethccab668
# 查看宿主机 vethxxx 接口
ip addr |grep vethccab668
# 另外一个接口放进 container 所属的 namespace 下并命名为 eth0 接口
docker run --rm -itd busybox sh ip addr

# 3.daemon 进程还会从网桥 docker0 的私有地址空间中分配一个 IP 地址和子网给该容器，并设置 docker0 的 IP 地址为容器的默认网关
docker inspect test |grep Gateway
            "Gateway": "172.17.0.1",

```

###### host 网络模式
```shell
# host
使用宿主机的 IP 和端口，共享宿主机网络协议栈。

# test
docker run --rm -itd --net host busybox ip addr
```

###### none 网络模式
```shell
# none
每个容器拥有独立网络协议栈，但没有网络设置，如分配 veth pair 和网桥连接等。

# verify
docker run --rm -itd --net none busybox ip addr
```

###### container 网络模式
```shell
# container
和一个指定已有的容器共享网络协议栈，使用共有的 IP、端口等。

# verify
docker run --rm -itd busybox sh
docker run --rm -itd --net container:test1 busybox ip addr
```

###### 自定义网络模式
```shell
# user-defined 
默认 docker0 网桥无法通过 container name host 通信，自定义网络默认使用 daemon 进程内嵌的 DNS server，可以直接通过 --name 指定的 container name 进行通信

# test
docker network create yakir_test
# 宿主机查看新增虚拟网卡
ip addr
    inet 172.19.0.1/16 brd 172.19.255.255 scope global br-8cb8260a95cf
brctl show
bridge name     bridge id               STP enabled     interfaces
br-8cb8260a95cf         8000.024272aa9d38       no              veth556b81b
# verify
docker run --name test1 --rm -itd --net yakir_test busybox sh
docker run --name test2 --rm -it --net yakir_test ping -c 4 test1


# 连接已有的网络
docker run --name test --rm -itd --net yakir_test busybox sh
docker network connect yakir_test test 
docker exec -it test ip a             
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
531: eth0@if532: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue 
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
533: eth1@if534: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue 
    link/ether 02:42:ac:13:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.19.0.2/16 brd 172.19.255.255 scope global eth1
       valid_lft forever preferred_lft forever

```

###### IPvlan 模式
```shell
# ipvlan
ipvlan_mode: l2, l3(default), l3s
ipvlan_flag: bridge(default), private, vepa
parent: eth0

# l2 mode: 使用宿主机的望断
docker network create -d ipvlan \
     --subnet=192.168.1.0/24 \
     --gateway=192.168.1.1 \
     -o ipvlan_mode=l2 \
     -o parent=eth0 test_l2_net
# test
docker run --net=test_l2_net --name=ipv1 -itd alpine /bin/sh
docker run --net=test_l2_net --name=ipv2 -it --rm alpine /bin/sh
ping -c 4 ipv1

# l3 mode
docker network create -d ipvlan \
     --subnet=192.168.1.0/24 \
     --subnet=10.10.1.0/24 \
     -o ipvlan_mode=l3 test_l3_net
# test
docker run --net=test_l3_net --ip=192.168.1.10 -itd busybox /bin/sh
docker run --net=test_l3_net --ip=10.10.1.10 -itd busybox /bin/sh

docker run --net=test_l3_net --ip=192.168.1.9 -it --rm busybox ping -c 2 10.10.1.10
docker run --net=test_l3_net --ip=10.10.1.9 -it --rm busybox ping -c 2 192.168.1.10

```

###### Macvlan 模式
```shell
# macvlan

# bridge mode
docker network create -d macvlan \
  --subnet=172.16.86.0/24 \
  --gateway=172.16.86.1 \
  -o parent=eth0 pub_net


# 802.1Q trunk bridge mode
docker network create -d macvlan \
    --subnet=192.168.50.0/24 \
    --gateway=192.168.50.1 \
    -o parent=eth0.50 macvlan50

docker network create -d macvlan \
    --subnet=192.168.60.0/24 \
    --gateway=192.168.60.1 \
    -o parent=eth0.60 macvlan60

# https://zhuanlan.zhihu.com/p/616504632
```

###### Overlay 模式
```shell
# 多 docker 主机组建网络，配合 docker swarm 使用
```

#### Docker Build && Docker Compose
##### Dockerfile
```shell

```

##### docker-compose
```shell

```

#### Command
[[containerRuntime#docker & podman|Docker Command]]



>Reference:
>1. [Docker Official Documentation](https://docs.docker.com/)
>2. [Docker network-drivers](https://docs.docker.com/network/drivers/)