## Cluster Allocation Explain API

The purpose of the cluster allocation explain API is to provide explanations for shard allocations in the cluster. For unassigned shards, the explain API provides an explanation for why the shard is unassigned. For assigned shards, the explain API provides an explanation for why the shard is remaining on its current node and has not moved or rebalanced to another node. This API can be very useful when attempting to diagnose why a shard is unassigned or why a shard continues to remain on its current node when you might expect otherwise.

### Explain API Request

To explain the allocation of a shard, first an index should exist:
    
    
    PUT /myindex

And then the allocation for shards of that index can be explained:
    
    
    GET /_cluster/allocation/explain
    {
      "index": "myindex",
      "shard": 0,
      "primary": true
    }

Specify the `index` and `shard` id of the shard you would like an explanation for, as well as the `primary` flag to indicate whether to explain the primary shard for the given shard id or one of its replica shards. These three request parameters are required.

You may also specify an optional `current_node` request parameter to only explain a shard that is currently located on `current_node`. The `current_node` can be specified as either the node id or node name.
    
    
    GET /_cluster/allocation/explain
    {
      "index": "myindex",
      "shard": 0,
      "primary": false,
      "current_node": "nodeA"                         ![](images/icons/callouts/1.png)
    }

![](images/icons/callouts/1.png)

| 

The node where shard 0 currently has a replica on   
  
---|---  
  
You can also have Elasticsearch explain the allocation of the first unassigned shard that it finds by sending an empty body for the request:
    
    
    GET /_cluster/allocation/explain

### Explain API Response

This div includes examples of the cluster allocation explain API response output under various scenarios.

The API response for an unassigned shard:
    
    
    {
      "index" : "idx",
      "shard" : 0,
      "primary" : true,
      "current_state" : "unassigned",                 ![](images/icons/callouts/1.png)
      "unassigned_info" : {
        "reason" : "INDEX_CREATED",                   ![](images/icons/callouts/2.png)
        "at" : "2017-01-04T18:08:16.600Z",
        "last_allocation_status" : "no"
      },
      "can_allocate" : "no",                          ![](images/icons/callouts/3.png)
      "allocate_explanation" : "cannot allocate because allocation is not permitted to any of the nodes",
      "node_allocation_decisions" : [
        {
          "node_id" : "8qt2rY-pT6KNZB3-hGfLnw",
          "node_name" : "node_t1",
          "transport_address" : "127.0.0.1:9401",
          "node_decision" : "no",                     ![](images/icons/callouts/4.png)
          "weight_ranking" : 1,
          "deciders" : [
            {
              "decider" : "filter",                   ![](images/icons/callouts/5.png)
              "decision" : "NO",
              "explanation" : "node does not match index setting [index.routing.allocation.include] filters [_name:\"non_existent_node\"]"  ![](images/icons/callouts/6.png)
            }
          ]
        },
        {
          "node_id" : "7Wr-QxLXRLKDxhzNm50pFA",
          "node_name" : "node_t0",
          "transport_address" : "127.0.0.1:9400",
          "node_decision" : "no",
          "weight_ranking" : 2,
          "deciders" : [
            {
              "decider" : "filter",
              "decision" : "NO",
              "explanation" : "node does not match index setting [index.routing.allocation.include] filters [_name:\"non_existent_node\"]"
            }
          ]
        }
      ]
    }

![](images/icons/callouts/1.png)

| 

The current state of the shard   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The reason for the shard originally becoming unassigned   
  
![](images/icons/callouts/3.png)

| 

Whether to allocate the shard   
  
![](images/icons/callouts/4.png)

| 

Whether to allocate the shard to the particular node   
  
![](images/icons/callouts/5.png)

| 

The decider which led to the `no` decision for the node   
  
![](images/icons/callouts/6.png)

| 

An explanation as to why the decider returned a `no` decision, with a helpful hint pointing to the setting that led to the decision   
  
You can return information gathered by the cluster info service about disk usage and shard sizes by setting the `include_disk_info` parameter to `true`:
    
    
    GET /_cluster/allocation/explain?include_disk_info=true

Additionally, if you would like to include all decisions that were factored into the final decision, the `include_yes_decisions` parameter will return all decisions for each node:
    
    
    GET /_cluster/allocation/explain?include_yes_decisions=true

The default value for `include_yes_decisions` is `false`, which will only include the `no` decisions in the response. This is generally what you would want, as the `no` decisions indicate why a shard is unassigned or cannot be moved, and including all decisions include the `yes` ones adds a lot of verbosity to the API’s response output.

The API response output for an unassigned primary shard that had previously been allocated to a node in the cluster:
    
    
    {
      "index" : "idx",
      "shard" : 0,
      "primary" : true,
      "current_state" : "unassigned",
      "unassigned_info" : {
        "reason" : "NODE_LEFT",
        "at" : "2017-01-04T18:03:28.464Z",
        "details" : "node_left[OIWe8UhhThCK0V5XfmdrmQ]",
        "last_allocation_status" : "no_valid_shard_copy"
      },
      "can_allocate" : "no_valid_shard_copy",
      "allocate_explanation" : "cannot allocate because a previous copy of the primary shard existed but can no longer be found on the nodes in the cluster"
    }

The API response output for a replica that is unassigned due to delayed allocation:
    
    
    {
      "index" : "idx",
      "shard" : 0,
      "primary" : false,
      "current_state" : "unassigned",
      "unassigned_info" : {
        "reason" : "NODE_LEFT",
        "at" : "2017-01-04T18:53:59.498Z",
        "details" : "node_left[G92ZwuuaRY-9n8_tc-IzEg]",
        "last_allocation_status" : "no_attempt"
      },
      "can_allocate" : "allocation_delayed",
      "allocate_explanation" : "cannot allocate because the cluster is still waiting 59.8s for the departed node holding a replica to rejoin, despite being allowed to allocate the shard to at least one other node",
      "configured_delay" : "1m",                      ![](images/icons/callouts/1.png)
      "configured_delay_in_millis" : 60000,
      "remaining_delay" : "59.8s",                    ![](images/icons/callouts/2.png)
      "remaining_delay_in_millis" : 59824,
      "node_allocation_decisions" : [
        {
          "node_id" : "pmnHu_ooQWCPEFobZGbpWw",
          "node_name" : "node_t2",
          "transport_address" : "127.0.0.1:9402",
          "node_decision" : "yes"
        },
        {
          "node_id" : "3sULLVJrRneSg0EfBB-2Ew",
          "node_name" : "node_t0",
          "transport_address" : "127.0.0.1:9400",
          "node_decision" : "no",
          "store" : {                                 ![](images/icons/callouts/3.png)
            "matching_size" : "4.2kb",
            "matching_size_in_bytes" : 4325
          },
          "deciders" : [
            {
              "decider" : "same_shard",
              "decision" : "NO",
              "explanation" : "the shard cannot be allocated to the same node on which a copy of the shard already exists [[idx][0], node[3sULLVJrRneSg0EfBB-2Ew], [P], s[STARTED], a[id=eV9P8BN1QPqRc3B4PLx6cg]]"
            }
          ]
        }
      ]
    }

![](images/icons/callouts/1.png)

| 

The configured delay before allocating a replica shard that does not exist due to the node holding it leaving the cluster   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The remaining delay before allocating the replica shard   
  
![](images/icons/callouts/3.png)

| 

Information about the shard data found on a node   
  
The API response output for an assigned shard that is not allowed to remain on its current node and is required to move:
    
    
    {
      "index" : "idx",
      "shard" : 0,
      "primary" : true,
      "current_state" : "started",
      "current_node" : {
        "id" : "8lWJeJ7tSoui0bxrwuNhTA",
        "name" : "node_t1",
        "transport_address" : "127.0.0.1:9401"
      },
      "can_remain_on_current_node" : "no",            ![](images/icons/callouts/1.png)
      "can_remain_decisions" : [                      ![](images/icons/callouts/2.png)
        {
          "decider" : "filter",
          "decision" : "NO",
          "explanation" : "node does not match index setting [index.routing.allocation.include] filters [_name:\"non_existent_node\"]"
        }
      ],
      "can_move_to_other_node" : "no",                ![](images/icons/callouts/3.png)
      "move_explanation" : "cannot move shard to another node, even though it is not allowed to remain on its current node",
      "node_allocation_decisions" : [
        {
          "node_id" : "_P8olZS8Twax9u6ioN-GGA",
          "node_name" : "node_t0",
          "transport_address" : "127.0.0.1:9400",
          "node_decision" : "no",
          "weight_ranking" : 1,
          "deciders" : [
            {
              "decider" : "filter",
              "decision" : "NO",
              "explanation" : "node does not match index setting [index.routing.allocation.include] filters [_name:\"non_existent_node\"]"
            }
          ]
        }
      ]
    }

![](images/icons/callouts/1.png)

| 

Whether the shard is allowed to remain on its current node   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The deciders that factored into the decision of why the shard is not allowed to remain on its current node   
  
![](images/icons/callouts/3.png)

| 

Whether the shard is allowed to be allocated to another node   
  
The API response output for an assigned shard that remains on its current node because moving the shard to another node does not form a better cluster balance:
    
    
    {
      "index" : "idx",
      "shard" : 0,
      "primary" : true,
      "current_state" : "started",
      "current_node" : {
        "id" : "wLzJm4N4RymDkBYxwWoJsg",
        "name" : "node_t0",
        "transport_address" : "127.0.0.1:9400",
        "weight_ranking" : 1
      },
      "can_remain_on_current_node" : "yes",
      "can_rebalance_cluster" : "yes",                ![](images/icons/callouts/1.png)
      "can_rebalance_to_other_node" : "no",           ![](images/icons/callouts/2.png)
      "rebalance_explanation" : "cannot rebalance as no target node exists that can both allocate this shard and improve the cluster balance",
      "node_allocation_decisions" : [
        {
          "node_id" : "oE3EGFc8QN-Tdi5FFEprIA",
          "node_name" : "node_t1",
          "transport_address" : "127.0.0.1:9401",
          "node_decision" : "worse_balance",          ![](images/icons/callouts/3.png)
          "weight_ranking" : 1
        }
      ]
    }

![](images/icons/callouts/1.png)

| 

Whether rebalancing is allowed on the cluster   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Whether the shard can be rebalanced to another node   
  
![](images/icons/callouts/3.png)

| 

The reason the shard cannot be rebalanced to the node, in this case indicating that it offers no better balance than the current node 
