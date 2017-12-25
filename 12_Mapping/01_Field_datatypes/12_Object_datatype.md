## Object datatype

JSON documents are hierarchical in nature: the document may contain inner objects which, in turn, may contain inner objects themselves:
    
    
    PUT my_index/my_type/1
    { ![](images/icons/callouts/1.png)
      "region": "US",
      "manager": { ![](images/icons/callouts/2.png)
        "age":     30,
        "name": { ![](images/icons/callouts/3.png)
          "first": "John",
          "last":  "Smith"
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The outer document is also a JSON object.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

It contains an inner object called `manager`.   
  
![](images/icons/callouts/3.png)

| 

Which in turn contains an inner object called `name`.   
  
Internally, this document is indexed as a simple, flat list of key-value pairs, something like this:
    
    
    {
      "region":             "US",
      "manager.age":        30,
      "manager.name.first": "John",
      "manager.name.last":  "Smith"
    }

An explicit mapping for the above document could look like this:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": { ![](images/icons/callouts/1.png)
          "properties": {
            "region": {
              "type": "keyword"
            },
            "manager": { ![](images/icons/callouts/2.png)
              "properties": {
                "age":  { "type": "integer" },
                "name": { ![](images/icons/callouts/3.png)
                  "properties": {
                    "first": { "type": "text" },
                    "last":  { "type": "text" }
                  }
                }
              }
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The mapping type is a type of object, and has a `properties` field.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `manager` field is an inner `object` field.   
  
![](images/icons/callouts/3.png)

| 

The `manager.name` field is an inner `object` field within the `manager` field.   
  
You are not required to set the field `type` to `object` explicitly, as this is the default value.

### Parameters for `object` fields

The following parameters are accepted by `object` fields:

[`dynamic`](dynamic.html)| Whether or not new `properties` should be added dynamically to an existing object. Accepts `true` (default), `false`and `strict`.     
---|---    
[`enabled`](enabled.html)| Whether the JSON value given for the object field should be parsed and indexed (`true`, default) or completely ignored(`false`).     
[`include_in_all`](include-in-all.html)| Sets the default `include_in_all` value for all the `properties` within the object. The object itself is not added tothe `_all` field.     
[`properties`](properties.html)| The fields within the object, which can be of any [datatype](mapping-types.html), including `object`. New properties may be added to an existing object.   
  
![Important](images/icons/important.png)

If you need to index arrays of objects instead of single objects, read [Nested datatype](nested.html) first.
