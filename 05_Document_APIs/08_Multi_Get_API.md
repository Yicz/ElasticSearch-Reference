## Multi Get API

Multi GET API allows to get multiple documents based on an index, type (optional) and id (and possibly routing). The response includes a `docs` array with all the fetched documents, each element similar in structure to a document provided by the [get](docs-get.html) API. Here is an example:
    
    
    GET _mget
    {
        "docs" : [
            {
                "_index" : "test",
                "_type" : "type",
                "_id" : "1"
            },
            {
                "_index" : "test",
                "_type" : "type",
                "_id" : "2"
            }
        ]
    }

The `mget` endpoint can also be used against an index (in which case it is not required in the body):
    
    
    GET test/_mget
    {
        "docs" : [
            {
                "_type" : "type",
                "_id" : "1"
            },
            {
                "_type" : "type",
                "_id" : "2"
            }
        ]
    }

And type:
    
    
    GET test/type/_mget
    {
        "docs" : [
            {
                "_id" : "1"
            },
            {
                "_id" : "2"
            }
        ]
    }

In which case, the `ids` element can directly be used to simplify the request:
    
    
    GET test/type/_mget
    {
        "ids" : ["1", "2"]
    }

### Optional Type

The mget API allows for `_type` to be optional. Set it to `_all` or leave it empty in order to fetch the first document matching the id across all types.

If you don’t set the type and have many documents sharing the same `_id`, you will end up getting only the first matching document.

For example, if you have a document 1 within typeA and typeB then following request will give you back only the same document twice:
    
    
    GET test/_mget
    {
        "ids" : ["1", "1"]
    }

You need in that case to explicitly set the `_type`:
    
    
    GET test/_mget/
    {
      "docs" : [
            {
                "_type":"typeA",
                "_id" : "1"
            },
            {
                "_type":"typeB",
                "_id" : "1"
            }
        ]
    }

### Source filtering

By default, the `_source` field will be returned for every document (if stored). Similar to the [get](docs-get.html#get-source-filtering) API, you can retrieve only parts of the `_source` (or not at all) by using the `_source` parameter. You can also use the url parameters `_source`,`_source_include` & `_source_exclude` to specify defaults, which will be used when there are no per-document instructions.

For example:
    
    
    GET _mget
    {
        "docs" : [
            {
                "_index" : "test",
                "_type" : "type",
                "_id" : "1",
                "_source" : false
            },
            {
                "_index" : "test",
                "_type" : "type",
                "_id" : "2",
                "_source" : ["field3", "field4"]
            },
            {
                "_index" : "test",
                "_type" : "type",
                "_id" : "3",
                "_source" : {
                    "include": ["user"],
                    "exclude": ["user.location"]
                }
            }
        ]
    }

### Fields

Specific stored fields can be specified to be retrieved per document to get, similar to the [stored_fields](docs-get.html#get-stored-fields) parameter of the Get API. For example:
    
    
    GET _mget
    {
        "docs" : [
            {
                "_index" : "test",
                "_type" : "type",
                "_id" : "1",
                "stored_fields" : ["field1", "field2"]
            },
            {
                "_index" : "test",
                "_type" : "type",
                "_id" : "2",
                "stored_fields" : ["field3", "field4"]
            }
        ]
    }

Alternatively, you can specify the `stored_fields` parameter in the query string as a default to be applied to all documents.
    
    
    GET test/type/_mget?stored_fields=field1,field2
    {
        "docs" : [
            {
                "_id" : "1" ![](images/icons/callouts/1.png)
            },
            {
                "_id" : "2",
                "stored_fields" : ["field3", "field4"] ![](images/icons/callouts/2.png)
            }
        ]
    }

![](images/icons/callouts/1.png)

| 

Returns `field1` and `field2`  
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Returns `field3` and `field4`  
  
### Generated fields

See [Generated fields for fields generated only when indexing.

### Routing

You can also specify routing value as a parameter:
    
    
    GET _mget?routing=key1
    {
        "docs" : [
            {
                "_index" : "test",
                "_type" : "type",
                "_id" : "1",
                "_routing" : "key2"
            },
            {
                "_index" : "test",
                "_type" : "type",
                "_id" : "2"
            }
        ]
    }

In this example, document `test/type/2` will be fetch from shard corresponding to routing key `key1` but document `test/type/1` will be fetch from shard corresponding to routing key `key2`.

### Security

See [_URL-based access control_](url-access-control.html)
