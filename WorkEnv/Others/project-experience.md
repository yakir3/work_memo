### 2022




### 2023
#### Platform
##### AWS
+ CloudFront
+ Route 53
+ SES
+ SNS

##### CloudFlare
+ CDN

##### GCP  
+ GKE 
INIT
1.gke create
2.manager machine vm init
3.gcloud iam roles create: artifact、ops-api
4.cloud loadbalancer: nat
5.cli: kubectl、helm、google-cloud-cli
cat >> ~/.bashrc << "EOF"
source <(kubectl completion bash)
source <(helm completion bash)
EOF
apt install google-cloud-cli 
apt install google-cloud-cli-gke-gcloud-auth-plugin
6.gloud auth login and import gke kubeconfig to local
gcloud auth login --cred-file=xxx.json
gcloud container clusters get-credentials my-gke --region asia-east2 --project my-gke
7.import rancher(rancher ingress whitelist)
8.gke ingress create(internel loadbalancer)
9.storage and others components
nfs-subdir-external-provisioner
redis, kafka
prometheus, grafana


#### CICD
Jira
devops_tools(custom)
Archery：postgres、mysql


#### 开源知识库



#### 项目部署、升级
Apollo
Nacos

Gitlab

Jenkins

Rancher
k8s app deploy script

NFS


#### ObservabilityAnalysis
##### Monitoring
Prometheus

Grafana

Skywalking

sentinel

exception 处理中心？

##### Logging

Fluent
Fluent-bit

Elasticsearch：index template、index policy

Logstash
GCP cloud storage



#### Middleware
+ Kafka
KnowStreaming
Kafka-ui

+ Redis
redis-insight


#### Security
安全漏洞平台关注：AWS、绿盟、华为云、阿里云、腾讯云、Ubuntu、Redhat

Java jar fix 

Docker basic images 

Middleware GitHub 漏洞安全补丁关注



#### Kubernetes 优化
namespace 资源限制？ limitrange？
kube-dashboard？ 权限控制？
k8s debug 调试 doc？ --> 缩减基础镜像？
使用 GitOps 等 CICD 应用改造现有发布流程，对接蓝绿发布/金丝雀发布方式提升系统稳定性




>1. [乌云知识库](https://github.com/SuperKieran/WooyunDrops)
>2. [mindoc](https://github.com/mindoc-org/mindoc)


