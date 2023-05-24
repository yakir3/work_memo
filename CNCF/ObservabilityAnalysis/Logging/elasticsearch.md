### 二进制部署
```shell
# 1.download and decompression
https://www.elastic.co/downloads/elasticsearch

# 2.configure
vim config/elasticsearch.yml

# 3.run 
./bin/elasticsearch
# daemon run
./bin/elasticsearch -d 

# 4.set password and verify
./bin/elasticsearch-setup-passwords interactive
curl 127.0.0.1:9200 -u 'elastic:es123123'
```
[[sc-elasticsearch|es常用配置]]

### helm 部署
```shell
# add and update repo
helm repo add elastic https://helm.elastic.co
helm update

# get charts package
helm pull elastic/elasticsearch --untar
cd elasticsearch

# configure and run
vim values.yaml

helm -n logging install elasticsearch .

```


### 官方 ECK operator 部署方式
详见参考文档


> 参考文档：
> 1、官方 github 文档 = https://github.com/elastic/elasticsearch
> 2、官方 k8s 集群部署文档 = https://www.elastic.co/downloads/elastic-cloud-kubernetes