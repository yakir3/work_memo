#### TCP传输是无状态的，靠通讯双方维护一个连接状态
![image](https://github.com/yakir3/gitbook/assets/30774576/b6cb0f1e-4474-4931-bbed-180d5e3dfb11)

对于4次挥手：其实你仔细看是2次，因为TCP是全双工的，所以，发送方和接收方都需要Fin和Ack。只不过，有一方是被动的，所以看上去就成了所谓的4次挥手。如果两边同时断连接，那就会就进入到CLOSING状态，然后到达TIME_WAIT状态

TCP建连超时：syn+ack发送后等待最后ack时间，等待默认5次 总时长 63s，才会断开连接<br />SYN Flood攻击：syncookies开启、tcp_max_syn_backlog增大syn队列连接数、tcp_abort_on_overflow处理不过来时直接拒绝连接

ISN初始化：不能hard code，否则断开连接重进会有问题。MSL存活时间小于4.55小时，ISN就不会被重用

MSL和TIME_WAIT：TIME_WAIT转为CLOSED状态时需要等待2MSL时间（MSL为2分钟，linux中为30s）<br />1）TIME_WAIT确保对端收到ACK，如果被动端没有收到ACK则触发重发FIN包，刚好一来一回2MSL时间<br />2）有足够时间让这个连接不会跟后面的连接混用，如果连接被重用，那么延迟收到的包会跟新连接混在一起

TIME_WAIT状态过多问题处理：[https://www.zhihu.com/question/298214130/answer/1090787813](https://www.zhihu.com/question/298214130/answer/1090787813)<br />tcp_max_tw_buckets：TIME_WAIT数量，默认值180000


#### TCP重传机制
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


#### RTT算法：
RTT采样（Round Trip Time） --- 数据包从发送到ACK回来的时间，发送端发包时间是t0，ACK接收到时间是t1 RTT采样=t1-t0<br />RTO（Retransmission TimeOut） --- TCP的TimeOut设置，让重传高效<br />[https://www.imooc.com/article/29368](https://www.imooc.com/article/29368)


#### TCP滑动窗口
TCP头中字段Window：接收端告诉发送端自己还有多少缓冲区可以接收数据
![image](https://github.com/yakir3/gitbook/assets/30774576/7c113f01-8d65-48c1-aa6d-f692f2730dd6)

- 接收端LastByteRead指向了TCP缓冲区中读到的位置，NextByteExpected指向的地方是收到的连续包的最后一个位置，LastByteRcved指向的是收到的包的最后一个位置，我们可以看到中间有些数据还没有到达，所以有数据空白区。
- 发送端的LastByteAcked指向了被接收端Ack过的位置（表示成功发送确认），LastByteSent表示发出去了，但还没有收到成功确认的Ack，LastByteWritten指向的是上层应用正在写的地方

于是：

- 接收端在给发送端回ACK中会汇报自己的AdvertisedWindow = MaxRcvBuffer – LastByteRcvd – 1;
- 而发送方会根据这个窗口来控制发送数据的大小，以保证接收方可以处理

[https://www.imooc.com/article/29368](https://www.imooc.com/article/29368)
