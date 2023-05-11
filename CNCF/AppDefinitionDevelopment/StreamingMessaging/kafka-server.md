[[cc-kafka|kafka常用命令]]





```shell

./kafka-server-start.sh -daemon ../config/server.properties 

./zookeeper-server-stop.sh
./zookeeper-server-start.sh -daemon ../config/zookeeper.properties 



kubectl -n middleware get pvc |grep kafka |awk '{print $1}' |xargs -I {} kubectl  -n middleware delete pvc {}


kafka.servers = uat-kafka-v3-0.uat-kafka-v3-headless.middleware.svc:9092,uat-kafka-v3-1.uat-kafka-v3-headless.middleware.svc:9092,uat-kafka-v3-2.uat-kafka-v3-headless.middleware.svc:9092

==============

# helm 部署 kafka
helm pull bitnami/kafka --version=20.0.6  --untar

# 持久化存储
pv 
pvc
nfs-client



logsDirs: /bitnami/kafka/data
defaultReplicationFactor: 3
offsetsTopicReplicationFactor: 3
transactionStateLogReplicationFactor: 3
transactionStateLogMinIsr: 2
numPartitions: 3
replicaCount: 3

podLabels:
  app: uat-kafka-v3






# 测试效果
kubectl run kafka-client --image docker.io/bitnami/kafka:3.4.0-debian-11-r22 --namespace
middleware --command -- sleep infinity
kubectl exec -it kafka-client --namespace public-service -- bash


```


>参考文档：
>storaclass 存储类官方说明 = https://kubernetes.io/zh-cn/docs/concepts/storage/storage-classes/
>nfs-server 存储类部署方式 = https://levelup.gitconnected.com/how-to-use-nfs-in-kubernetes-cluster-storage-class-ed1179a83817