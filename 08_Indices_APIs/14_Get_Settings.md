## Get Settings

The get settings API allows to retrieve settings of index/indices:
    
    
    GET /twitter/_settings

### Multiple Indices and Types

The get settings API can be used to get settings for more than one index with a single call. General usage of the API follows the following syntax: `host:port/{index}/_settings` where `{index}` can stand for comma-separated list of index names and aliases. To get settings for all indices you can use `_all` for `{index}`. Wildcard expressions are also supported. The following are some examples:
    
    
    GET /twitter,kimchy/_settings
    
    GET /_all/_settings
    
    GET /log_2013_*/_settings

### Filtering settings by name

The settings that are returned can be filtered with wildcard matching as follows:
    
    
    curl -XGET 'http://localhost:9200/2013-*/_settings/index.number_*'
