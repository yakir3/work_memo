### 2022


### 2023
#### Platform
##### AWS
+ CloudFront
+ Route 53
+ SES
+ SNS
+ MetaAPI

##### CloudFlare
+ CDN

##### GoogleCloud
+ CloudStorage
+ VPCnetwork
+ ComputerEngine
+ Logging
+ Filestore(NFS)
+ ArtifactRegistry
+ KubernetesEngine
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
##### devops_tools
对接 CI 制品，生成 Jira CD 流程工单
自动升级 SQL 工单与代码，根据 Jira webhook 转换流程

##### Jira
升级流程工单，CD 部分

##### Archery
Postgres、Mysql SQL 工单生成以及自动执行

##### Jenkins
脚本工具：定时查询供应商余额通知
第三方项目 CICD 任务

##### Gitlab

##### Jenkins

##### Rancher

#### Knowledge Base
##### Confluence


#### Monitoring
##### Prometheus
node-exporter
redis-exporter
kafka-exporter
rocketmq-exporter

##### Grafana
alert notice

##### Skywalking
skywalking-agent
alert notice to feishu

#### Logging

##### Fluentd
[[sc-fluentd|flent-bit to tcp forward for persistent storage ]]
upload persistent storage to CloudStorage

##### Fluent-bit
collect GKE cluster logs to Elasticsearch

##### Elasticsearch
index template
index policy

##### Logstash
collect VM machine logs to persistent storage
upload persistent storage to CloudStorage

#### Middleware
##### Server
Apollo
Nacos
Kafka
Redis
RocketMQ
NFS Server

##### Management
Kafka-ui
redis-insight
rocketMQ-dashboard
nfs-common
cerebro

#### Security
安全漏洞平台关注：AWS、绿盟、华为云、阿里云、腾讯云、Ubuntu、Redhat

Java jar fix 

Docker basic images 

Middleware GitHub 漏洞安全补丁关注



#### Kubernetes 优化
##### Ingress
ingress proxy_read_timeout

##### Resource
request
limit
HPA

namespace limitrange?

##### Permission
RBAC

##### Image
debug image 调试 Pod：缩减基础镜像


nfs-subdir-external-provisioner
使用 GitOps 等 CICD 应用改造现有发布流程



>1. [乌云知识库](https://github.com/SuperKieran/WooyunDrops)
>2. [mindoc](https://github.com/mindoc-org/mindoc)


