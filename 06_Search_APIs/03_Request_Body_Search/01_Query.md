## Query

The query element within the search request body allows to define a query using the [Query DSL](query-dsl.html).
    
    
    GET /_search
    {
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }
