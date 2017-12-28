## 使用请求体查询 Request Body Search

搜索请求可以使用搜索DSL来执行，搜索DSL在其请求体中包括[查询结构语言 Query DSL](query-dsl.html)。 这里是一个例子：
    
    GET /twitter/tweet/_search
    {
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

响应：
    
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

### 参数

`timeout`| 搜索超时，限制搜索请求在指定的时间值内执行，并在到期时累积至点的保留时间。 默认没有超时。 参见[时间单位]()。    
---|---    
`from`| 从特定的偏移量中返回匹配值。 默认为“0”。   
`size`| 要返回命中文档数。 默认为`10`。 如果你不关心返回的命中文档，只关心匹配数/聚合的数量，将值设置为`0`将有助于执行性能。
`search_type`| 要执行的搜索操作的类型。 可以是`dfs_query_then_fetch`或`query_then_fetch`。 默认`query_then_fetch`。 有关可以执行的不同搜索类型的更多详细信息，请参阅[_查询类型 Search Type_](search-request-search-type.html)。
`request_cache`| 设置为`true`或`fals`”来启用或禁用请求的搜索结果`size`为0的的缓存，即聚合和建议（不返回命中文档）。请参阅[分片请求缓存](shard-request-cache.html).  
`terminate_after`|为每个分片收集的文档的最大数量，一旦达到该数量，查询执行将提前终止。 如果设置，响应将有一个布尔型字段“terminated_early”来指示查询执行是否实际已经terminate_early。 默认`no terminate_after`。       
`batched_reduce_size`| 在协调节点上应该一次减少分片结果的数量。如果请求中的潜在分片数可能很大，则应该使用此值作为保护机制来减少每个搜索请求的内存开销。
  
除此之外，`search_type`和`request_cache`必须作为查询字符串参数传递。 搜索请求的其余部分应该在主体内传递。 主体内容也可以作为名为`source`的REST参数传递。

HTTP GET和HTTP POST都可以用来执行搜索正文。 由于不是所有的客户端都支持GET，所以POST也是允许的。

### 快速检查任何匹配的文档 Fast check for any matching docs

如果我们只想知道是否有任何匹配特定查询的文档，我们可以将`size`设置为'0'来表示我们对搜索结果不感兴趣。 此外，我们可以将`terminate_after`设置为`1`，以表示只要找到第一个匹配文档（每个分片）就可以终止查询执行。
    
    
    GET /_search?q=message:elasticsearch&size=0&terminate_after=1

当`size`被设置为'0'时，响应将不包含任何命中。`hits.total`将等于`0`，表示没有匹配的文档，或者大于“0”，这意味着当提前终止时至少有与查询匹配的文档。同样，如果查询被提前终止，响应中的`terminated_early`标志将被设置为`true`。

    
    
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
