## `enabled`

Elasticsearch tries to index all of the fields you give it, but sometimes you want to just store the field without indexing it. For instance, imagine that you are using Elasticsearch as a web session store. You may want to index the session ID and last update time, but you don’t need to query or run aggregations on the session data itself.

The `enabled` setting, which can be applied only to the mapping type and to [`object`](object.html "Object datatype") fields, causes Elasticsearch to skip parsing of the contents of the field entirely. The JSON can still be retrieved from the [`_source`](mapping-source-field.html "_source field") field, but it is not searchable or stored in any other way:
    
    
    PUT my_index
    {
      "mappings": {
        "session": {
          "properties": {
            "user_id": {
              "type":  "keyword"
            },
            "last_updated": {
              "type": "date"
            },
            "session_data": { ![](images/icons/callouts/1.png)
              "enabled": false
            }
          }
        }
      }
    }
    
    PUT my_index/session/session_1
    {
      "user_id": "kimchy",
      "session_data": { ![](images/icons/callouts/2.png)
        "arbitrary_object": {
          "some_array": [ "foo", "bar", { "baz": 2 } ]
        }
      },
      "last_updated": "2015-12-06T18:20:22"
    }
    
    PUT my_index/session/session_2
    {
      "user_id": "jpountz",
      "session_data": "none", ![](images/icons/callouts/3.png)
      "last_updated": "2015-12-06T18:22:13"
    }

![](images/icons/callouts/1.png)

| 

The `session_data` field is disabled.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Any arbitrary data can be passed to the `session_data` field as it will be entirely ignored.   
  
![](images/icons/callouts/3.png)

| 

The `session_data` will also ignore values that are not JSON objects.   
  
The entire mapping type may be disabled as well, in which case the document is stored in the [`_source`](mapping-source-field.html "_source field") field, which means it can be retrieved, but none of its contents are indexed in any way:
    
    
    PUT my_index
    {
      "mappings": {
        "session": { ![](images/icons/callouts/1.png)
          "enabled": false
        }
      }
    }
    
    PUT my_index/session/session_1
    {
      "user_id": "kimchy",
      "session_data": {
        "arbitrary_object": {
          "some_array": [ "foo", "bar", { "baz": 2 } ]
        }
      },
      "last_updated": "2015-12-06T18:20:22"
    }
    
    GET my_index/session/session_1 ![](images/icons/callouts/2.png)
    
    GET my_index/_mapping ![](images/icons/callouts/3.png)

![](images/icons/callouts/1.png)

| 

The entire `session` mapping type is disabled.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The document can be retrieved.   
  
![](images/icons/callouts/3.png)

| 

Checking the mapping reveals that no fields have been added.   
  
![Tip](images/icons/tip.png)

The `enabled` setting is allowed to have different settings for fields of the same name in the same index. Its value can be updated on existing fields using the [PUT mapping API](indices-put-mapping.html "Put Mapping").
