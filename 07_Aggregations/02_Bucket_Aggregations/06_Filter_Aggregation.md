## Filter Aggregation

Defines a single bucket of all the documents in the current document set context that match a specified filter. Often this will be used to narrow down the current aggregation context to a specific set of documents.

Example:
    
    
    POST /sales/_search?size=0
    {
        "aggs" : {
            "t_shirts" : {
                "filter" : { "term": { "type": "t-shirt" } },
                "aggs" : {
                    "avg_price" : { "avg" : { "field" : "price" } }
                }
            }
        }
    }

In the above example, we calculate the average price of all the products that are of type t-shirt.

响应如下：
    
    
    {
        ...
        "aggregations" : {
            "t_shirts" : {
                "doc_count" : 3,
                "avg_price" : { "value" : 128.33333333333334 }
            }
        }
    }
