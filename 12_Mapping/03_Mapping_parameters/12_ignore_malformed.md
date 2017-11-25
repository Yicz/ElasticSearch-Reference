## `ignore_malformed`

Sometimes you don’t have much control over the data that you receive. One user may send a `login` field that is a [`date`](date.html "Date datatype"), and another sends a `login` field that is an email address.

Trying to index the wrong datatype into a field throws an exception by default, and rejects the whole document. The `ignore_malformed` parameter, if set to `true`, allows the exception to be ignored. The malformed field is not indexed, but other fields in the document are processed normally.

For example:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "number_one": {
              "type": "integer",
              "ignore_malformed": true
            },
            "number_two": {
              "type": "integer"
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "text":       "Some text value",
      "number_one": "foo" ![](images/icons/callouts/1.png)
    }
    
    PUT my_index/my_type/2
    {
      "text":       "Some text value",
      "number_two": "foo" ![](images/icons/callouts/2.png)
    }

![](images/icons/callouts/1.png)

| 

This document will have the `text` field indexed, but not the `number_one` field.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This document will be rejected because `number_two` does not allow malformed values.   
  
![Tip](images/icons/tip.png)

The `ignore_malformed` setting is allowed to have different settings for fields of the same name in the same index. Its value can be updated on existing fields using the [PUT mapping API](indices-put-mapping.html "Put Mapping").

### Index-level default

The `index.mapping.ignore_malformed` setting can be set on the index level to allow to ignore malformed content globally across all mapping types.
    
    
    PUT my_index
    {
      "settings": {
        "index.mapping.ignore_malformed": true ![](images/icons/callouts/1.png)
      },
      "mappings": {
        "my_type": {
          "properties": {
            "number_one": { ![](images/icons/callouts/2.png)
              "type": "byte"
            },
            "number_two": {
              "type": "integer",
              "ignore_malformed": false ![](images/icons/callouts/3.png)
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png)

| 

The `number_one` field inherits the index-level setting.   
  
---|---  
  
![](images/icons/callouts/3.png)

| 

The `number_two` field overrides the index-level setting to turn off `ignore_malformed`. 
