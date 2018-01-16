## 查看线程池 cat thread pool

`thread_pool`命令显示每个节点的集群范围线程池统计信息。 默认情况下，为所有线程池返回活动队列和反驳回统计信息。
    
    
    % curl 192.168.56.10:9200/_cat/thread_pool
    0EWUhXe bulk                0 0 0
    0EWUhXe fetch_shard_started 0 0 0
    0EWUhXe fetch_shard_store   0 0 0
    0EWUhXe flush               0 0 0
    0EWUhXe force_merge         0 0 0
    0EWUhXe generic             0 0 0
    0EWUhXe get                 0 0 0
    0EWUhXe index               0 0 0
    0EWUhXe listener            0 0 0
    0EWUhXe management          1 0 0
    0EWUhXe refresh             0 0 0
    0EWUhXe search              0 0 0
    0EWUhXe snapshot            0 0 0
    0EWUhXe warmer              0 0 0

第一列是节点的名字:    
    
    node_name
    0EWUhXe

第二列是线程池的名字:  
    
    
    name
    bulk
    fetch_shard_started
    fetch_shard_store
    flush
    force_merge
    generic
    get
    index
    listener
    management
    refresh
    search
    snapshot
    warmer

第三列显示了活跃状态，队列和被驳回的线程池状态：
  
    
    active queue rejected
         0     0        0
         0     0        0
         0     0        0
         0     0        0
         0     0        0
         0     0        0
         0     0        0
         0     0        0
         0     0        0
         1     0        0
         0     0        0
         0     0        0
         0     0        0
         0     0        0

URL接受一个`thread_pool_patterns`的参数进行对返回内容的过滤,可以使用正则表示：
    
    
    % curl 'localhost:9200/_cat/thread_pool/generic?v&h=id,name,active,rejected,completed'
    id                     name    active rejected completed
    0EWUhXeBQtaVGlexUeVwMg generic      0        0        70

这里显示主机列和活动，拒绝和完成的线程池统计信息。

内置的线程池[built-in thread pools](modules-threadpool.html)和自定义的线程池都是通用的.

#### 线程池字段 Thread Pool Fields

对于每个线程池，可以使用下表中的字段名称加载关于它的详细信息。

字段名 | 别名 | 描述  
---|---|---    
`type`| `t`| 线程池的类型 (`fixed` or `scaling`)    
`active`| `a`| 当前线程池激活的线程数  
`size`| `s`| 线程池的大小   
`queue`| `q`| 线程池的相关任务队列 
`queue_size`| `qs`| 队列大小 
`rejected`| `r`| 被线程池丢弃的请求数量   
`largest`| `l`|  当前线程池的最大线程激活数量    
`completed`| `c`| 线程池已经完成的请求数量    
`min`| `mi`| 当前线程池允许最小的线程激活数量   
`max`| `ma`| 当前线程池允许最大的线程激活数量   
`keep_alive`| `k`| 线程池中线程存活时间 
  
### 其他字段 Other Fields

除了每个线程池的细节之外，了解这些线程池驻留的位置也很方便。 因此，您可以请求其他详细信息，例如响应节点的“ip”。

字段名 | 别名 | 描述  
---|---|---  
`node_id`| `id`| 节点id  
`ephemeral_id`| `eid`| The ephemeral node ID    
`pid`| `p`| 进程id   
`host`| `h`| 节点主机地址    
`ip`| `i`| 节点ip   
`port`| `po`| 节点传输端口