```shell
# 查看所有 restful api
curl http://172.30.2.218:9200/_cat
# 查看 es 所有索引
curl http://172.30.2.218:9200/_cat/indices -u "elastic:OEHW5qL3^^D>S@Bp"

# 查看 es 配置
curl http://172.30.2.218:9200/_settings\?pretty -u "elastic:OEHW5qL3^^D>S@Bp"

# 调整 es 索引默认分片 副本数规则
curl -X PUT 'http://172.30.2.218:9200/_template/logstash_template' -u 'elastic:OEHW5qL3^^D>S@Bp' \ 
-H 'Content-Type: application/json' \
-d '{
	"index_patterns": ["logstash-*"],
	"settings": {
		"number_of_shards": 1,
		"number_of_replicas": 0
	}
}' 


# 查看数据
time curl -X POST "http://es-server:9200/index/_search" -d '{"version":true,"size":50,"sort":[{"@timestamp":{"order":"desc","unmapped_type":"boolean"}}],"_source":{"excludes":[]},"stored_fields":["*"],"script_fields":{},"docvalue_fields":["@timestamp","local_time"],"query":{"bool":{"must":[],"must_not":[],"filter":{"bool":{"must":[{"range":{"@timestamp":{"gte":1663209126805,"lte":1663209726805,"format":"epoch_millis"}}}],"must_not":[],"should":[]}}}},"highlight":{"pre_tags":["@kibana-highlighted-field@"],"post_tags":["@/kibana-highlighted-field@"],"fields":{"message":{}},"fragment_size":2147483647},"from":0}' -H'Content-Type: application/json'



# 查看所有分片
curl http://172.30.2.218:9200/_cat/shards -u "elastic:OEHW5qL3^^D>S@Bp" |awk '{print $1}' |sort -rn |uniq |grep -v "\." > index.tmp
# 删除分片
for i in `cat index.tmp`
do
     curl -X DELETE http://172.30.2.218:9200/$i -u "elastic:OEHW5qL3^^D>S@Bp"
done

```