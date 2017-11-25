## Token count datatype

A field of type `token_count` is really an [`integer`](number.html "Numeric datatypes") field which accepts string values, analyzes them, then indexes the number of tokens in the string.

For instance:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "name": { ![](images/icons/callouts/1.png)
              "type": "text",
              "fields": {
                "length": { ![](images/icons/callouts/2.png)
                  "type":     "token_count",
                  "analyzer": "standard"
                }
              }
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    { "name": "John Smith" }
    
    PUT my_index/my_type/2
    { "name": "Rachel Alice Williams" }
    
    GET my_index/_search
    {
      "query": {
        "term": {
          "name.length": 3 ![](images/icons/callouts/3.png)
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The `name` field is an analyzed string field which uses the default `standard` analyzer.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `name.length` field is a `token_count` [multi-field](multi-fields.html "fields") which will index the number of tokens in the `name` field.   
  
![](images/icons/callouts/3.png)

| 

This query matches only the document containing `Rachel Alice Williams`, as it contains three tokens.   
  
![Note](images/icons/note.png)

Technically the `token_count` type sums position increments rather than counting tokens. This means that even if the analyzer filters out stop words they are included in the count.

### Parameters for `token_count` fields

The following parameters are accepted by `token_count` fields:

[`analyzer`](analyzer.html "analyzer")

| 

The [analyzer](analysis.html "Analysis") which should be used to analyze the string value. Required. For best performance, use an analyzer without token filters.   
  
---|---  
  
[`boost`](mapping-boost.html "boost")

| 

Mapping field-level query time boosting. Accepts a floating point number, defaults to `1.0`.   
  
[`doc_values`](doc-values.html "doc_values")

| 

Should the field be stored on disk in a column-stride fashion, so that it can later be used for sorting, aggregations, or scripting? Accepts `true` (default) or `false`.   
  
[`index`](mapping-index.html "index")

| 

Should the field be searchable? Accepts `not_analyzed` (default) and `no`.   
  
[`include_in_all`](include-in-all.html "include_in_all")

| 

Whether or not the field value should be included in the [`_all`](mapping-all-field.html "_all field") field? Accepts `true` or `false`. Defaults to `false`. Note: if `true`, it is the string value that is added to `_all`, not the calculated token count.   
  
[`null_value`](null-value.html "null_value")

| 

Accepts a numeric value of the same `type` as the field which is substituted for any explicit `null` values. Defaults to `null`, which means the field is treated as missing.   
  
[`store`](mapping-store.html "store")

| 

Whether the field value should be stored and retrievable separately from the [`_source`](mapping-source-field.html "_source field") field. Accepts `true` or `false` (default). 
