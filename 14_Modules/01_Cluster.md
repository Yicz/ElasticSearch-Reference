## 集群 Cluster

主服务器的主要角色之一是决定将哪些分片分配给哪些节点，以及何时移动节点之间的分片以重新平衡集群。

有许多设置可用于控制分片分配过程：

  * [Cluster Level Shard Allocation](shards-allocation.html) 设置控制分配和重新平衡操作。
  * [Disk-based Shard Allocation](disk-allocator.html) 介绍了Elasticsearch如何考虑磁盘空间以及相关的设置。
  * [Shard Allocation Awareness](allocation-awareness.html) 强制感知控制如何在不同的机架或可用区域分配分片。
  * [Shard Allocation Filtering](allocation-filtering.html) 允许从分配中排除某些节点或节点组，以便它们可以退出。



除此之处，还有其他的设置 [miscellaneous cluster-level settings](misc-cluster.html).

以上全部的设置都是动态的，可以通过[cluster-update-settings](cluster-update-settings.html) API进行动态更新。
