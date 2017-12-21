## cat shards

The `shards` command is the detailed view of what nodes contain which shards. It will tell you if it’s a primary or replica, the number of docs, the bytes it takes on disk, and the node where it’s located.

Here we see a single index, with one primary shard and no replicas:
    
    
    GET _cat/shards

This will return
    
    
    twitter 0 p STARTED 3014 31.1mb 192.168.56.10 H5dfFeA
    twitter 0 r UNASSIGNED

### Index pattern

If you have many shards, you may wish to limit which indices show up in the output. You can always do this with `grep`, but you can save some bandwidth by supplying an index pattern to the end.
    
    
    GET _cat/shards/twitt*

Which will return the following
    
    
    twitter 0 p STARTED 3014 31.1mb 192.168.56.10 H5dfFeA
    twitter 0 r UNASSIGNED

### Relocation

Let’s say you’ve checked your health and you see a relocating shards. Where are they from and where are they going?
    
    
    GET _cat/shards

A relocating shard will be shown as follows
    
    
    twitter 0 p RELOCATING 3014 31.1mb 192.168.56.10 H5dfFeA -> -> 192.168.56.30 bGG90GE

### Shard states

Before a shard can be used, it goes through an `INITIALIZING` state. `shards` can show you which ones.
    
    
    GET _cat/shards

You can get the initializing state in the response like this
    
    
    twitter 0 p STARTED      3014 31.1mb 192.168.56.10 H5dfFeA
    twitter 0 r INITIALIZING    0 14.3mb 192.168.56.30 bGG90GE

If a shard cannot be assigned, for example you’ve overallocated the number of replicas for the number of nodes in the cluster, the shard will remain `UNASSIGNED` with the [reason code](cat-shards.html#reason-unassigned "Reasons for unassigned shardedit") `ALLOCATION_FAILED`.

You can use the shards API to find out that reason.
    
    
    GET _cat/shards?h=index,shard,prirep,state,unassigned.reason

The reason for an unassigned shard will be listed as the last field
    
    
    twitter 0 p STARTED    3014 31.1mb 192.168.56.10 H5dfFeA
    twitter 0 r STARTED    3014 31.1mb 192.168.56.30 bGG90GE
    twitter 0 r STARTED    3014 31.1mb 192.168.56.20 I8hydUG
    twitter 0 r UNASSIGNED ALLOCATION_FAILED

### Reasons for unassigned shard

These are the possible reasons for a shard to be in a unassigned state:

`INDEX_CREATED`

| 

Unassigned as a result of an API creation of an index.   
  
---|---  
  
`CLUSTER_RECOVERED`

| 

Unassigned as a result of a full cluster recovery.   
  
`INDEX_REOPENED`

| 

Unassigned as a result of opening a closed index.   
  
`DANGLING_INDEX_IMPORTED`

| 

Unassigned as a result of importing a dangling index.   
  
`NEW_INDEX_RESTORED`

| 

Unassigned as a result of restoring into a new index.   
  
`EXISTING_INDEX_RESTORED`

| 

Unassigned as a result of restoring into a closed index.   
  
`REPLICA_ADDED`

| 

Unassigned as a result of explicit addition of a replica.   
  
`ALLOCATION_FAILED`

| 

Unassigned as a result of a failed allocation of the shard.   
  
`NODE_LEFT`

| 

Unassigned as a result of the node hosting it leaving the cluster.   
  
`REROUTE_CANCELLED`

| 

Unassigned as a result of explicit cancel reroute command.   
  
`REINITIALIZED`

| 

When a shard moves from started back to initializing, for example, with shadow replicas.   
  
`REALLOCATED_REPLICA`

| 

A better replica location is identified and causes the existing replica allocation to be cancelled. 
