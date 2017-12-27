## Binary datatype

The `binary` type accepts a binary value as a [Base64](https://en.wikipedia.org/wiki/Base64) encoded string. The field is not stored by default and is not searchable:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "name": {
              "type": "text"
            },
            "blob": {
              "type": "binary"
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "name": "Some binary blob",
      "blob": "U29tZSBiaW5hcnkgYmxvYg==" <1>
    }

<1>

| 

The Base64 encoded binary value must not have embedded newlines `\n`.   
  
---|---  
  
### Parameters for `binary` fields

The following parameters are accepted by `binary` fields:

[`doc_values`](doc-values.html)

| 

Should the field be stored on disk in a column-stride fashion, so that it can later be used for sorting, aggregations, or scripting? Accepts `true` (default) or `false`.   
  
---|---  
  
[`store`](mapping-store.html)

| 

Whether the field value should be stored and retrievable separately from the [`_source`](mapping-source-field.html) field. Accepts `true` or `false` (default). 
