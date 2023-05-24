```shell
# single node
path.data: /opt/elasticsearch/data/
path.logs: /opt/elasticsearch/logs/
bootstrap.memory_lock: false
network.host: 0.0.0.0
http.port: 9200
# discovery.seed_hosts: ["127.0.0.1:9300"]
discovery.type: single-node
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: false


# cluster node
path.data: /opt/elasticsearch/data/
path.logs: /opt/elasticsearch/logs/
cluster.name: yakir-es-cluster
node.name: node1
http.port: 9200
network.host: 1.1.1.1
http.cors.enabled: true
http.cors.allow-origin: "*"
discovery.zen.ping.unicast.hosts: ["1.1.1.1", "2.2.2.2", "3.3.3.3"]
discovery.zen.minimum_master_nodes: 2
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: false
```