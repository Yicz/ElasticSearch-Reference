## Span Multi Term Query

The `span_multi` query allows you to wrap a `multi term query` (one of wildcard, fuzzy, prefix, range or regexp query) as a `span query`, so it can be nested. Example:
    
    
    GET /_search
    {
        "query": {
            "span_multi":{
                "match":{
                    "prefix" : { "user" :  { "value" : "ki" } }
                }
            }
        }
    }

A boost can also be associated with the query:
    
    
    GET /_search
    {
        "query": {
            "span_multi":{
                "match":{
                    "prefix" : { "user" :  { "value" : "ki", "boost" : 1.08 } }
                }
            }
        }
    }
