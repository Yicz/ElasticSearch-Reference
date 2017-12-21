## Get Mapping

The get mapping API allows to retrieve mapping definitions for an index or index/type.
    
    
    GET /twitter/_mapping/tweet

### Multiple Indices and Types

The get mapping API can be used to get more than one index or type mapping with a single call. General usage of the API follows the following syntax: `host:port/{index}/_mapping/{type}` where both `{index}` and `{type}` can accept a comma-separated list of names. To get mappings for all indices you can use `_all` for `{index}`. The following are some examples:
    
    
    GET /_mapping/tweet,kimchy
    
    GET /_all/_mapping/tweet,book

If you want to get mappings of all indices and types then the following two examples are equivalent:
    
    
    GET /_all/_mapping
    
    GET /_mapping
