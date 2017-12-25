## `include_in_all`

The `include_in_all` parameter provides per-field control over which fields are included in the [`_all`](mapping-all-field.html) field. It defaults to `true`, unless [`index`](mapping-index.html) is set to `no`.

This example demonstrates how to exclude the `date` field from the `_all` field:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "title": { ![](images/icons/callouts/1.png)
              "type": "text"
            },
            "content": { ![](images/icons/callouts/2.png)
              "type": "text"
            },
            "date": { ![](images/icons/callouts/3.png)
              "type": "date",
              "include_in_all": false
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png)

| 

The `title` and `content` fields will be included in the `_all` field.   
  
---|---  
  
![](images/icons/callouts/3.png)

| 

The `date` field will not be included in the `_all` field.   
  
![Tip](images/icons/tip.png)

The `include_in_all` setting is allowed to have different settings for fields of the same name in the same index. Its value can be updated on existing fields using the [PUT mapping API](indices-put-mapping.html).

The `include_in_all` parameter can also be set at the type level and on [`object`](object.html) or [`nested`](nested.html) fields, in which case all sub- fields inherit that setting. For instance:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "include_in_all": false, ![](images/icons/callouts/1.png)
          "properties": {
            "title":          { "type": "text" },
            "author": {
              "include_in_all": true, ![](images/icons/callouts/2.png)
              "properties": {
                "first_name": { "type": "text" },
                "last_name":  { "type": "text" }
              }
            },
            "editor": {
              "properties": {
                "first_name": { "type": "text" }, ![](images/icons/callouts/3.png)
                "last_name":  { "type": "text", "include_in_all": true } ![](images/icons/callouts/4.png)
              }
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

All fields in `my_type` are excluded from `_all`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `author.first_name` and `author.last_name` fields are included in `_all`.   
  
![](images/icons/callouts/3.png) ![](images/icons/callouts/4.png)

| 

Only the `editor.last_name` field is included in `_all`. The `editor.first_name` inherits the type-level setting and is excluded.   
  
![Note](images/icons/note.png)

### Multi-fields and `include_in_all`

The original field value is added to the `_all` field, not the terms produced by a field’s analyzer. For this reason, it makes no sense to set `include_in_all` to `true` on [multi-fields](multi-fields.html), as each multi-field has exactly the same value as its parent.
