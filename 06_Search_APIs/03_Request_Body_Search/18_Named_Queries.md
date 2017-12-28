## 命名查询 Named Queries

Each filter and query can accept a `_name` in its top level definition.
    
    
    GET /_search
    {
        "query": {
            "bool" : {
                "should" : [
                    {"match" : { "name.first" : {"query" : "shay", "_name" : "first"} } },
                    {"match" : { "name.last" : {"query" : "banon", "_name" : "last"} } }
                ],
                "filter" : {
                    "terms" : {
                        "name.last" : ["banon", "kimchy"],
                        "_name" : "test"
                    }
                }
            }
        }
    }

搜索响应将为每个匹配包括它匹配的`matched_queries`。 查询和过滤器的标记只对“bool”查询有意义。
