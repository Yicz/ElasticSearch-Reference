## Indices Shard Stores

Provides store information for shard copies of indices. Store information reports on which nodes shard copies exist, the shard copy allocation ID, a unique identifier for each shard copy, and any exceptions encountered while opening the shard index or from earlier engine failure.

By default, only lists store information for shards that have at least one unallocated copy. When the cluster health status is yellow, this will list store information for shards that have at least one unassigned replica. When the cluster health status is red, this will list store information for shards, which has unassigned primaries.

Endpoints include shard stores information for a specific index, several indices, or all:
    
    
    curl -XGET 'http://localhost:9200/test/_shard_stores'
    curl -XGET 'http://localhost:9200/test1,test2/_shard_stores'
    curl -XGET 'http://localhost:9200/_shard_stores'

The scope of shards to list store information can be changed through `status` param. Defaults to _yellow_ and _red_. _yellow_ lists store information of shards with at least one unassigned replica and _red_ for shards with unassigned primary shard. Use _green_ to list store information for shards with all assigned copies.
    
    
    curl -XGET 'http://localhost:9200/_shard_stores?status=green'

Response:

The shard stores information is grouped by indices and shard ids.
    
    
    {
        ...
       "0": { ![](images/icons/callouts/1.png)
            "stores": [ ![](images/icons/callouts/2.png)
                {
                    "sPa3OgxLSYGvQ4oPs-Tajw": { ![](images/icons/callouts/3.png)
                        "name": "node_t0",
                        "transport_address": "local[1]",
                        "attributes": {
                            "mode": "local"
                        }
                    },
                    "allocation_id": "2iNySv_OQVePRX-yaRH_lQ", ![](images/icons/callouts/4.png)
                    "legacy_version": 42, ![](images/icons/callouts/5.png)
                    "allocation" : "primary" | "replica" | "unused", ![](images/icons/callouts/6.png)
                    "store_exception": ... ![](images/icons/callouts/7.png)
                },
                ...
            ]
       },
        ...
    }

![](images/icons/callouts/1.png)

| 

The key is the corresponding shard id for the store information   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

A list of store information for all copies of the shard   
  
![](images/icons/callouts/3.png)

| 

The node information that hosts a copy of the store, the key is the unique node id.   
  
![](images/icons/callouts/4.png)

| 

The allocation id of the store copy   
  
![](images/icons/callouts/5.png)

| 

The version of the store copy (available only for legacy shard copies that have not yet been active in a current version of Elasticsearch)   
  
![](images/icons/callouts/6.png)

| 

The status of the store copy, whether it is used as a primary, replica or not used at all   
  
![](images/icons/callouts/7.png)

| 

Any exception encountered while opening the shard index or from earlier engine failure 
