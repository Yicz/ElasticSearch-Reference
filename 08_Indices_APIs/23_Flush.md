## Flush

The flush API allows to flush one or more indices through an API. The flush process of an index basically frees memory from the index by flushing data to the index storage and clearing the internal [transaction log](index-modules-translog.html). By default, Elasticsearch uses memory heuristics in order to automatically trigger flush operations as required in order to clear memory.
    
    
    POST twitter/_flush

### Request Parameters

The flush API accepts the following request parameters:

`wait_if_ongoing`| If set to `true` the flush operation will block until the flush can be executed if another flush operation is alreadyexecuting. The default is `false` and will cause an exception to be thrown on the shard level if another flushoperation is already running.     
---|---    
`force`| Whether a flush should be forced even if it is not necessarily needed ie. if no changes will be committed to theindex. This is useful if transaction log IDs should be incremented even if no uncommitted changes are present. (This setting can be considered as internal)   
  
### Multi Index

The flush API can be applied to more than one index with a single call, or even on `_all` the indices.
    
    
    POST kimchy,elasticsearch/_flush
    
    POST _flush
