# Search APIs

大部分的查询接口都支持[多索引（multi-index）, 多类型（multi-type）](search-search.html#search-multi-index-type )的操作，除[_Explain API_](search-explain.html)接口外。

## Routing

当执行一个查询的时候,ES会广播到所有的索引（在复制分片中进行轮询），我们可以通过`routing`参数，进行控制查询的分片，例如，建立下面的tweet文档的时候，使用了`routing`参数指定根据`user_name`进行路由:
    
    POST /twitter/tweet?routing=kimchy
    {
        "user" : "kimchy",
        "postDate" : "2009-11-15T14:12:12",
        "message" : "trying out Elasticsearch"
    }

在这个例子中，如果我们想查询使用了指定`routing`路由参数的twwets,同样，当我们查询回相关的节点的时候，也要指定相同的`routing`参数。
    
    POST /twitter/tweet/_search?routing=kimchy
    {
        "query": {
            "bool" : {
                "must" : {
                    "query_string" : {
                        "query" : "some query string here"
                    }
                },
                "filter" : {
                    "term" : { "user" : "kimchy" }
                }
            }
        }
    }

`routing`参数可以通过逗号（,）进行分隔，进行设置多个值，这些值都会会进行影响查询相关的分片。

## 状态组

一个查询可以被赋予一个状态组（stats groups），每组都包含一个数据分析聚合， 这些状态组可以在以后使用[indices stats](indices-stats.html) API 来查询，例如,下面是有两个状态组的查询请求：    
    
    POST /_search
    {
        "query" : {
            "match_all" : {}
        },
        "stats" : ["group1", "group2"]
    }

## 全局查询超时
单个搜索可以有一个超时设置作为[_Request Body Search_](search-request-body.html) API的一部分参数。由于搜索请求可能来自多个来源，因此ES为全局搜索超时设置了一个动态群集级别设置，适用于所有不在[_Request Body Search_]
API 中设置超时的搜索请求。默认的设置是不超时。设置的键是`search.default_search_timeout`,也可以通过[_Cluster Update Settings_](cluster-update-settings.html) API进行设置，当设置-1的时候就是不超时的时候。

## 查询取消
使用标准的[任务取消机制（task cancellation）](tasks.html#task-cancellation)取消一个查询。默认情况下，正在运行的搜索仅检查是否在段边界上被取消，因此可以通过大段延迟取消。 搜索取消响应可以通过将动态群集级别设置`search.low_level_cancellation`设置为`true`来改善。但是，它带来了更多的频繁取消检查的额外开销，这在大型快速运行的搜索查询中可能是显而易见的。 更改此设置仅影响更改后开始的搜索。
