## Ids Query

Filters documents that only have the provided ids. Note, this query uses the [_uid](mapping-uid-field.html) field.
    
    
    GET /_search
    {
        "query": {
            "ids" : {
                "type" : "my_type",
                "values" : ["1", "4", "100"]
            }
        }
    }

The `type` is optional and can be omitted, and can also accept an array of values. If no type is specified, all types defined in the index mapping are tried.