## `dynamic`

By default, fields can be added _dynamically_ to a document, or to [inner objects](object.html) within a document, just by indexing a document containing the new field. For instance:
    
    
    PUT my_index/my_type/1 ![](images/icons/callouts/1.png)
    {
      "username": "johnsmith",
      "name": {
        "first": "John",
        "last": "Smith"
      }
    }
    
    GET my_index/_mapping ![](images/icons/callouts/2.png)
    
    PUT my_index/my_type/2 ![](images/icons/callouts/3.png)
    {
      "username": "marywhite",
      "email": "mary@white.com",
      "name": {
        "first": "Mary",
        "middle": "Alice",
        "last": "White"
      }
    }
    
    GET my_index/_mapping ![](images/icons/callouts/4.png)

![](images/icons/callouts/1.png)

| 

This document introduces the string field `username`, the object field `name`, and two string fields under the `name` object which can be referred to as `name.first` and `name.last`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Check the mapping to verify the above.   
  
![](images/icons/callouts/3.png)

| 

This document adds two string fields: `email` and `name.middle`.   
  
![](images/icons/callouts/4.png)

| 

Check the mapping to verify the changes.   
  
The details of how new fields are detected and added to the mapping is explained in [_Dynamic Mapping_](dynamic-mapping.html).

The `dynamic` setting controls whether new fields can be added dynamically or not. It accepts three settings:

`true`| Newly detected fields are added to the mapping. (default)     
---|---    
`false`| Newly detected fields are ignored. New fields must be added explicitly.     
`strict`| If new fields are detected, an exception is thrown and the document is rejected.   
  
The `dynamic` setting may be set at the mapping type level, and on each [inner object](object.html). Inner objects inherit the setting from their parent object or from the mapping type. For instance:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "dynamic": false, ![](images/icons/callouts/1.png)
          "properties": {
            "user": { ![](images/icons/callouts/2.png)
              "properties": {
                "name": {
                  "type": "text"
                },
                "social_networks": { ![](images/icons/callouts/3.png)
                  "dynamic": true,
                  "properties": {}
                }
              }
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

Dynamic mapping is disabled at the type level, so no new top-level fields will be added dynamically.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `user` object inherits the type-level setting.   
  
![](images/icons/callouts/3.png)

| 

The `user.social_networks` object enables dynamic mapping, so new fields may be added to this inner object.   
  
![Tip](images/icons/tip.png)

The `dynamic` setting is allowed to have different settings for fields of the same name in the same index. Its value can be updated on existing fields using the [PUT mapping API](indices-put-mapping.html).
