### Docker
```shell
# 反查镜像 Dockerfile 内容
docker history db6effbaf70b --format {{.CreatedBy}} --no-trunc=true |sed "s#/bin/sh -c \#(nop) *##g"|sed "s#/bin/sh -c#RUN#g" |tac

```

### Containerd
```shell
#



```