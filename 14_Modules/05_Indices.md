## Indices

The indices module controls index-related settings that are globally managed for all indices, rather than being configurable at a per-index level.

Available settings include:

[Circuit breaker](circuit-breaker.html "Circuit Breaker")
     Circuit breakers set limits on memory usage to avoid out of memory exceptions. 
[Fielddata cache](modules-fielddata.html "Fielddata")
     Set limits on the amount of heap used by the in-memory fielddata cache. 
[Node query cache](query-cache.html "Node Query Cache")
     Configure the amount heap used to cache queries results. 
[Indexing buffer](indexing-buffer.html "Indexing Buffer")
     Control the size of the buffer allocated to the indexing process. 
[Shard request cache](shard-request-cache.html "Shard request cache")
     Control the behaviour of the shard-level request cache. 
[Recovery](recovery.html "Indices Recovery")
     Control the resource limits on the shard recovery process. 
