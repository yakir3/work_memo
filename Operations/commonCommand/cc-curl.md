```shell
# 自定义请求 Header
--header / -H

# 携带 cookie 请求
--cookie 或 -b 参数

# 详细输出请求信息
-v

# 代理请求
-x, --proxy [protocol://]host[:port]

# 测试服务端支持的 TLS 版本
curl https://google.com -kv --tlsv1 --tls-max 1.0
curl https://google.com -kv --tlsv1.3 --tls-max 1.3

# 指定 DNS 解析 IP 请求
curl https://google.com --resolve google.com:443:1.1.1.1 -v


# 模拟 websocket 请求
curl http://127.0.0.1:9999 -H 'Upgrade: websocket' -H 'Connection: Upgrade' -H'Sec-WebSocket-Key: eeZn6lg/rOu8QbKwltqHDA==' -H'Sec-WebSocket-Version: 13'

```