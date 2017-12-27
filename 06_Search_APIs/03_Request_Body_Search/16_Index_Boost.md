## Index Boost

Allows to configure different boost level per index when searching across more than one indices. This is very handy when hits coming from one index matter more than hits coming from another index (think social graph where each user has an index).

![Warning](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/warning.png)

### Deprecated in 5.2.0. 

This format is deprecated. Please use array format instead. 
    
    
    GET /_search
    {
        "indices_boost" : {
            "index1" : 1.4,
            "index2" : 1.3
        }
    }

You can also specify it as an array to control the order of boosts.
    
    
    GET /_search
    {
        "indices_boost" : [
            { "alias1" : 1.4 },
            { "index*" : 1.3 }
        ]
    }

This is important when you use aliases or wildcard expression. If multiple matches are found, the first match will be used. For example, if an index is included in both `alias1` and `index*`, boost value of `1.4` is applied.
