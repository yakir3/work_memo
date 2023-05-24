```shell
# 查看所有 restful api
curl http://es_server:9200/_cat -u "elastic:es123"

# 查看 es 所有索引
curl http://es_server:9200/_cat/indices?pretty

# 查看索引配置信息
curl http://es_server:9200/index_name/_settings?pretty

# 查看索引映射信息
curl http://es_server:9200/index_name/_mappings

# 查看索引生命周期策略信息
curl http://es_server:9200/index_name/_ilm/explain

# 查看 ES 生命周期策略
curl http://es_server:9200/_ilm/policy
http://es-server:9200/_ilm/policy/policy_name

# 查看所有索引分片
curl http://172.30.2.218:9200/_cat/shards -u "elastic:es123" |awk '{print $1}' |sort -rn |uniq |grep -v "\." > /tmp/index.tmp
# 删除分片
for i in `cat /tmp/index.tmp`
do
     curl -X DELETE http://es_server:9200/$i -u "elastic:es123"
done


# 查看索引模板配置信息
curl http://es_server:9200/_template/logstash_template

# 配置索引/索引模板，默认分片、副本数规则、映射等
curl -X PUT 'http://es_server:9200/_template/logstash_template' -u 'elastic:es123' \ 
-H 'Content-Type: application/json' \
-d '{
	"index_patterns": ["logstash-*"],
	"settings": {
		"number_of_shards": 1,
		"number_of_replicas": 0
		"lifecycle.name": "7-days-default"
		"lifecycle.rollover_alias": "uat-7-days-default"
	}
	...
}' 


# 搜索数据
time curl -X POST "http://es-server:9200/index/_search" -d '{"version":true,"size":50,"sort":[{"@timestamp":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"stored_fields":["*"],"script_fields":{},"docvalue_fields":["@timestamp","local_time"],"query":{"bool":{"must":[],"must_not":[],"filter":{"bool":{"must":[{"range":{"@timestamp":{"gte":1663209126805,"lte":1663209726805,"format":"epoch_millis"}}}],"must_not":[],"should":[]}}}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"message":{}},"fragment_size":2147483647},"from":0}' -H'Content-Type: application/json'

```