## 版本 Version

Returns a version for each search hit.
    
    
    GET /_search
    {
        "version": true,
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }
