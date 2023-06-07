
```shell
# 编译自定义镜像
docker build -t yakir/uatproxy -f APP-META/Dockerfile .


# 启动自定义镜像
docker run --name myapp --rm -d --mount type=bind,source=/opt/myapp/db.sqlite3,target=/app/db.sqlite3 -p 8080:8080 yakir/myapp:latest


# Mysql
docker run --rm --name yakir-mysql -e MYSQL_ROOT_PASSWORD=1qaz@WSX -e MYSQL_DATABASE=yakirtest -p 3306:3306 -v /docker-volume/data:/var/lib/mysql -v /docker-volume/log:/var/log/mysql -d mysql --character-set-server=utf8mb4


# Redis
docker run --rm --name yakir-redis -e REDIS_PASSWORD=123 -p 6379:6379 -v /docker-volume/data:/data -d redis
# Redis Cluster
docker run --rm --name redis-cluster -e ALLOW_EMPTY_PASSWORD=yes -d bitnami/redis-cluster


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


##### VPN #####
# v2ray
mkdir /etc/v2ray
cat > /etc/v2ray/config.json << "EOF"
{
  "log": {
    "access": "/var/log/v2ray/access.log",
    "error": "/var/log/v2ray/error.log",
    "loglevel": "warning"
  },
  "dns": {},
  "stats": {},
  "inbounds": [
    {
      "port": 12306,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "1a85919c-6ee8-431d-aff4-436a45dc8d2d",
            "alterId": 32
          }
        ]
      },
      "tag": "in-0",
      "streamSettings": {
        "network": "tcp",
        "security": "none",
        "tcpSettings": {}
      }
    }
  ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "blocked",
      "protocol": "blackhole",
      "settings": {}
    }
  ],
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "blocked"
      }
    ]
  },
  "policy": {},
  "reverse": {},
  "transport": {}
}
EOF

docker run -d --name v2ray -v /etc/v2ray:/etc/v2ray -p 12306:12306 v2ray/official v2ray -config=/etc/v2ray/config.json


# ipsec
# run
docker run --name ipsecvpn --env-file ./vpn.env --restart=always -p 500:500/udp -p 4500:4500/udp -d --privileged hwdsl2/ipsec-vpn-server
# config
cat ./vpn.env
VPN_IPSEC_PSK=ipsecpskkey1234567890
VPN_USER=ipsec123
VPN_PASSWORD=ipsec123
#VPN_ADDL_USERS=additional_username_1 additional_username_2
#VPN_ADDL_PASSWORDS=additional_password_1 additional_password_2


# SSR
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssr.sh
##### VPN #####
```



> 阿里云 ACR 仓库加速地址 = taa4w07u.mirror.aliyuncs.com
