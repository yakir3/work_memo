### Argo CD
#### Introduction
...


#### Deploy by Container
##### Run by Resource
```shell
# install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# others install 
# https://github.com/argoproj/argo-cd/tree/master/manifests
```

##### Run by Helm
```shell
# add and update repo
helm repo add argo https://argoproj.github.io/argo-helm
helm update

# get charts package
helm fetch argo/argo-cd --untar
cd argo-cd

# configure and run
vim values.yaml
...
helm -n argocd install argocd .
```


#### Started
##### postinstallation
```shell
# install argocd cli latest version
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm -f argocd-linux-amd64

# access argocd server
kubectl port-forward svc/argocd-server -n argocd 8080:443
# kubectl -n argocd apply -f argocd-ingress.yaml

# get username and password
username=admin
password=`kubectl -n argocd get secrets argocd-initial-admin-secret -ojsonpath='{.data.password}' |base64 -d`

```

##### application
```shell
# login by argocd cli
argocd login <ARGOCD_SERVER>

# create example app
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default

argocd app list # kubectl -n argocd get applications

# sync or deploy application
argocd app sync guestbook
argocd app get guestbook


```


### Argo Workflows
#### Introduction
...


#### Deploy by Container
##### Run by Resource
```shell
# 
```


##### Run by Helm
```shell
#
```

#### Started
##### postinstallation
```shell
# install argocd cli latest version
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm -f argocd-linux-amd64

# access argocd server
kubectl port-forward svc/argocd-server -n argocd 8080:443
# kubectl -n argocd apply -f argocd-ingress.yaml

# get username and password
username=admin
password=`kubectl -n argocd get secrets argocd-initial-admin-secret -ojsonpath='{.data.password}' |base64 -d`

```

##### application
```shell
# login by argocd cli
argocd login <ARGOCD_SERVER>

# create example app
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default

argocd app list # kubectl -n argocd get applications

# sync or deploy application
argocd app sync guestbook
argocd app get guestbook


```


> 参考文档：
> 1. [Argo Workflows Doc](https://argoproj.github.io/argo-workflows/quick-start/)
> 2. [argo-workflows GitHub](https://github.com/argoproj/argo-workflows)
> 3. [Argo CD Doc](https://argo-cd.readthedocs.io/en/stable/)
> 4. [argo-cd GitHub](https://github.com/argoproj/argo-cd)