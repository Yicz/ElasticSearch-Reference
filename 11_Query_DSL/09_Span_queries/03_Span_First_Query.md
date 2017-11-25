## Span First Query

Matches spans near the beginning of a field. The span first query maps to Lucene `SpanFirstQuery`. Here is an example:
    
    
    GET /_search
    {
        "query": {
            "span_first" : {
                "match" : {
                    "span_term" : { "user" : "kimchy" }
                },
                "end" : 3
            }
        }
    }

The `match` clause can be any other span type query. The `end` controls the maximum end position permitted in a match.
