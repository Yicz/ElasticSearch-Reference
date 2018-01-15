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

Here the host columns and the active, rejected and completed suggest thread pool statistics are displayed.

All [built-in thread pools](modules-threadpool.html) and custom thread pools are available.

#### Thread Pool Fields

For each thread pool, you can load details about it by using the field names in the table below.

字段名 | 别名 | 描述  
---|---|---    
`type`| `t`| The current (\*) type of thread pool (`fixed` or `scaling`)    
`active`| `a`| The number of active threads in the current thread pool    
`size`| `s`| The number of threads in the current thread pool    
`queue`| `q`| The number of tasks in the queue for the current thread pool    
`queue_size`| `qs`| The maximum number of tasks permitted in the queue for the current thread pool    
`rejected`| `r`| The number of tasks rejected by the thread pool executor    
`largest`| `l`| The highest number of active threads in the current thread pool    
`completed`| `c`| The number of tasks completed by the thread pool executor    
`min`| `mi`| The configured minimum number of active threads allowed in the current thread pool    
`max`| `ma`| The configured maximum number of active threads allowed in the current thread pool    
`keep_alive`| `k`| The configured keep alive time for threads  
  
### 其他字段 Other Fields

In addition to details about each thread pool, it is also convenient to get an understanding of where those thread pools reside. As such, you can request other details like the `ip` of the responding node(s).

字段名 | 别名 | 描述  
---|---|---  
`node_id`| `id`| The unique node ID    
`ephemeral_id`| `eid`| The ephemeral node ID    
`pid`| `p`| The process ID of the running node    
`host`| `h`| The hostname for the current node    
`ip`| `i`| The IP address for the current node    
`port`| `po`| The bound transport port for the current node