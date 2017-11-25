## Override default template

You can override the default mappings for all indices and all types by specifying a `_default_` type mapping in an index template which matches all indices.

For example, to disable the `_all` field by default for all types in all new indices, you could create the following index template:
    
    
    PUT _template/disable_all_field
    {
      "order": 0,
      "template": "*", ![](images/icons/callouts/1.png)
      "mappings": {
        "_default_": { ![](images/icons/callouts/2.png)
          "_all": { ![](images/icons/callouts/3.png)
            "enabled": false
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

Applies the mappings to an `index` which matches the pattern `*`, in other words, all new indices.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Defines the `_default_` type mapping types within the index.   
  
![](images/icons/callouts/3.png)

| 

Disables the `_all` field by default. 
