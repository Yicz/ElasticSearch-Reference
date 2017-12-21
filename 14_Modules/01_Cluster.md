## Cluster

One of the main roles of the master is to decide which shards to allocate to which nodes, and when to move shards between nodes in order to rebalance the cluster.

There are a number of settings available to control the shard allocation process:

  * [Cluster Level Shard Allocation](shards-allocation.html "Cluster Level Shard Allocation") lists the settings to control the allocation and rebalancing operations. 
  * [Disk-based Shard Allocation](disk-allocator.html "Disk-based Shard Allocation") explains how Elasticsearch takes available disk space into account, and the related settings. 
  * [Shard Allocation Awareness](allocation-awareness.html "Shard Allocation Awareness") and [Forced Awareness control how shards can be distributed across different racks or availability zones. 
  * [Shard Allocation Filtering](allocation-filtering.html "Shard Allocation Filtering") allows certain nodes or groups of nodes excluded from allocation so that they can be decommissioned. 



Besides these, there are a few other [miscellaneous cluster-level settings](misc-cluster.html "Miscellaneous cluster settings").

All of the settings in this div are _dynamic_ settings which can be updated on a live cluster with the [cluster-update-settings](cluster-update-settings.html "Cluster Update Settings") API.
