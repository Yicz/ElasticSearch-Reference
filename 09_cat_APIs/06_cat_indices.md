## cat indices

The `indices` command provides a cross-div of each index. This information **spans nodes**. For example:
    
    
    GET /_cat/indices/twi*?v&s=index

Might respond with:
    
    
    health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    yellow open   twitter  u8FNjxh8Rfy_awN11oDKYQ   1   1       1200            0     88.1kb         88.1kb
    green  open   twitter2 nYFWZEO7TUiOjLQXBaYJpA   5   0          0            0       260b           260b

We can tell quickly how many shards make up an index, the number of docs, deleted docs, primary store size, and total store size (all shards including replicas). All these exposed metrics come directly from Lucene APIs.

 **Notes:**

  1. As the number of documents and deleted documents shown in this are at the lucene level, it includes all the hidden documents (e.g. from nested documents) as well. 
  2. To get actual count of documents at the elasticsearch level, the recommended way is to use either the [_cat count_](cat-count.html) or the [_Count API_](search-count.html)



### Primaries

The index stats by default will show them for all of an index’s shards, including replicas. A `pri` flag can be supplied to enable the view of relevant stats in the context of only the primaries.

### Examples

Which indices are yellow?
    
    
    GET /_cat/indices?v&health=yellow

Which looks like:
    
    
    health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    yellow open   twitter  u8FNjxh8Rfy_awN11oDKYQ   1   1       1200            0     88.1kb         88.1kb

Which index has the largest number of documents?
    
    
    GET /_cat/indices?v&s=docs.count:desc

Which looks like:
    
    
    health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    yellow open   twitter  u8FNjxh8Rfy_awN11oDKYQ   1   1       1200            0     88.1kb         88.1kb
    green  open   twitter2 nYFWZEO7TUiOjLQXBaYJpA   5   0          0            0       260b           260b

How many merge operations have the shards for the `twitter` completed?
    
    
    GET /_cat/indices/twitter?pri&v&h=health,index,pri,rep,docs.count,mt

Might look like:
    
    
    health index   pri rep docs.count mt pri.mt
    yellow twitter   1   1 1200       16     16

How much memory is used per index?
    
    
    GET /_cat/indices?v&h=i,tm&s=tm:desc

Might look like:
    
    
    i         tm
    twitter   8.1gb
    twitter2  30.5kb
