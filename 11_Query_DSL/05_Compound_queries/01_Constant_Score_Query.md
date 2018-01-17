## 恒定分数查询

包装另一个查询的查询，并简单地返回一个恒定分数，该分数等于过滤器中每个文档的查询提升。 映射到Lucene的`ConstantScoreQuery`。   
    
    GET /_search
    {
        "query": {
            "constant_score" : {
                "filter" : {
                    "term" : { "user" : "kimchy"}
                },
                "boost" : 1.2
            }
        }
    }

Filter子句在[filter context](query-filter-context.html)中执行，这意味着评分被忽略，子句被考虑用于缓存。