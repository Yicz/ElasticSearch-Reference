## Explain

Enables explanation for each hit on how its score was computed.
    
    
    GET /_search
    {
        "explain": true,
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }
