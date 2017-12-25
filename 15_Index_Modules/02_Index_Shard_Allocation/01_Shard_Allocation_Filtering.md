## Shard Allocation Filtering

Shard allocation filtering allows you to specify which nodes are allowed to host the shards of a particular index.

![Note](images/icons/note.png)

The per-index shard allocation filters explained below work in conjunction with the cluster-wide allocation filters explained in [Cluster Level Shard Allocation](shards-allocation.html).

It is possible to assign arbitrary metadata attributes to each node at startup. For instance, nodes could be assigned a `rack` and a `size` attribute as follows:
    
    
    bin/elasticsearch -Enode.attr.rack=rack1 -Enode.attr.size=big  ![](images/icons/callouts/1.png)

![](images/icons/callouts/1.png)

| 

These attribute settings can also be specified in the `elasticsearch.yml` config file.   
  
---|---  
  
These metadata attributes can be used with the `index.routing.allocation.*` settings to allocate an index to a particular group of nodes. For instance, we can move the index `test` to either `big` or `medium` nodes as follows:
    
    
    PUT test/_settings
    {
      "index.routing.allocation.include.size": "big,medium"
    }

Alternatively, we can move the index `test` away from the `small` nodes with an `exclude` rule:
    
    
    PUT test/_settings
    {
      "index.routing.allocation.exclude.size": "small"
    }

Multiple rules can be specified, in which case all conditions must be satisfied. For instance, we could move the index `test` to `big` nodes in `rack1` with the following:
    
    
    PUT test/_settings
    {
      "index.routing.allocation.include.size": "big",
      "index.routing.allocation.include.rack": "rack1"
    }

![Note](images/icons/note.png)

If some conditions cannot be satisfied then shards will not be moved.

The following settings are _dynamic_ , allowing live indices to be moved from one set of nodes to another:

`index.routing.allocation.include.{attribute}`
     Assign the index to a node whose `{attribute}` has at least one of the comma-separated values. 
`index.routing.allocation.require.{attribute}`
     Assign the index to a node whose `{attribute}` has _all_ of the comma-separated values. 
`index.routing.allocation.exclude.{attribute}`
     Assign the index to a node whose `{attribute}` has _none_ of the comma-separated values. 

These special attributes are also supported:

`_name`

| 

Match nodes by node name   
  
---|---  
  
`_host_ip`

| 

Match nodes by host IP address (IP associated with hostname)   
  
`_publish_ip`

| 

Match nodes by publish IP address   
  
`_ip`

| 

Match either `_host_ip` or `_publish_ip`  
  
`_host`

| 

Match nodes by hostname   
  
All attribute values can be specified with wildcards, eg:
    
    
    PUT test/_settings
    {
      "index.routing.allocation.include._ip": "192.168.2.*"
    }