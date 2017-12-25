## Indices

The indices module controls index-related settings that are globally managed for all indices, rather than being configurable at a per-index level.

Available settings include:

[Circuit breaker](circuit-breaker.html)
     Circuit breakers set limits on memory usage to avoid out of memory exceptions. 
[Fielddata cache](modules-fielddata.html)
     Set limits on the amount of heap used by the in-memory fielddata cache. 
[Node query cache](query-cache.html)
     Configure the amount heap used to cache queries results. 
[Indexing buffer](indexing-buffer.html)
     Control the size of the buffer allocated to the indexing process. 
[Shard request cache](shard-request-cache.html)
     Control the behaviour of the shard-level request cache. 
[Recovery](recovery.html)
     Control the resource limits on the shard recovery process. 
