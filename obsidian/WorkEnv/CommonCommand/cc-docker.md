```shell
# Mysql
docker run --rm --name mysql -e MYSQL_ROOT_PASSWORD=123qwe123 -e MYSQL_DATABASE=yakirtest -p 3306:3306 --character-set-server=utf8mb4 -d mysql

docker run --rm --name yakir-mysql -e MYSQL_ROOT_PASSWORD=1qaz@WSX -e MYSQL_DATABASE=yakirtest -p 3306:3306 -v /docker-volume/data:/var/lib/mysql -v /docker-volume/log:/var/log/mysql -d mysql --character-set-server=utf8mb4

# Redis
docker run --rm --name yakir-redis -e REDIS_PASSWORD=123 -p 6379:6379 -v /docker-volume/data:/data -d redis

# Redis Cluster

# Postgres SQL
docker run --rm --name yakir-postgres -e POSTGRES_PASSWORD=123qwe -e POSTGRES_DB=yakir_pg_test -p 5432:5432 -d postgres
POSTGRES_USER


# rancher
docker run --name rancher -d --rm -p 80:80 -p 443:443 --privileged rancher/rancher         
podman run --name rancher -d -p 80:80 -p 443:443 -e HTTP_PROXY=http://172.20.20.120:8888/ -e HTTPS_PROXY=http://172.20.20.120:8888/ --privileged rancher/rancher
docker logs rancher |grep Password

# jenkins
docker run --name jenkins -d --rm -p 8080:8080 -p 50000:50000 -v /opt/yakir/CICD/jenkins:/var/jenkins_home jenkins/jenkins

# gitlab-ce 
docker run --rm -d --name gitlab -p 50443:443 -p 50080:80 -p 50022:22 -v /opt/yakir/CICD/gitlab/config:/etc/gitlab \
-v /opt/yakir/CICD/gitlab/logs:/var/log/gitlab -v /opt/yakir/CICD/gitlab/data:/var/opt/gitlab -v /etc/localtime:/etc/localtime gitlab/gitlab-ce

# Jira
docker run -v /docker-volume/jira --name jira -e ATL_PROXY_NAME=a.com -d -p 8090:8080 atlassian/jira-software

# knowledge-base
docker run -d --name mrdoc -p 10086:10086 -v /home/tomcat/yakir/MrDoc:/app/MrDoc --net=bridge zmister/mrdoc:v4
docker run -d --name mrdoc_mysql -e MYSQL_ROOT_PASSWORD=knowledge_base123 -e MYSQL_DATABASE=knowledge_base -v /home/tomcat/yakir/MrDoc/config/mysql_data/:/var/lib/mysql mysql --character-set-server=utf8mb4
admin / admin123456
a18cs / a18cs123

#
kubectl -n middleware run client-mysql --rm -it --restart=Never --image bitnami/mysql -- /bin/bash
```

```shell
# 编译镜像
docker build -t yakir/uatproxy -f APP-META/Dockerfile .

# uatproxy 转发 UAT 请求项目，docker 启动方式
docker run --name uatproxy --rm -d --mount type=bind,source=/home/tomcat/yakir/pycode/uatproxy/db.sqlite3,target=/app/db.sqlite3 -p 8000:8000 yakir/uatproxy:latest
```
