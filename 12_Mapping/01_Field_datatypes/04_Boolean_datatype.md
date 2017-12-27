## Boolean datatype

Boolean fields accept JSON `true` and `false` values, but can also accept strings and numbers which are interpreted as either true or false:
False values | `false`, `"false"`, `"off"`, `"no"`, `"0"`, `""` (empty string), `0`, `0.0`    
---|---    
True values | Anything that isn’t false.   
  
![Warning](images/icons/warning.png)

### Deprecated in 5.1.0. 

While Elasticsearch will currently accept the above values during index time. Searching a boolean field using these pseudo-boolean values is deprecated. Please use "true" or "false" instead. 

![Warning](images/icons/warning.png)

### Deprecated in 5.3.0. 

Usage of any value other than `false`, `"false"`, `true` and `"true"` is deprecated. 

For example:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "is_published": {
              "type": "boolean"
            }
          }
        }
      }
    }
    
    POST my_index/my_type/1
    {
      "is_published": "true" #1
    }
    
    GET my_index/_search
    {
      "query": {
        "term": {
          "is_published": true #2
        }
      }
    }

#1

| 

Indexing a document with `"true"`, which is interpreted as `true`.   
  
---|---  
  
#2

| 

Searching for documents with a JSON `true`.   
  
Aggregations like the [`terms` aggregation](search-aggregations-bucket-terms-aggregation.html) use `1` and `0` for the `key`, and the strings `"true"` and `"false"` for the `key_as_string`. Boolean fields when used in scripts, return `1` and `0`:
    
    
    POST my_index/my_type/1
    {
      "is_published": true
    }
    
    POST my_index/my_type/2
    {
      "is_published": false
    }
    
    GET my_index/_search
    {
      "aggs": {
        "publish_state": {
          "terms": {
            "field": "is_published"
          }
        }
      },
      "script_fields": {
        "is_published": {
          "script": {
            "lang": "painless",
            "inline": "doc['is_published'].value"
          }
        }
      }
    }

### Parameters for `boolean` fields

The following parameters are accepted by `boolean` fields:

[`boost`](mapping-boost.html)| Mapping field-level query time boosting. Accepts a floating point number, defaults to `1.0`.     
---|---    
[`doc_values`](doc-values.html)| Should the field be stored on disk in a column-stride fashion, so that it can later be used for sorting, aggregations,or scripting? Accepts `true` (default) or `false`.     
[`index`](mapping-index.html)| Should the field be searchable? Accepts `true` (default) and `false`.     
[`null_value`](null-value.html)| Accepts any of the true or false values listed above. The value is substituted for any explicit `null` values.Defaults to `null`, which means the field is treated as missing.     
[`store`](mapping-store.html)| Whether the field value should be stored and retrievable separately from the 
[`_source`](mapping-source-field.html) field. Accepts `true` or `false` (default). 
