## `null_value`

A `null` value cannot be indexed or searched. When a field is set to `null`, (or an empty array or an array of `null` values) it is treated as though that field has no values.

The `null_value` parameter allows you to replace explicit `null` values with the specified value so that it can be indexed and searched. For instance:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "status_code": {
              "type":       "keyword",
              "null_value": "NULL" ![](images/icons/callouts/1.png)
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "status_code": null
    }
    
    PUT my_index/my_type/2
    {
      "status_code": [] ![](images/icons/callouts/2.png)
    }
    
    GET my_index/_search
    {
      "query": {
        "term": {
          "status_code": "NULL" ![](images/icons/callouts/3.png)
        }
      }
    }

![](images/icons/callouts/1.png)

| 

Replace explicit `null` values with the term `NULL`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

An empty array does not contain an explicit `null`, and so won’t be replaced with the `null_value`.   
  
![](images/icons/callouts/3.png)

| 

A query for `NULL` returns document 1, but not document 2.   
  
![Important](images/icons/important.png)

The `null_value` needs to be the same datatype as the field. For instance, a `long` field cannot have a string `null_value`.
