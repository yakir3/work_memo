#### Introduction
...

#### Deploy by Container
##### Run by Docker
```shell
docker run -d --name emqx -p 1883:1883 -p 8083:8083 -p 8084:8084 -p 8883:8883 -p 18083:18083 emqx/emqx:latest

```

##### Run by Helm
```shell
# add and update repo
# get charts package
git clone https://github.com/emqx/emqx.git
cd emqx/deploy/charts/emqx

# configure and run
vim values.yaml
...

helm -n middleware install my-emqx .


# Helm Operator
# https://github.com/emqx/emqx-operator/blob/main/docs/en_US/getting-started/getting-started.md
```

#### How to use
##### mqttx-cli
```shell
# connect 
mqttx conn -h 'broker.emqx.io' -p 1883 -u 'admin' -P 'public'

# subscribe
mqttx sub -t 'hello' -h 'broker.emqx.io' -p 1883

# publish
mqttx pub -t 'hello' -h 'broker.emqx.io' -p 1883 -m 'Hello from MQTTX CLI'


```



>Reference:
>1. [EMQX Official Documentation](https://www.emqx.io/docs/)
>2. [EMQX GitHub](https://github.com/emqx/emqx)
>3. [EMQX Kubernetes Operator](https://docs.emqx.com/zh/emqx-operator/latest/getting-started/getting-started.html)
>4. [MQTTX Client Tools](https://mqttx.app/)
