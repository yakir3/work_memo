#### 2022




#### 2023
##### Platform
AWS
 cloudfront
Cloudflare
GCP  
 GKE
 


##### cicdflow
Jira
devops_tools
Archery：pgsql、mysql


##### 开源知识库



##### 项目部署、升级
Apollo

Nacos

rancher
k8s app deploy script


##### 日志
收集
fluent
fluent-bit
elasticsearch：索引模板、生命周期策略

持久化
logstash
GCP cloud storage


##### 可观测
prometheus

grafana

skywalking

sentinel


##### 中间件
+ kafka
KnowStreaming
kafka-ui

+ redis
redisinsight


##### 安全漏洞
java jar fix 

docker basic images 


##### GKE 集群
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
redis,kafka
prometheus,grafana



>1. [乌云知识库](https://github.com/SuperKieran/WooyunDrops)
>2. [mindoc](https://github.com/mindoc-org/mindoc)


