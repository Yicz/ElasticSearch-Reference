# Search APIs

Most search APIs are [multi-index, multi-type](search-search.html#search-multi-index-type "Multi-Index, Multi-Typeedit"), with the exception of the [_Explain API_](search-explain.html "Explain API") endpoints.

## Routing

When executing a search, it will be broadcast to all the index/indices shards (round robin between replicas). Which shards will be searched on can be controlled by providing the `routing` parameter. For example, when indexing tweets, the routing value can be the user name:
    
    
    POST /twitter/tweet?routing=kimchy
    {
        "user" : "kimchy",
        "postDate" : "2009-11-15T14:12:12",
        "message" : "trying out Elasticsearch"
    }

In such a case, if we want to search only on the tweets for a specific user, we can specify it as the routing, resulting in the search hitting only the relevant shard:
    
    
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

The routing parameter can be multi valued represented as a comma separated string. This will result in hitting the relevant shards where the routing values match to.

## Stats Groups

A search can be associated with stats groups, which maintains a statistics aggregation per group. It can later be retrieved using the [indices stats](indices-stats.html "Indices Stats") API specifically. For example, here is a search body request that associate the request with two different groups:
    
    
    POST /_search
    {
        "query" : {
            "match_all" : {}
        },
        "stats" : ["group1", "group2"]
    }

## Global Search Timeout

Individual searches can have a timeout as part of the [_Request Body Search_](search-request-body.html "Request Body Search"). Since search requests can originate from many sources, Elasticsearch has a dynamic cluster-level setting for a global search timeout that applies to all search requests that do not set a timeout in the [_Request Body Search_](search-request-body.html "Request Body Search"). The default value is no global timeout. The setting key is `search.default_search_timeout` and can be set using the [_Cluster Update Settings_](cluster-update-settings.html "Cluster Update Settings") endpoints. Setting this value to `-1` resets the global search timeout to no timeout.

## Search Cancellation

Searches can be cancelled using standard [task cancellation](tasks.html#task-cancellation "Task Cancellationedit") mechanism. By default, a running search only checks if it is cancelled or not on segment boundaries, therefore the cancellation can be delayed by large segments. The search cancellation responsiveness can be improved by setting the dynamic cluster-level setting `search.low_level_cancellation` to `true`. However, it comes with an additional overhead of more frequent cancellation checks that can be noticeable on large fast running search queries. Changing this setting only affects the searches that start after the change is made.
