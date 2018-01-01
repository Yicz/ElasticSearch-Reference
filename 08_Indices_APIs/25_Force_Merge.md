## Force Merge

The force merge API allows to force merging of one or more indices through an API. The merge relates to the number of segments a Lucene index holds within each shard. The force merge operation allows to reduce the number of segments by merging them.

This call will block until the merge is complete. If the http connection is lost, the request will continue in the background, and any new requests will block until the previous force merge is complete.
    
    
    POST /twitter/_forcemerge

### Request Parameters

The force merge API accepts the following request parameters:

`max_num_segments`| The number of segments to merge to. To fully merge the index, set it to `1`. Defaults to simply checking if a mergeneeds to execute, and if so, executes it.     
---|---  
`only_expunge_deletes`| Should the merge process only expunge segments with deletes in it. In Lucene, a document is not deleted from asegment, just marked as deleted. During a merge process of segments, a new segment is created that does not have thosedeletes. This flag allows to only merge segments that have deletes. Defaults to `false`. Note that this won’t overridethe `index.merge.policy.expunge_deletes_allowed` threshold.     
`flush`| Should a flush be performed after the forced merge. Defaults to `true`.   
  
### Multi Index

The force merge API can be applied to more than one index with a single call, or even on `_all` the indices.
    
    
    POST /kimchy,elasticsearch/_forcemerge
    
    POST /_forcemerge
