## Match All Query

The most simple query, which matches all documents, giving them all a `_score` of `1.0`.
    
    
    GET /_search
    {
        "query": {
            "match_all": {}
        }
    }

The `_score` can be changed with the `boost` parameter:
    
    
    GET /_search
    {
        "query": {
            "match_all": { "boost" : 1.2 }
        }
    }

## Match None Query

This is the inverse of the `match_all` query, which matches no documents.
    
    
    GET /_search
    {
        "query": {
            "match_none": {}
        }
    }
