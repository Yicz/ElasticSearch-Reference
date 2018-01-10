## 集群级别分片分配 Cluster Level Shard Allocation

分片分配是将分片分配到节点的过程。这个过程会发生在初始化恢复，副本分片定位，和调整集群平衡（replica allocation）或者添加或新增节点的时候。

### 分片分配设置 Shard Allocation Settings

下面是控制分片分配和恢复的**动态设置**：

`cluster.routing.allocation.enable`
    
可以设置如下的类型：

  * `all` - (默认) 允许自动分配全部类型的分片 
  * `primaries` - 只允许主分片自动分配
  * `new_primaries` - 只允许新索引的主分片自动分配
  * `none` - 不允许分片的分配

这个动态设置在重启一个节点的恢复本地主分片的时候会失效，未分配主分片的重新启动的节点将立即恢复该主分区，假定其分配ID与集群状态中的一个活动分配ID相匹配。

`cluster.routing.allocation.node_concurrent_incoming_recoveries`
     
     允许在一个节点上发生多少个分片并发恢复。 即进行的恢复是在节点上分配目标分片（最有可能是副本，除非分片重新分配）的恢复。 默认为`2`。
`cluster.routing.allocation.node_concurrent_outgoing_recoveries`

     允许在一个节点上发生多少个并发传出分片恢复。 外出恢复是源节点（最有可能是主节点，除非分片重新定位）在节点上分配的恢复。 默认为`2`。     
`cluster.routing.allocation.node_concurrent_recoveries`

     设置 `cluster.routing.allocation.node_concurrent_incoming_recoveries` 和 `cluster.routing.allocation.node_concurrent_outgoing_recoveries`的快捷方式. 
`cluster.routing.allocation.node_initial_primaries_recoveries`
     
     虽然复制副本的恢复发生在网络上，但重新启动节点后恢复未分配的主分片将使用本地磁盘中的数据。 这会很快，以便在同一个节点上可以同时发生更多的初始主恢复。 默认为`4`。
`cluster.routing.allocation.same_shard.host`
     
     允许执行检查以防止根据主机名和主机地址在单个主机上分配同一分片的多个实例。 默认为`false`，这意味着默认情况下不执行检查。 此设置仅适用于在同一台计算机上启动多个节点的情况。

### 分片重平衡设置 Shard Rebalancing Settings

下面是控制集群分片的重平衡的动态设置：

`cluster.routing.rebalance.enable`
    

设置接收接下的参数：

  * `all` \- (默认) 允许所有类型的分片进行动态调整. 
  * `primaries` \- 只允许主分片进行动态调整. 
  * `replicas` \- 只允副本分片进行动态调整. 
  * `none` \- 不允许分片进行动态调整. 



`cluster.routing.allocation.allow_rebalance`
    
指定什么时间可以进行调整：

  * `always` \- 允许所有时间。
  * `indices_primaries_active` \- 只允许全部主分都配在激活的状态下进行调整。
  * `indices_all_active` \- (默认) 当分片（包含副本分片）已经在集群中已经分配的时候。 



`cluster.routing.allocation.cluster_concurrent_rebalance`
     允许分片并发的重调整个数。默认是`2`. 请注意，此设置仅控制由于群集中的不平衡而导致的并发分片重新分配的数量。 此设置不会限制[allocation filtering](allocation-filtering.html)或[forced awareness](allocation-awareness.html#forced-awareness)

### 分片平横拓展 Shard Balancing Heuristics


The following settings are used together to determine where to place each shard. The cluster is balanced when no allowed action can bring the weights of each node closer together by more then the `balance.threshold`.

`cluster.routing.allocation.balance.shard`
     Defines the weight factor for shards allocated on a node (float). Defaults to `0.45f`. Raising this raises the tendency to equalize the number of shards across all nodes in the cluster. 
`cluster.routing.allocation.balance.index`
     Defines a factor to the number of shards per index allocated on a specific node (float). Defaults to `0.55f`. Raising this raises the tendency to equalize the number of shards per index across all nodes in the cluster. 
`cluster.routing.allocation.balance.threshold`
     Minimal optimization value of operations that should be performed (non negative float). Defaults to `1.0f`. Raising this will cause the cluster to be less aggressive about optimizing the shard balance. 

![Note](/images/icons/note.png)

Regardless of the result of the balancing algorithm, rebalancing might not be allowed due to forced awareness or allocation filtering.
