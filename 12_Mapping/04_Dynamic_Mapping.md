## Dynamic Mapping

One of the most important features of Elasticsearch is that it tries to get out of your way and let you start exploring your data as quickly as possible. To index a document, you don’t have to first create an index, define a mapping type, and define your fields — you can just index a document and the index, type, and fields will spring to life automatically:
    
    
    PUT data/counters/1 ![](images/icons/callouts/1.png)
    { "count": 5 }

![](images/icons/callouts/1.png)

| 

Creates the `data` index, the `counters` mapping type, and a field called `count` with datatype `long`.   
  
---|---  
  
The automatic detection and addition of new types and fields is called _dynamic mapping_. The dynamic mapping rules can be customised to suit your purposes with:

[`_default_` mapping](default-mapping.html "_default_ mapping")
     Configure the base mapping to be used for new mapping types. 
[Dynamic field mappings](dynamic-field-mapping.html "Dynamic field mapping")
     The rules governing dynamic field detection. 
[Dynamic templates](dynamic-templates.html "Dynamic templates")
     Custom rules to configure the mapping for dynamically added fields. 

![Tip](images/icons/tip.png)

[Index templates](indices-templates.html "Index Templates") allow you to configure the default mappings, settings and aliases for new indices, whether created automatically or explicitly.

### Disabling automatic type creation

Automatic type creation can be disabled per-index by setting the `index.mapper.dynamic` setting to `false` in the index settings:
    
    
    PUT data/_settings
    {
      "index.mapper.dynamic":false ![](images/icons/callouts/1.png)
    }

![](images/icons/callouts/1.png)

| 

Disable automatic type creation for the index named "data".   
  
---|---  
  
Automatic type creation can also be disabled for all indices by setting an index template:
    
    
    PUT _template/template_all
    {
      "template": "*",
      "order":0,
      "settings": {
        "index.mapper.dynamic": false ![](images/icons/callouts/1.png)
      }
    }

![](images/icons/callouts/1.png)

| 

Disable automatic type creation for all indices.   
  
---|---  
  
Regardless of the value of this setting, types can still be added explicitly when [creating an index](indices-create-index.html "Create Index") or with the [PUT mapping](indices-put-mapping.html "Put Mapping") API.
