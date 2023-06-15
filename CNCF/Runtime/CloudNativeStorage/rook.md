#### Introduction
...


#### Deployment
##### Run On Docker
[[cc-docker|Docker常用命令]]
```shell
# run by docker or docker-compose
# https://hub.docker.com/r/rook/ceph/tags
```

##### Run On Kubernetes
[[cc-k8s|deploy by kubernetes manifest]]
```shell
# https://rook.io/docs/rook/v1.11/Getting-Started/quickstart/#tldr
git clone https://github.com/rook/rook.git
cd rook/deploy/examples
kubectl create -f crds.yaml -f common.yaml -f operator.yaml

# https://github.com/rook/rook/blob/release-1.11/deploy/examples/cluster-test.yaml
# create rook-cluster
kubectl create -f cluster-test.yaml

# verify the rook-ceph-operator and rook-cluster
kubectl -n rook-ceph get pod,crd
```

[[cc-helm|deploy by helm]]
```shell
# Add and update repo
helm repo add rook https://charts.rook.io/release
helm repo update

# Get charts package
# operator
helm fetch rook/rook-ceph --untar
cd rook-ceph

# Configure and run
vim values.yaml
...
helm -n rook-ceph install rook-ceph . --create-namespace 

# create rook-cluster
helm fetch rook/rook-ceph-cluster --untar
cd rook-ceph-cluster
helm -n rook-ceph install rook-ceph-cluster . --create-namespace

# verify the rook-ceph-operator and rook-cluster
kubectl -n rook-ceph get pod,crd
```

deploy storageclass and use
```shell
# storageclass
# https://github.com/rook/rook/blob/release-1.11/deploy/examples/csi/rbd/storageclass-test.yaml
cat > storage-test.yaml << "EOF"
...
EOF

kubectl -n rook-ceph apply -f storage-test.yaml

# create pvc to bound
cat > pvc-test.yaml << "EOF"
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pv-claim
  labels:
    app: test
spec:
  storageClassName: rook-ceph-block
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
EOF

kubectl -n rook-ceph apply -f pvc-test.yaml

```


> 参考文档:
> 1. [官方文档](https://rook.io/)
> 2. [官方 github 地址](https://github.com/rook/rook)
