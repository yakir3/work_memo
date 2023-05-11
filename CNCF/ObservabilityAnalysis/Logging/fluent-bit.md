[[cc-elasticsearch|Elasticsearch 常用命令]]
[[cc-elasticsearch]]

```shell

fluentd
console log -> es

Node:
gke-qc-uat-service-pool-87f533cb-ndcf

索引名:
logstash-uat_public_kratos_auth-2023-04-19

Pod 日志：
/var/log/pods/public_public-rex-user-center-0_cb70237e-cf2a-4d9e-acb0-4206b8c93580/public-rex-user-center/

pip install --upgrade google-cloud-logging


# ES 调整配置
索引名称
索引副本模板


# fluent-bit chart values 原始 lua 配置
  extraFiles:
      fluentbit.lua: |
        function set_index(tag, timestamp, record)
            prefix = "logstash-uat"
            if record["kubernetes"] ~= nil then
                if record["kubernetes"]["labels"]["app"] ~= nil then
                    project_initial_name = record["kubernetes"]["labels"]["app"]
                    project_name, _ = string.gsub(project_initial_name, '-', '_')
                    record["es_index"] = prefix .. "_" .. project_name
                    --record["es_index"] = prefix .. "_" .. record["kubernetes"]["labels"]["app"]
                    return 1, timestamp, record
                end
            end
            return 1, timestamp, record
        end
# 新配置

```


持久化日志？

