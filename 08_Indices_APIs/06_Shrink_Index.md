## Shrink Index

The shrink index API allows you to shrink an existing index into a new index with fewer primary shards. The requested number of primary shards in the target index must be a factor of the number of shards in the source index. For example an index with `8` primary shards can be shrunk into `4`, `2` or `1` primary shards or an index with `15` primary shards can be shrunk into `5`, `3` or `1`. If the number of shards in the index is a prime number it can only be shrunk into a single primary shard. Before shrinking, a (primary or replica) copy of every shard in the index must be present on the same node.

Shrinking works as follows:

  * First, it creates a new target index with the same definition as the source index, but with a smaller number of primary shards. 
  * Then it hard-links segments from the source index into the target index. (If the file system doesn’t support hard-linking, then all segments are copied into the new index, which is a much more time consuming process.) 
  * Finally, it recovers the target index as though it were a closed index which had just been re-opened. 



### Preparing an index for shrinking

In order to shrink an index, the index must be marked as read-only, and a (primary or replica) copy of every shard in the index must be relocated to the same node and have [health](cluster-health.html) `green`.

These two conditions can be achieved with the following request:
    
    
    PUT /my_source_index/_settings
    {
      "settings": {
        "index.routing.allocation.require._name": "shrink_node_name", ![](images/icons/callouts/1.png)
        "index.blocks.write": true ![](images/icons/callouts/2.png)
      }
    }

![](images/icons/callouts/1.png)

| 

Forces the relocation of a copy of each shard to the node with name `shrink_node_name`. See [Shard Allocation Filtering](shard-allocation-filtering.html) for more options.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Prevents write operations to this index while still allowing metadata changes like deleting the index.   
  
It can take a while to relocate the source index. Progress can be tracked with the [`_cat recovery` API](cat-recovery.html), or the [`cluster health` API](cluster-health.html) can be used to wait until all shards have relocated with the `wait_for_no_relocating_shards` parameter.

### Shrinking an index

To shrink `my_source_index` into a new index called `my_target_index`, issue the following request:
    
    
    POST my_source_index/_shrink/my_target_index

The above request returns immediately once the target index has been added to the cluster state — it doesn’t wait for the shrink operation to start.

![Important](images/icons/important.png)

Indices can only be shrunk if they satisfy the following requirements:

  * the target index must not exist 
  * The index must have more primary shards than the target index. 
  * The number of primary shards in the target index must be a factor of the number of primary shards in the source index. The source index must have more primary shards than the target index. 
  * The index must not contain more than `2,147,483,519` documents in total across all shards that will be shrunk into a single shard on the target index as this is the maximum number of docs that can fit into a single shard. 
  * The node handling the shrink process must have sufficient free disk space to accommodate a second copy of the existing index. 



The `_shrink` API is similar to the [`create index` API](indices-create-index.html) and accepts `settings` and `aliases` parameters for the target index:
    
    
    POST my_source_index/_shrink/my_target_index
    {
      "settings": {
        "index.number_of_replicas": 1,
        "index.number_of_shards": 1, ![](images/icons/callouts/1.png)
        "index.codec": "best_compression" ![](images/icons/callouts/2.png)
      },
      "aliases": {
        "my_search_indices": {}
      }
    }

![](images/icons/callouts/1.png)

| 

The number of shards in the target index. This must be a factor of the number of shards in the source index.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Best compression will only take affect when new writes are made to the index, such as when [force-merging](indices-forcemerge.html) the shard to a single segment.   
  
![Note](images/icons/note.png)

Mappings may not be specified in the `_shrink` request, and all `index.analysis.*` and `index.similarity.*` settings will be overwritten with the settings from the source index.

### Monitoring the shrink process

The shrink process can be monitored with the [`_cat recovery` API](cat-recovery.html), or the [`cluster health` API](cluster-health.html) can be used to wait until all primary shards have been allocated by setting the `wait_for_status` parameter to `yellow`.

The `_shrink` API returns as soon as the target index has been added to the cluster state, before any shards have been allocated. At this point, all shards are in the state `unassigned`. If, for any reason, the target index can’t be allocated on the shrink node, its primary shard will remain `unassigned` until it can be allocated on that node.

Once the primary shard is allocated, it moves to state `initializing`, and the shrink process begins. When the shrink operation completes, the shard will become `active`. At that point, Elasticsearch will try to allocate any replicas and may decide to relocate the primary shard to another node.

### Wait For Active Shards

Because the shrink operation creates a new index to shrink the shards to, the [wait for active shards](indices-create-index.html#create-index-wait-for-active-shards) setting on index creation applies to the shrink index action as well.