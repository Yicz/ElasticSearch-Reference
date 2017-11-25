## `coerce`

Data is not always clean. Depending on how it is produced a number might be rendered in the JSON body as a true JSON number, e.g. `5`, but it might also be rendered as a string, e.g. `"5"`. Alternatively, a number that should be an integer might instead be rendered as a floating point, e.g. `5.0`, or even `"5.0"`.

Coercion attempts to clean up dirty values to fit the datatype of a field. For instance:

  * Strings will be coerced to numbers. 
  * Floating points will be truncated for integer values. 



For instance:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "number_one": {
              "type": "integer"
            },
            "number_two": {
              "type": "integer",
              "coerce": false
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "number_one": "10" ![](images/icons/callouts/1.png)
    }
    
    PUT my_index/my_type/2
    {
      "number_two": "10" ![](images/icons/callouts/2.png)
    }

![](images/icons/callouts/1.png)

| 

The `number_one` field will contain the integer `10`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This document will be rejected because coercion is disabled.   
  
![Tip](images/icons/tip.png)

The `coerce` setting is allowed to have different settings for fields of the same name in the same index. Its value can be updated on existing fields using the [PUT mapping API](indices-put-mapping.html "Put Mapping").

### Index-level default

The `index.mapping.coerce` setting can be set on the index level to disable coercion globally across all mapping types:
    
    
    PUT my_index
    {
      "settings": {
        "index.mapping.coerce": false
      },
      "mappings": {
        "my_type": {
          "properties": {
            "number_one": {
              "type": "integer",
              "coerce": true
            },
            "number_two": {
              "type": "integer"
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    { "number_one": "10" } ![](images/icons/callouts/1.png)
    
    PUT my_index/my_type/2
    { "number_two": "10" } ![](images/icons/callouts/2.png)

![](images/icons/callouts/1.png)

| 

The `number_one` field overrides the index level setting to enable coercion.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This document will be rejected because the `number_two` field inherits the index-level coercion setting. 
