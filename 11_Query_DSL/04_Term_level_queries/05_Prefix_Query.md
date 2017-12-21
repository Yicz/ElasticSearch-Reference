## Prefix Query

Matches documents that have fields containing terms with a specified prefix ( **not analyzed** ). The prefix query maps to Lucene `PrefixQuery`. The following matches documents where the user field contains a term that starts with `ki`:
    
    
    GET /_search
    { "query": {
        "prefix" : { "user" : "ki" }
      }
    }

A boost can also be associated with the query:
    
    
    GET /_search
    { "query": {
        "prefix" : { "user" :  { "value" : "ki", "boost" : 2.0 } }
      }
    }

Or with the `prefix` [5.0.0] Deprecated in 5.0.0. Use `value` syntax:
    
    
    GET /_search
    { "query": {
        "prefix" : { "user" :  { "prefix" : "ki", "boost" : 2.0 } }
      }
    }

This multi term query allows you to control how it gets rewritten using the [rewrite](query-dsl-multi-term-rewrite.html "Multi Term Query Rewrite") parameter.
