# 查询操作 APIs

大多数的查询API是 [多索引, 多类型](search-search.html#search-multi-index-type) 接口.

## 路由（Routing)

When executing a search, it will be broadcast to all the index/indices shards (round robin between replicas). Which shards will be searched on can be controlled by providing the `routing` parameter. For example, when indexing tweets, the routing value can be the user name:
    
    
    POST /twitter/tweet?routing=kimchy
    {
       ,
       ,
       
    }

In such a case, if we want to search only on the tweets for a specific user, we can specify it as the routing, resulting in the search hitting only the relevant shard:
    
    
    POST /twitter/tweet/_search?routing=kimchy
    {
       : {
            : {
                : {
                    : {
                       
                    }
                },
                : {
                    }
                }
            }
        }
    }

The routing parameter can be multi valued represented as a comma separated string. This will result in hitting the relevant shards where the routing values match to.

## Stats Groups

A search can be associated with stats groups, which maintains a statistics aggregation per group. It can later be retrieved using the [indices stats](indices-stats.html) API specifically. For example, here is a search body request that associate the request with two different groups:
    
    
    POST /_search
    {
        : {
            : {}
        },
       ]
    }

## Global Search Timeout

Individual searches can have a timeout as part of the [_Request Body Search_](search-request-body.html) endpoints. Setting this value to `-1` resets the global search timeout to no timeout.

## Search Cancellation

Searches can be cancelled using standard [task cancellation](tasks.html#task-cancellation) mechanism. By default, a running search only checks if it is cancelled or not on segment boundaries, therefore the cancellation can be delayed by large segments. The search cancellation responsiveness can be improved by setting the dynamic cluster-level setting `search.low_level_cancellation` to `true`. However, it comes with an additional overhead of more frequent cancellation checks that can be noticeable on large fast running search queries. Changing this setting only affects the searches that start after the change is made.
