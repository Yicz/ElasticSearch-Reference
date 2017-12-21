## Type Query

Filters documents matching the provided document / mapping type.
    
    
    GET /_search
    {
        "query": {
            "type" : {
                "value" : "my_type"
            }
        }
    }
