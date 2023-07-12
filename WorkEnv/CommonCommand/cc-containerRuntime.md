### Docker & Podman
```shell
# common parameters
-d, --detach    Run container in background and print container ID
-e, --env stringArray   Set environment variables in container
--env-file strings      Read in a file of environment variables
--name
-p, --publish strings   Publish a containers port
--restart               Restart policy to apply when a container exits ("always"|"no"|"on-failure"|"unless-stopped")
--rm                    Remove container (and pod if created) after exit
-v, --volume stringArray   Bind mount a volume into the container.


# 反查镜像 Dockerfile 内容
docker history db6effbaf70b --format {{.CreatedBy}} --no-trunc=true |sed "s#/bin/sh -c \#(nop) *##g"|sed "s#/bin/sh -c#RUN#g" |tac


# 编译自定义镜像
docker build -t yakir/uatproxy -f APP-META/Dockerfile .


# running mysql
podman run --name mysql -e MYSQL_ROOT_PASSWORD=1qaz@WSX -e MYSQL_DATABASE=devops_tools -p 3307:3306 -d mysql --character-set-server=utf8mb4


# knowledge-base
mkdir -p /opt/MrDoc/config /opt/MrDoc/data/mysql
docker run -d --name mrdoc -p 10086:10086 -v /opt/MrDoc:/app/MrDoc --net=bridge zmister/mrdoc:v4
docker run -d --name mrdoc_mysql -e MYSQL_ROOT_PASSWORD=knowledge_base123 -e MYSQL_DATABASE=knowledge_base -v /opt/MrDoc/data/mysql/:/var/lib/mysql mysql --character-set-server=utf8mb4

```


> 阿里云 ACR 仓库加速地址 = taa4w07u.mirror.aliyuncs.com


### Containerd
```shell
# default run by systemd
systemctl start containerd.service
# run by k3s
containerd -c /var/lib/rancher/k3s/agent/etc/containerd/config.toml -a /run/k3s/containerd/containerd.sock --state /run/k3s/containerd --root /var/lib/rancher/k3s/agent/containerd


# ctr (see pause container)
ctr --address /run/k3s/containerd/containerd.sock namespace ls 
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io images ls 
ctr --address /run/k3s/containerd/containerd.sock -n k8s.io container ls


# crictl
endpoint="/run/k3s/containerd/containerd.sock" URL="unix:///run/k3s/containerd/containerd.sock" 
crictl ps 
crictl images


```

