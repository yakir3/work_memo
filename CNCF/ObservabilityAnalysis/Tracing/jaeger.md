#### Introduction
##### 架构图
![[Pasted image 20230526143340.png]]

https://www.jaegertracing.io/docs/1.45/#about

#### Deployment
##### Run On Docker
all-in-one 部署，用于测试环境
```shell
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 14250:14250 \
  -p 14268:14268 \
  -p 14269:14269 \
  -p 9411:9411 \
  jaegertracing/all-in-one:1.45
```


##### Deploy On Kubernetes
>Must be installed: ingress & cert-manager

**deploy by kubenertes manifest**
```shell
# install operator
kubectl create namespace observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.45.0/jaeger-operator.yaml -n observability


# deploying allinone 
cat > simpletest.yaml << "EOF"
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: simplest
EOF
kubectl -n observability apply -f simpletest.yaml
kubectl -n observability get jaegers
```

**deploy by helm**
[[cc-helm|helm常用命令]]
```shell
# add and update repo
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm update

# get charts package
helm pull jaegertracing/jaeger-operator --untar
cd jaeger-operator

# configure and run
vim values.yaml
helm -n observability install jaeger-operator .

kubectl apply -n observability -f - <<EOF
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: simplest
EOF
kubectl -n observability get jaegers
```


> 参考文档：
> 1、官方 github 地址 = https://github.com/jaegertracing/jaeger
> 2、官方文档 = https://www.jaegertracing.io/docs/1.45/getting-started/
> 3、jaeger-operator = https://github.com/jaegertracing/jaeger-operator