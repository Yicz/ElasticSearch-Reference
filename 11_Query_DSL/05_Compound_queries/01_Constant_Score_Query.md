## Constant Score Query

A query that wraps another query and simply returns a constant score equal to the query boost for every document in the filter. Maps to Lucene `ConstantScoreQuery`.
    
    
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

Filter clauses are executed in [filter context](query-filter-context.html "Query and filter context"), meaning that scoring is ignored and clauses are considered for caching.
