## Exists Query

Returns documents that have at least one non-`null` value in the original field:
    
    
    GET /_search
    {
        "query": {
            "exists" : { "field" : "user" }
        }
    }

For instance, these documents would all match the above query:
    
    
    { "user": "jane" }
    { "user": "" } ![](images/icons/callouts/1.png)
    { "user": "-" } ![](images/icons/callouts/2.png)
    { "user": ["jane"] }
    { "user": ["jane", null ] } ![](images/icons/callouts/3.png)

![](images/icons/callouts/1.png)

| 

An empty string is a non-`null` value.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Even though the `standard` analyzer would emit zero tokens, the original field is non-`null`.   
  
![](images/icons/callouts/3.png)

| 

At least one non-`null` value is required.   
  
These documents would **not** match the above query:
    
    
    { "user": null }
    { "user": [] } ![](images/icons/callouts/1.png)
    { "user": [null] } ![](images/icons/callouts/2.png)
    { "foo":  "bar" } ![](images/icons/callouts/3.png)

![](images/icons/callouts/1.png)

| 

This field has no values.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

At least one non-`null` value is required.   
  
![](images/icons/callouts/3.png)

| 

The `user` field is missing completely.   
  
#### `null_value` mapping

If the field mapping includes the [`null_value`](null-value.html "null_value") setting then explicit `null` values are replaced with the specified `null_value`. For instance, if the `user` field were mapped as follows:
    
    
      "user": {
        "type": "keyword",
        "null_value": "_null_"
      }

then explicit `null` values would be indexed as the string `_null_`, and the following docs would match the `exists` filter:
    
    
    { "user": null }
    { "user": [null] }

However, these docs—without explicit `null` values—would still have no values in the `user` field and thus would not match the `exists` filter:
    
    
    { "user": [] }
    { "foo": "bar" }

### `missing` query

 _missing_ query has been removed because it can be advantageously replaced by an `exists` query inside a must_not clause as follows:
    
    
    GET /_search
    {
        "query": {
            "bool": {
                "must_not": {
                    "exists": {
                        "field": "user"
                    }
                }
            }
        }
    }

This query returns documents that have no value in the user field.
