### 二进制部署
```shell
# 1.download and decompression
https://www.elastic.co/downloads/elasticsearch

# 2.configure
vim config/elasticsearch.yml

# 3.run 
./bin/elasticsearch

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