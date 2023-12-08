#### Introduction
...


#### Deployment
[Run On SourceCode](https://docs.gitlab.com/ee/install/installation.html#overview)

##### Run On Ubuntu
```shell
# Install and configure the necessary dependencies
apt update
apt install -y curl openssh-server ca-certificates tzdata perl

# Add the Gitlab package repository and install package
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
GITLAB_ROOT_PASSWORD="7K48w3NaUH4v5AQq" EXTERNAL_URL="http://gitlab-sl.opsre.net" apt install gitlab-ee

# Browse to the hostname and login
cat /etc/gitlab/initial_root_password
```

##### Run On Docker
[[cc-docker|Docker常用命令]]
```shell
# run container
GITLAB_HOME=/opt/gitlab
docker run --detach \
  --hostname gitlab.example.com \
  --publish 443:443 --publish 80:80 --publish 22:22 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_HOME/config:/etc/gitlab \
  --volume $GITLAB_HOME/logs:/var/log/gitlab \
  --volume $GITLAB_HOME/data:/var/opt/gitlab \
  --shm-size 256m \
  gitlab/gitlab-ce:latest

# gitlab password
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password

# offcial image
gitlab/gitlab-ce
gitlab/gitlab-ee

# docker-compose 
[install by docker-compose](https://docs.gitlab.com/ee/install/docker.html#install-gitlab-using-docker-compose)

```

##### Run On Kubernetes
[[cc-k8s|deploy by kubernetes manifest]]
```shell
# manifest resource yaml
deployments = redis, postgresql, gitlab
service = redis, postgresql, gitlab
ingress = gitlab
```

[[cc-helm|deploy by helm]]
```shell
# Add and update repo
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# Get charts package
helm fetch gitlab/gitlab --untar  
cd gitlab

# Configure and run
vim values.yaml
...

helm -n cicd install gitlab . --create-namespace \
  --timeout 600s \
  --set global.hosts.domain=yakir.com \
  --set global.hosts.externalIP=1.1.1.1 \
  --set certmanager-issuer.email=yakir@gmail.com \
  --set certmanager.installCRDs=false \
  --set certmanager.install=false \
  --set nginx-ingress.enabled=false \
  --set prometheus.install=false 

# Install the Community Edition
--set global.edition=ce
```

[deploy by gitlab-operator](https://docs.gitlab.com/operator/)

access and use
```shell
# patch harbor ingress resource
kubectl -n cicd patch ingress gitlab-webservice-default --patch '{"spec":{"ingressClassName": "nginx"}}'

# get password
kubectl -n cicd get secrets gitlab-gitlab-initial-root-password -ogo-template='{{.data.password|base64decode}}'

# access by https
https://harbor-core.yakir.com
admin
Harbor12345


```



> 参考文档:
> 1. [官方文档](https://docs.gitlab.com/)
> 2. [官方 github 地址](https://github.com/gitlabhq/gitlabhq)