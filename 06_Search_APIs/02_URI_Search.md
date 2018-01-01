## 使用URI查询URI Search

查询请求可以纯使用带有请求参数的URI进行查询。但并不能包含所有的查询条件。它只是提供随时进行`curl`测试，下面是一个例子：
    
    GET twitter/tweet/_search?q=user:kimchy

响应如下:
    
    {
        "timed_out": false,
        "took": 62,
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
                        "date" : "2009-11-15T14:12:12",
                        "message" : "trying out Elasticsearch",
                        "likes": 0
                    }
                }
            ]
        }
    }

### 参数 Parameters

在URI请求中允许使用的参数：

名称 | 描述  
---|---  
`q`| 查询字符串（映射到`query_string`查询，更多详细信息请参见[_Query String Query_](query-dsl-query-string-query.html)）
`df`| 在查询中未定义字段前缀时使用的默认字段。    
`analyzer`| 分析查询字符串时要使用的分析器名称。
`analyze_wildcard`| 是否应该分析通配符和前缀查询. 默认 `false`.    
`batched_reduce_size`|在协调节点上应该一次减少分片结果的数量。如果请求中的潜在分片数可能很大，则应该使用此值作为保护机制来减少每个搜索请求的内存开销。
`default_operator`| 默认查询条件连接词,  值为`AND` 或 `OR`. 默认 `OR`.    
`lenient`| 如果设置为true将导致基于格式的失败（如提供文本到数字字段）被忽略. 默认 false.    
`explain`| 对于每个命中，包含如何计算命中计分的解释。    
`_source`| Set to `false` to disable retrieval of the `_source` field. You can also retrieve part of the document by using `_source_include` & `_source_exclude` (see the [request body](search-request-source-filtering.html) documentation for more details)    
`stored_fields`| 选择性存储的文件字段返回给每个命中，逗号分隔。 不指定任何值将导致没有字段返回。   
`sort`| 排序。 可以是`fieldName`或`fieldName：asc/desc`的形式。`fieldName`可以是文档中的实际字段，也可以是特殊的`_score`名称以表示根据分数排序。 可以有几个“sort”参数（顺序是重要的）。
`track_scores`| 排序时，设置为“true”，以便继续跟踪分数并将它们作为每个命中的一部分返回。
`timeout`|搜索超时，限制搜索请求在指定的时间值内执行，并在到期时累积至点的保留时间。 默认 `不超时`.    
`terminate_after`| 为每个分片收集的文档的最大数量，一旦达到该数量，查询执行将提前终止。 如果设置，响应将有一个布尔型字段“terminated_early”来指示查询执行是否实际已经terminate_early。 默认no terminate_after。  
`from`| 返回匹配返回文档的起始位置. 默认 `0`.    
`size`| 返回文档大小，默认`10`.    
`search_type`| 要执行的搜索操作的类型。 可以是`dfs_query_then_fetch`或`query_then_fetch`。 默认`query_then_fetch`。 有关可以执行的不同搜索类型的更多详细信息，请参阅[_查询类型 Search Type_](search-request-search-type.html)。
