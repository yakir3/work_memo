#### Introduction

![[podcreate-dafvcg.jpg]]

![[Pasted image 20231117144608.png]]

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





> 参考文档：
> 1. [Kubernetes Official Documentation](https://kubernetes.io/)
> 2. [Kubernetes GitHub](https://github.com/kubernetes/kubernetes)
