## Node

Any time that you start an instance of Elasticsearch, you are starting a _node_. A collection of connected nodes is called a [cluster](modules-cluster.html). If you are running a single node of Elasticsearch, then you have a cluster of one node.

Every node in the cluster can handle [HTTP](modules-http.html) and [Transport](modules-transport.html) traffic by default. The transport layer is used exclusively for communication between nodes and the [Java `TransportClient`](https://www.elastic.co/guide/en/elasticsearch/client/java-api/5.4/transport-client.html); the HTTP layer is used only by external REST clients.

All nodes know about all the other nodes in the cluster and can forward client requests to the appropriate node. Besides that, each node serves one or more purpose:

[Master-eligible node](modules-node.html#master-node)
     A node that has `node.master` set to `true` (default), which makes it eligible to be [elected as the _master_ node](modules-discovery-zen.html), which controls the cluster. 
[Data node](modules-node.html#data-node)
     A node that has `node.data` set to `true` (default). Data nodes hold data and perform data related operations such as CRUD, search, and aggregations. 
[Ingest node](ingest.html)
     A node that has `node.ingest` set to `true` (default). Ingest nodes are able to apply an [ingest pipeline](pipeline.html) to a document in order to transform and enrich the document before indexing. With a heavy ingest load, it makes sense to use dedicated ingest nodes and to mark the master and data nodes as `node.ingest: false`. 
[Tribe node](modules-tribe.html)
     A tribe node, configured via the `tribe.*` settings, is a special type of coordinating only node that can connect to multiple clusters and perform search and other operations across all connected clusters. 

By default a node is a master-eligible node and a data node, plus it can pre-process documents through ingest pipelines. This is very convenient for small clusters but, as the cluster grows, it becomes important to consider separating dedicated master-eligible nodes from dedicated data nodes.

![Note](images/icons/note.png)

### Coordinating node

Requests like search requests or bulk-indexing requests may involve data held on different data nodes. A search request, for example, is executed in two phases which are coordinated by the node which receives the client request — the _coordinating node_.

In the _scatter_ phase, the coordinating node forwards the request to the data nodes which hold the data. Each data node executes the request locally and returns its results to the coordinating node. In the _gather_ phase, the coordinating node reduces each data node’s results into a single global resultset.

Every node is implicitly a coordinating node. This means that a node that has all three `node.master`, `node.data` and `node.ingest` set to `false` will only act as a coordinating node, which cannot be disabled. As a result, such a node needs to have enough memory and CPU in order to deal with the gather phase.

### Master Eligible Node

The master node is responsible for lightweight cluster-wide actions such as creating or deleting an index, tracking which nodes are part of the cluster, and deciding which shards to allocate to which nodes. It is important for cluster health to have a stable master node.

Any master-eligible node (all nodes by default) may be elected to become the master node by the [master election process](modules-discovery-zen.html).

![Important](images/icons/important.png)

Master nodes must have access to the `data/` directory (just like `data` nodes) as this is where the cluster state is persisted between node restarts.

Indexing and searching your data is CPU-, memory-, and I/O-intensive work which can put pressure on a node’s resources. To ensure that your master node is stable and not under pressure, it is a good idea in a bigger cluster to split the roles between dedicated master-eligible nodes and dedicated data nodes.

While master nodes can also behave as [coordinating nodes](modules-node.html#coordinating-node) and route search and indexing requests from clients to data nodes, it is better _not_ to use dedicated master nodes for this purpose. It is important for the stability of the cluster that master-eligible nodes do as little work as possible.

To create a standalone master-eligible node, set:
    
    
    node.master: true ![](images/icons/callouts/1.png)
    node.data: false ![](images/icons/callouts/2.png)
    node.ingest: false ![](images/icons/callouts/3.png)

![](images/icons/callouts/1.png)

| 

The `node.master` role is enabled by default.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Disable the `node.data` role (enabled by default).   
  
![](images/icons/callouts/3.png)

| 

Disable the `node.ingest` role (enabled by default).   
  
#### Avoiding split brain with `minimum_master_nodes`

To prevent data loss, it is vital to configure the `discovery.zen.minimum_master_nodes` setting (which defaults to `1`) so that each master-eligible node knows the _minimum number of master-eligible nodes_ that must be visible in order to form a cluster.

To explain, imagine that you have a cluster consisting of two master-eligible nodes. A network failure breaks communication between these two nodes. Each node sees one master-eligible node… itself. With `minimum_master_nodes` set to the default of `1`, this is sufficient to form a cluster. Each node elects itself as the new master (thinking that the other master-eligible node has died) and the result is two clusters, or a _split brain_. These two nodes will never rejoin until one node is restarted. Any data that has been written to the restarted node will be lost.

Now imagine that you have a cluster with three master-eligible nodes, and `minimum_master_nodes` set to `2`. If a network split separates one node from the other two nodes, the side with one node cannot see enough master-eligible nodes and will realise that it cannot elect itself as master. The side with two nodes will elect a new master (if needed) and continue functioning correctly. As soon as the network split is resolved, the single node will rejoin the cluster and start serving requests again.

This setting should be set to a _quorum_ of master-eligible nodes:
    
    
    (master_eligible_nodes / 2) + 1

In other words, if there are three master-eligible nodes, then minimum master nodes should be set to `(3 / 2) + 1` or `2`:
    
    
    discovery.zen.minimum_master_nodes: 2 ![](images/icons/callouts/1.png)

![](images/icons/callouts/1.png)

| 

Defaults to `1`.   
  
---|---  
  
This setting can also be changed dynamically on a live cluster with the [cluster update settings API](cluster-update-settings.html):
    
    
    PUT _cluster/settings
    {
      "transient": {
        "discovery.zen.minimum_master_nodes": 2
      }
    }

![Tip](images/icons/tip.png)

An advantage of splitting the master and data roles between dedicated nodes is that you can have just three master-eligible nodes and set `minimum_master_nodes` to `2`. You never have to change this setting, no matter how many dedicated data nodes you add to the cluster.

### Data Node

Data nodes hold the shards that contain the documents you have indexed. Data nodes handle data related operations like CRUD, search, and aggregations. These operations are I/O-, memory-, and CPU-intensive. It is important to monitor these resources and to add more data nodes if they are overloaded.

The main benefit of having dedicated data nodes is the separation of the master and data roles.

To create a dedicated data node, set:
    
    
    node.master: false ![](images/icons/callouts/1.png)
    node.data: true ![](images/icons/callouts/2.png)
    node.ingest: false ![](images/icons/callouts/3.png)

![](images/icons/callouts/1.png)

| 

Disable the `node.master` role (enabled by default).   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `node.data` role is enabled by default.   
  
![](images/icons/callouts/3.png)

| 

Disable the `node.ingest` role (enabled by default).   
  
### Ingest Node

Ingest nodes can execute pre-processing pipelines, composed of one or more ingest processors. Depending on the type of operations performed by the ingest processors and the required resources, it may make sense to have dedicated ingest nodes, that will only perform this specific task.

To create a dedicated ingest node, set:
    
    
    node.master: false ![](images/icons/callouts/1.png)
    node.data: false ![](images/icons/callouts/2.png)
    node.ingest: true ![](images/icons/callouts/3.png)
    search.remote.connect: false ![](images/icons/callouts/4.png)

![](images/icons/callouts/1.png)

| 

Disable the `node.master` role (enabled by default).   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Disable the `node.data` role (enabled by default).   
  
![](images/icons/callouts/3.png)

| 

The `node.ingest` role is enabled by default.   
  
![](images/icons/callouts/4.png)

| 

Disable cross-cluster search (enabled by default).   
  
### Coordinating only node

If you take away the ability to be able to handle master duties, to hold data, and pre-process documents, then you are left with a _coordinating_ node that can only route requests, handle the search reduce phase, and distribute bulk indexing. Essentially, coordinating only nodes behave as smart load balancers.

Coordinating only nodes can benefit large clusters by offloading the coordinating node role from data and master-eligible nodes. They join the cluster and receive the full [cluster state](cluster-state.html), like every other node, and they use the cluster state to route requests directly to the appropriate place(s).

![Warning](images/icons/warning.png)

Adding too many coordinating only nodes to a cluster can increase the burden on the entire cluster because the elected master node must await acknowledgement of cluster state updates from every node! The benefit of coordinating only nodes should not be overstated — data nodes can happily serve the same purpose.

To create a dedicated coordinating node, set:
    
    
    node.master: false ![](images/icons/callouts/1.png)
    node.data: false ![](images/icons/callouts/2.png)
    node.ingest: false ![](images/icons/callouts/3.png)
    search.remote.connect: false ![](images/icons/callouts/4.png)

![](images/icons/callouts/1.png)

| 

Disable the `node.master` role (enabled by default).   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Disable the `node.data` role (enabled by default).   
  
![](images/icons/callouts/3.png)

| 

Disable the `node.ingest` role (enabled by default).   
  
![](images/icons/callouts/4.png)

| 

Disable cross-cluster search (enabled by default).   
  
## Node data path settings

### `path.data`

Every data and master-eligible node requires access to a data directory where shards and index and cluster metadata will be stored. The `path.data` defaults to `$ES_HOME/data` but can be configured in the `elasticsearch.yml` config file an absolute path or a path relative to `$ES_HOME` as follows:
    
    
    path.data:  /var/elasticsearch/data

Like all node settings, it can also be specified on the command line as:
    
    
    ./bin/elasticsearch -Epath.data=/var/elasticsearch/data

![Tip](images/icons/tip.png)

When using the `.zip` or `.tar.gz` distributions, the `path.data` setting should be configured to locate the data directory outside the Elasticsearch home directory, so that the home directory can be deleted without deleting your data! The RPM and Debian distributions do this for you already.

### `node.max_local_storage_nodes`

The [data path](modules-node.html#data-path) can be shared by multiple nodes, even by nodes from different clusters. This is very useful for testing failover and different configurations on your development machine. In production, however, it is recommended to run only one node of Elasticsearch per server.

By default, Elasticsearch is configured to prevent more than one node from sharing the same data path. To allow for more than one node (e.g., on your development machine), use the setting `node.max_local_storage_nodes` and set this to a positive integer larger than one.

![Warning](images/icons/warning.png)

Never run different node types (i.e. master, data) from the same data directory. This can lead to unexpected data loss.

## Other node settings

More node settings can be found in [Modules](modules.html). Of particular note are the [`cluster.name`](important-settings.html#cluster.name), the [`node.name`](important-settings.html#node.name) and the [network settings](modules-network.html).