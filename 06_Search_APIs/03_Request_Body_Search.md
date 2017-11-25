## Request Body Search

The search request can be executed with a search DSL, which includes the [Query DSL](query-dsl.html "Query DSL"), within its body. Here is an example:
    
    
    GET /twitter/tweet/_search
    {
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

And here is a sample response:
    
    
    {
        "took": 1,
        "timed_out": false,
        "_shards":{
            "total" : 1,
            "successful" : 1,
            "failed" : 0
        },
        "hits":{
            "total" : 1,
            "max_score": 1.3862944,
            "hits" : [
                {
                    "_index" : "twitter",
                    "_type" : "tweet",
                    "_id" : "0",
                    "_score": 1.3862944,
                    "_source" : {
                        "user" : "kimchy",
                        "message": "trying out Elasticsearch",
                        "date" : "2009-11-15T14:12:12",
                        "likes" : 0
                    }
                }
            ]
        }
    }

### Parameters

`timeout`

| 

A search timeout, bounding the search request to be executed within the specified time value and bail with the hits accumulated up to that point when expired. Defaults to no timeout. See [Time units.   
  
---|---  
  
`from`

| 

To retrieve hits from a certain offset. Defaults to `0`.   
  
`size`

| 

The number of hits to return. Defaults to `10`. If you do not care about getting some hits back but only about the number of matches and/or aggregations, setting the value to `0` will help performance.   
  
`search_type`

| 

The type of the search operation to perform. Can be `dfs_query_then_fetch` or `query_then_fetch`. Defaults to `query_then_fetch`. See [_Search Type_](search-request-search-type.html "Search Type") for more.   
  
`request_cache`

| 

Set to `true` or `false` to enable or disable the caching of search results for requests where `size` is 0, ie aggregations and suggestions (no top hits returned). See [Shard request cache](shard-request-cache.html "Shard request cache").   
  
`terminate_after`

| 

The maximum number of documents to collect for each shard, upon reaching which the query execution will terminate early. If set, the response will have a boolean field `terminated_early` to indicate whether the query execution has actually terminated_early. Defaults to no terminate_after.   
  
`batched_reduce_size`

| 

The number of shard results that should be reduced at once on the coordinating node. This value should be used as a protection mechanism to reduce the memory overhead per search request if the potential number of shards in the request can be large.   
  
Out of the above, the `search_type` and the `request_cache` must be passed as query-string parameters. The rest of the search request should be passed within the body itself. The body content can also be passed as a REST parameter named `source`.

Both HTTP GET and HTTP POST can be used to execute search with body. Since not all clients support GET with body, POST is allowed as well.

### Fast check for any matching docs

In case we only want to know if there are any documents matching a specific query, we can set the `size` to `0` to indicate that we are not interested in the search results. Also we can set `terminate_after` to `1` to indicate that the query execution can be terminated whenever the first matching document was found (per shard).
    
    
    GET /_search?q=message:elasticsearch&size=0&terminate_after=1

The response will not contain any hits as the `size` was set to `0`. The `hits.total` will be either equal to `0`, indicating that there were no matching documents, or greater than `0` meaning that there were at least as many documents matching the query when it was early terminated. Also if the query was terminated early, the `terminated_early` flag will be set to `true` in the response.
    
    
    {
      "took": 3,
      "timed_out": false,
      "terminated_early": true,
      "_shards": {
        "total": 1,
        "successful": 1,
        "failed": 0
      },
      "hits": {
        "total": 1,
        "max_score": 0.0,
        "hits": []
      }
    }
