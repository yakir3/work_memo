```shell
# 动态查看&更新节点配置（官方配置支持 cluster-wide 类型配置才可以更新）
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe
./kafka-configs.sh --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --alter --add-config log.cleaner.threads=2
# 使用 --entity-default 参数为调整整个集群的动态配置

# 查看 topic 列表
./kafka-topics.sh --bootstrap-server yakir-kafka-headless:9092 --list
# 查看详情参数
--topic test --descibe

# 查看 consumer 消费情况
./kafka-consumer-groups.sh --bootstrap-server yakir-kafka-headless:9092 --list
#详情
--group test --descibe


# 生产者
./kafka-console-producer.sh --bootstrap-server yakir-kafka-headless:9092 --topic yakirtopic


# 消费者
./kafka-console-consumer.sh --bootstrap-server yakir-kafka-headless:9092 --topic yakirtopic

./kafka-console-consumer.sh --bootstrap-server yakir-kafka-headless:9092 --topic yakirtopic --from-beginning

# 调整 topic 分区数
./kafka-topics.sh --bootstrap-server yakir-kafka-headless:9092 --alter --topic yakirtopic --partitions 3
# 调整 topic 副本数
./kafka-reassign-partitions.sh --bootstrap-server yakir-kafka-headless:9092 --reassignment-json-file yakir.json --execute
# 验证调整结果
./kafka-reassign-partitions.sh --bootstrap-server yakir-kafka-headless:9092 --reassignment-json-file yakir.json --verify

# 指定分区 副本数创建 topic
./kafka-topics.sh --bootstrap-server yakir-kafka-headless:9092 --create --replication-factor 1 --partitions 1 --topic yakir-test-topic

# 停止应用
./kafka-server-stop.sh
# 启动应用
./kafka-server-start.sh -daemon ../config/server.properties

```