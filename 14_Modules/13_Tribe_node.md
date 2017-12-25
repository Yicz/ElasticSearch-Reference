## Tribe node

![Warning](images/icons/warning.png)

### Deprecated in 5.4.0. 

The `tribe` node is deprecated in favour of [_Cross Cluster Search_](modules-cross-cluster-search.html) and will be removed in Elasticsearch 7.0. 

The _tribes_ feature allows a _tribe node_ to act as a federated client across multiple clusters.

The tribe node works by retrieving the cluster state from all connected clusters and merging them into a global cluster state. With this information at hand, it is able to perform read and write operations against the nodes in all clusters as if they were local. Note that a tribe node needs to be able to connect to each single node in every configured cluster.

The `elasticsearch.yml` config file for a tribe node just needs to list the clusters that should be joined, for instance:
    
    
    tribe:
        t1: ![](images/icons/callouts/1.png)
            cluster.name:   cluster_one
        t2: ![](images/icons/callouts/2.png)
            cluster.name:   cluster_two

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png)

| 

`t1` and `t2` are arbitrary names representing the connection to each cluster.   
  
---|---  
  
The example above configures connections to two clusters, name `t1` and `t2` respectively. The tribe node will create a [node client](modules-node.html) to connect each cluster using [unicast discovery](modules-discovery-zen.html#unicast) by default. Any other settings for the connection can be configured under `tribe.{name}`, just like the `cluster.name` in the example.

The merged global cluster state means that almost all operations work in the same way as a single cluster: distributed search, suggest, percolation, indexing, etc.

However, there are a few exceptions:

  * The merged view cannot handle indices with the same name in multiple clusters. By default it will pick one of them, see later for on_conflict options. 
  * Master level read operations (eg [_Cluster State_](cluster-state.html), [_Cluster Health_](cluster-health.html)) will automatically execute with a local flag set to true since there is no master. 
  * Master level write operations (eg [_Create Index_](indices-create-index.html)) are not allowed. These should be performed on a single cluster. 



The tribe node can be configured to block all write operations and all metadata operations with:
    
    
    tribe:
        blocks:
            write:    true
            metadata: true

The tribe node can also configure blocks on selected indices:
    
    
    tribe:
        blocks:
            write.indices:    hk*,ldn*
            metadata.indices: hk*,ldn*

When there is a conflict and multiple clusters hold the same index, by default the tribe node will pick one of them. This can be configured using the `tribe.on_conflict` setting. It defaults to `any`, but can be set to `drop` (drop indices that have a conflict), or `prefer_[tribeName]` to prefer the index from a specific tribe.

### Tribe node settings

The tribe node starts a node client for each listed cluster. The following configuration options are passed down from the tribe node to each node client:

  * `node.name` (used to derive the `node.name` for each node client) 
  * `network.host`
  * `network.bind_host`
  * `network.publish_host`
  * `transport.host`
  * `transport.bind_host`
  * `transport.publish_host`
  * `path.home`
  * `path.conf`
  * `path.logs`
  * `path.scripts`
  * `shield.*`



Almost any setting (except for `path.*`) may be configured at the node client level itself, in which case it will override any passed through setting from the tribe node. Settings you may want to set at the node client level include:

  * `network.host`
  * `network.bind_host`
  * `network.publish_host`
  * `transport.host`
  * `transport.bind_host`
  * `transport.publish_host`
  * `cluster.name`
  * `discovery.zen.ping.unicast.hosts`


    
    
    path.scripts:   some/path/to/config ![](images/icons/callouts/1.png)
    network.host:   192.168.1.5 ![](images/icons/callouts/2.png)
    
    tribe:
      t1:
        cluster.name:   cluster_one
      t2:
        cluster.name:   cluster_two
        network.host:   10.1.2.3 ![](images/icons/callouts/3.png)

![](images/icons/callouts/1.png)

| 

The `path.scripts` setting is inherited by both `t1` and `t2`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `network.host` setting is inherited by `t1`.   
  
![](images/icons/callouts/3.png)

| 

The `t3` node client overrides the inherited from the tribe node. 