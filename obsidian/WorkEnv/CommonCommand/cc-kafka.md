```shell
# 查看 topic 列表
./kafka-topics.sh --bootstrap-server yakir-kafka-headless:9092 --list
# 查看详情参数
--topic test
--descibe

# 查看 consumer 消费情况
./kafka-consumer-groups.sh --bootstrap-server yakir-kafka-headless:9092 --list
#详情
--group test
--descibe


# 生产者
./kafka-console-producer.sh --bootstrap-server yakir-kafka-headless:9092 --topic yakirtopic


# 消费者
./kafka-console-consumer.sh --bootstrap-server yakir-kafka-headless:9092 --topic yakirtopic

./kafka-console-consumer.sh --bootstrap-server yakir-kafka-headless:9092 --topic yakirtopic --from-beginning
```