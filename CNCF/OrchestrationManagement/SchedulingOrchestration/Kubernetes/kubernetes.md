#### Introduction

![[podcreate-dafvcg.jpg]]


##### Components
Control plane
+ etcd(cluster parallel)
+ kube-apiserver(parallel loadbalance)
+ kube-controller-manager(single instance)
+ kube-scheduler(single instance)


Data plane
+ kubelet
+ kube-proxy
+ container-runtime(docker,containerd,rkt...)
+ kube-dns


Options components
+ kube-dashboard
+ ingress-nginx
+ metrics-server
+ cni



#### Deploy
##### 





> 参考文档：
> 1. [官方文档](https://kubernetes.io/)
> 2. [GitHub 地址](https://github.com/kubernetes/kubernetes)
