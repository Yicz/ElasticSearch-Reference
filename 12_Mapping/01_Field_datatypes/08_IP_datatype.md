## IP datatype

An `ip` field can index/store either [IPv4](https://en.wikipedia.org/wiki/IPv4) or [IPv6](https://en.wikipedia.org/wiki/IPv6) addresses.
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "ip_addr": {
              "type": "ip"
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "ip_addr": "192.168.1.1"
    }
    
    GET my_index/_search
    {
      "query": {
        "term": {
          "ip_addr": "192.168.0.0/16"
        }
      }
    }

### Parameters for `ip` fields

The following parameters are accepted by `ip` fields:

[`boost`](mapping-boost.html "boost")

| 

Mapping field-level query time boosting. Accepts a floating point number, defaults to `1.0`.   
  
---|---  
  
[`doc_values`](doc-values.html "doc_values")

| 

Should the field be stored on disk in a column-stride fashion, so that it can later be used for sorting, aggregations, or scripting? Accepts `true` (default) or `false`.   
  
[`include_in_all`](include-in-all.html "include_in_all")

| 

Whether or not the field value should be included in the [`_all`](mapping-all-field.html "_all field") field? Accepts `true` or `false`. Defaults to `false` if [`index`](mapping-index.html "index") is set to `false`, or if a parent [`object`](object.html "Object datatype") field sets `include_in_all` to `false`. Otherwise defaults to `true`.   
  
[`index`](mapping-index.html "index")

| 

Should the field be searchable? Accepts `true` (default) and `false`.   
  
[`null_value`](null-value.html "null_value")

| 

Accepts an IPv4 value which is substituted for any explicit `null` values. Defaults to `null`, which means the field is treated as missing.   
  
[`store`](mapping-store.html "store")

| 

Whether the field value should be stored and retrievable separately from the [`_source`](mapping-source-field.html "_source field") field. Accepts `true` or `false` (default).   
  
### Querying `ip` fields

The most common way to query ip addresses is to use the [CIDR](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing#CIDR_notation) notation: `[ip_address]/[prefix_length]`. For instance:
    
    
    GET my_index/_search
    {
      "query": {
        "term": {
          "ip_addr": "192.168.0.0/16"
        }
      }
    }

or
    
    
    GET my_index/_search
    {
      "query": {
        "term": {
          "ip_addr": "2001:db8::/48"
        }
      }
    }

Also beware that colons are special characters to the [`query_string`](query-dsl-query-string-query.html "Query String Query") query, so ipv6 addresses will need to be escaped. The easiest way to do so is to put quotes around the searched value:
    
    
    GET t/_search
    {
      "query": {
        "query_string" : {
          "query": "ip_addr:\"2001:db8::/48\""
        }
      }
    }
