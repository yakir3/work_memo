#### 一、 NFS Server 端部署配置

##### 原理简介
首先服务器端启动RPC服务，并开启111端口
服务器端启动NFS服务，并向RPC注册端口信息
客户端启动RPC（portmap服务），向服务端的RPC(portmap)服务请求服务端的NFS端口
服务端的RPC(portmap)服务反馈NFS端口信息给客户端。
客户端通过获取的NFS端口来建立和服务端的NFS连接并进行数据的传输。

##### Server 部署配置
```shell
# ubuntu 安装
apt install nfs-kernel-server


# 创建共享目录
mkdir /a18_data /qc_data


# 配置文件（* 处可配置IP CIDR，GCP 已有防火墙，直接全放行即可）
cat > /etc/exports << "EOF"
/a18_data *(rw,sync,no_subtree_check)
/qc_data  *(rw,sync,no_subtree_check)
EOF
# 启用 nfs 配置与重载
exportfs -a
exportfs –r
# 查看挂载详细配置（sec 配置见参考文档）
exportfs -v
/a18_data       <world>(rw,wdelay,root_squash,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)


# 启动与开机自启，需要确保 rpc 服务已启动
systemctl start rpcbind
systemctl enable rpcbind
systemctl start nfs-kernel-server
systemctl enable nfs-kernel-server


# GCP 放行 2049 端口
略
```


##### Client 端挂载
```shell
# nfs 客户端挂载
apt install nfs-common
mkdir /tmp/nfs_test
mount -t nfs 1.1.1.1:/a18_data /tmp/nfs_test


# k8s 集群挂载
通过 pv、pvc 挂载（略）

```


#### 二、K8S 集群 PV 重建切换
```shell
# 删除原 pv 资源
kubectl delete pv qc-nfs-pv


# 此时 pv 资源会进入 Terminaling 状态，需要人工介入
# pvc 资源会进入 lost 状态，等待 pv 资源重建
kubectl edit pv qc-nfs-pv
  # 删除这两行数据，强制删除 pv 资源
  finalizers:
  - kubernetes.io/pv-protection


# 重建 pv（通过 helm 更新）
cd /opt/tc-helm/helm-charts/public/global/
vim values.yaml  #更新 NFS 主机信息
helm -n public upgrade global -f values.yaml .


# 查看 pv，pvc 状态，等待几秒 pvc 变为 Bound 状态即为正常
kubectl get pv,pvc


# rancher 重启 pod ，进入新的 pod 查看 nfs 挂载是否正常生效
mount |grep nfs

```




>参考文档：
>1. https://cshihong.github.io/2018/10/16/NFS%E6%9C%8D%E5%8A%A1%E5%99%A8%E6%90%AD%E5%BB%BA%E4%B8%8E%E9%85%8D%E7%BD%AE/