## `copy_to`

The `copy_to` parameter allows you to create custom [`_all`](mapping-all-field.html) fields. In other words, the values of multiple fields can be copied into a group field, which can then be queried as a single field. For instance, the `first_name` and `last_name` fields can be copied to the `full_name` field as follows:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "first_name": {
              "type": "text",
              "copy_to": "full_name" ![](images/icons/callouts/1.png)
            },
            "last_name": {
              "type": "text",
              "copy_to": "full_name" ![](images/icons/callouts/2.png)
            },
            "full_name": {
              "type": "text"
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "first_name": "John",
      "last_name": "Smith"
    }
    
    GET my_index/_search
    {
      "query": {
        "match": {
          "full_name": { ![](images/icons/callouts/3.png)
            "query": "John Smith",
            "operator": "and"
          }
        }
      }
    }

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png)

| 

The values of the `first_name` and `last_name` fields are copied to the `full_name` field.   
  
---|---  
  
![](images/icons/callouts/3.png)

| 

The `first_name` and `last_name` fields can still be queried for the first name and last name respectively, but the `full_name` field can be queried for both first and last names.   
  
Some important points:

  * It is the field _value_ which is copied, not the terms (which result from the analysis process). 
  * The original [`_source`](mapping-source-field.html) field will not be modified to show the copied values. 
  * The same value can be copied to multiple fields, with `"copy_to": [ "field_1", "field_2" ]`


