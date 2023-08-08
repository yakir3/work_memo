#### Introduction
...


#### Deploy by Binaries
##### Download and Install Server
```shell
# download source
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
mkdir -p /opt/minio/data /opt/minio/bin
mv minio /opt/minio/bin/

# postinstallation
# groupadd minio-user
# useradd -r -g minio-user -s /bin/false minio-user
# chown minio-user:minio-user /opt/minio -R

# startup 
export PATH=$PATH:/opt/minio/bin
minio server /opt/minio/data
# start cluster mode
# need add new disk driver for /opt/minio/data
minio server --console-address :9001 http://1.1.1.1/opt/minio/data http://2.2.2.2/opt/minio/data http://3.3.3.3/opt/minio/data

```

##### Config and Boot
```shell
# config 
cat > /etc/default/minio << "EOF"
# set this for MinIO to reload entries with 'mc admin service restart'
MINIO_CONFIG_ENV_FILE=/etc/default/minio

# single
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin123
MINIO_OPTS="-console-address :9001"
MINIO_VOLUMES="/opt/minio/data"
# distributed
#MINIO_ROOT_USER=minioadmin
#MINIO_ROOT_PASSWORD=minioadmin123
#MINIO_OPTS="-console-address :9001"
#MINIO_VOLUMES="http://minio{1...4}.example.net:9000/mnt/disk{1...4}/minio"
EOF

# boot
cat > /etc/systemd/system/minio.service << "EOF"
[Unit]
Description=MinIO
Documentation=https://min.io/docs/minio/linux/index.html
Wants=network-online.target
After=network-online.target
AssertFileIsExecutable=/opt/minio/bin/minio

[Service]
WorkingDirectory=/opt/minio
User=minio-user
Group=minio-user
ProtectProc=invisible
EnvironmentFile=-/etc/default/minio
ExecStartPre=/bin/bash -c "if [ -z \"${MINIO_VOLUMES}\" ]; then echo \"Variable MINIO_VOLUMES not set in /etc/default/minio\"; exit 1; fi"
ExecStart=/usr/local/bin/minio server $MINIO_OPTS $MINIO_VOLUMES
# Type=notify
Restart=always
LimitNOFILE=65536
TasksMax=infinity
SendSIGKILL=no

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start minio.service
systemctl enable minio.service
```

##### Verify
```shell
# download and install minio client
curl https://dl.min.io/client/mc/release/linux-amd64/mc -o mc
chmod +x mc
mv mc /opt/minio/bin

# test
export PATH=$PATH:/opt/minio/bin
mc alias set myminio http://172.22.3.33:9000 minioadmin minioadmin123

mc admin info myminio
mc mb myminio/mybucket
mc cp /tmp/1.txt myminio/mybucket/
mc cat myminio/mybucket/1.txt
```

##### Troubleshooting
```shell
# problem 1
# 
```


#### Deploy by Container
##### Run by Docker
```shell
# 
docker run -p 9000:9000 -p 9001:9001 quay.io/minio/minio server /data --console-address ":9001"

```

##### Run by Helm
```shell
# add and update repo
helm repo add minio https://helm.min.io/
helm update

# get charts package
helm fetch minio/minio --untar
cd minio

# configure and run
vim values.yaml
...
helm -n runtime install minio .

# access and test
kubectl -n argo get secrets minio -ojsonpath='{.data.accesskey}' |base64 -d
kubectl -n argo get secrets minio -ojsonpath='{.data.secretkey}' |base64 -d
mc alias set minio_name http://pod_ip:9000 accesskey secretkey 
mc admin info minio_name
```


> 参考文档：
> 1. [Minio 官方文档](https://min.io/docs/minio/kubernetes/upstream/)
> 2. [Minio GitHub](https://github.com/minio/minio)