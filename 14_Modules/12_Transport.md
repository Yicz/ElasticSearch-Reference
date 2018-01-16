## 传输 Transport

传输模块使用于集群中节点的内部交流。从一个节点到另一个节点的每个调用都使用传输模块（例如，当一个节点处理HTTP GET请求时，实际上应该由保存数据的另一个节点处理）。

传输机制本质上是完全异步的，意味着没有阻塞线程等待响应。 使用异步通信的好处是首先解决[C10k问题](http://en.wikipedia.org/wiki/C10k_problem)，同时也是分散（广播）/收集操作的理想解决方案，例如在ElasticSearch。

### TCP Transport

TCP传输是使用TCP的传输模块的实现。 它允许以下设置：

设置 | 说明  
---|---    
`transport.tcp.port`| 绑定端口范围. 默认 `9300-9400`.    
`transport.publish_port`| 与该节点通信时，群集中的其他节点应该使用的端口。 当群集节点位于代理或防火墙后面时，这很有用`transport.tcp.port`不能直接从外部寻址。 默认为通过`transport.tcp.port`分配的实际端口。
`transport.bind_host`| 将传输服务绑定到的主机地址。 默认为`transport.host`（如果设置）或`network.bind_host`。    
`transport.publish_host`|公开集群中要连接到的节点的主机地址。 默认为`transport.host`（如果设置）或`network.publish_host`。
`transport.host`| 用于设置`transport.bind_host` 和`transport.publish_host` 默认设置 `transport.host` 或 `network.host`.    
`transport.tcp.connect_timeout`| 连接超时设置，默认是 `30s`.    
`transport.tcp.compress`| 设置 `true` 会在各个结节间启用压缩算法(LZF). 默认是`false`.    
`transport.ping_schedule`| 定时的ping节点信息，保证节点是活跃状态.默认是`5s` ， `-1` 是禁用 
  
可以参考其他模块 [network settings](modules-network.html).

#### TCP传输配置 TCP Transport Profiles

ES可以通过设置绑定多个端口用于不同类型的接口。
    
    transport.profiles.default.port: 9300-9400
    transport.profiles.default.bind_host: 10.0.0.1
    transport.profiles.client.port: 9500-9600
    transport.profiles.client.bind_host: 192.168.0.1
    transport.profiles.dmz.port: 9700-9800
    transport.profiles.dmz.bind_host: 172.16.1.2

`default`配置文件是一个特殊的设置。 它用作任何其他配置文件的后备，如果这些没有特定的配置设置。 请注意，默认配置文件是群集中的其他节点通常会连接到此节点的方式。 将来这个功能将允许通过多个接口实现节点到节点的通信。

The following parameters can be configured like that

  * `port`: 绑定端口
  * `bind_host`: 绑定地址
  * `publish_host`: 公开内部接口的地址
  * `tcp_no_delay`: 配置`TCP_NO_DELAY` socket （无延时）
  * `tcp_keep_alive`: 配置 `SO_KEEPALIVE` socket（保持连接） 
  * `reuse_address`: 配置 `SO_REUSEADDR` socket （拒绝连接的地址） 
  * `tcp_send_buffer_size`: 配置socket发送缓冲区的大小。 
  * `tcp_receive_buffer_size`: 配置socket接收缓冲区的大小。



### 传输追踪 Transport Tracer

传输模块有一个专用的跟踪记录器，当被激活时记录进出的请求。 日志可以通过将`org.elasticsearch.transport.TransportService.tracer`记录器的级别设置为`TRACE`来动态激活：

    PUT _cluster/settings
    {
       "transient" : {
          "logger.org.elasticsearch.transport.TransportService.tracer" : "TRACE"
       }
    }

您还可以使用一组包含和排除通配符模式来控制将跟踪哪些操作。 默认情况下，除故障检测外，每个请求都将被跟踪：
    
    PUT _cluster/settings
    {
       "transient" : {
          "transport.tracer.include" : "*",
          "transport.tracer.exclude" : "internal:discovery/zen/fd*"
       }
    }
