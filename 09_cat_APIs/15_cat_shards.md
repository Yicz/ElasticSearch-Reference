## 查看分片 cat shards

“shards”命令是哪个节点包含哪些分片的详细视图。 它会告诉你，如果它是一个主分片或副本分片，文档的数量，它在磁盘上的字节和它所在的节点。

在这里，我们看到一个索引，一个主分片，没有副本：    
    
    GET _cat/shards

返回
    
    
    twitter 0 p STARTED 3014 31.1mb 192.168.56.10 H5dfFeA
    twitter 0 r UNASSIGNED

### 索引匹配

如果你有许多分片，你可能希望限制在输出中显示的索引。 你可以用`grep（linux 命令）`来做到这一点，但是你可以通过提供索引模式来节省一些带宽。

    GET _cat/shards/twitt*

返回内容如下
    
    twitter 0 p STARTED 3014 31.1mb 192.168.56.10 H5dfFeA
    twitter 0 r UNASSIGNED

### Relocation

假设你已经检查了你的健康状况，你看到了一个迁移的分片。 他们从哪里来，他们去哪里？
    
    
    GET _cat/shards

重新定位分片将显示如下：    
    
    twitter 0 p RELOCATING 3014 31.1mb 192.168.56.10 H5dfFeA -> -> 192.168.56.30 bGG90GE

### 分片状态 Shard states

在一个分片可以被使用之前，它会变成`INITIALIZING`状态，`_cat/shards`可以展示是哪一个分片。

    GET _cat/shards

你可以像下面的内容一样获取`INITIALIZING`状态的分片信息：    
    
    twitter 0 p STARTED      3014 31.1mb 192.168.56.10 H5dfFeA
    twitter 0 r INITIALIZING    0 14.3mb 192.168.56.30 bGG90GE

如果无法分配分片，例如，您已经为集群中的节点数量分配了复制副本的数量，则分片将保持“UNASSIGNED”，并且[原因代码](cat-shards.html#reason-unassigned)为`ALLOCATION_FAILED`.

你可以使用`_cat/shards`找出原因：
    
    
    GET _cat/shards?h=index,shard,prirep,state,unassigned.reason

没有被分配的理由将会被列举出来：
    
    
    twitter 0 p STARTED    3014 31.1mb 192.168.56.10 H5dfFeA
    twitter 0 r STARTED    3014 31.1mb 192.168.56.30 bGG90GE
    twitter 0 r STARTED    3014 31.1mb 192.168.56.20 I8hydUG
    twitter 0 r UNASSIGNED ALLOCATION_FAILED

### 分片没有分配的原由 Reasons for unassigned shard

下面列举了分片没有被分配可能的理由：

`INDEX_CREATED`| 由于创建索引的API而未分配。     
---|---    
`CLUSTER_RECOVERED`| 由于完全集群恢复而未分配。    
`INDEX_REOPENED`| 由于打开一个关闭的索引而未分配。     
`DANGLING_INDEX_IMPORTED`| 作为导入空索引的结果未分配。    
`NEW_INDEX_RESTORED`| 作为恢复到新索引的结果未分配。    
`EXISTING_INDEX_RESTORED`| 由于恢复到已关闭的索引而未分配。    
`REPLICA_ADDED`| 由于显式添加副本分片而未分配.     
`ALLOCATION_FAILED`|由于分片分配失败而未分配。   
`NODE_LEFT`| 由于承载它离开集群的节点而未分配。    
`REROUTE_CANCELLED`| 作为显式取消重新路由命令的结果取消分配。    
`REINITIALIZED`| 当分片从开始移动到初始化时，例如，使用影子副本。    
`REALLOCATED_REPLICA`| 确定更好的副本位置并使现有的副本分配被取消。