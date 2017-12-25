## Index Aliases

APIs in Elasticsearch accept an index name when working against a specific index, and several indices when applicable. The index aliases API allows aliasing an index with a name, with all APIs automatically converting the alias name to the actual index name. An alias can also be mapped to more than one index, and when specifying it, the alias will automatically expand to the aliased indices. An alias can also be associated with a filter that will automatically be applied when searching, and routing values. An alias cannot have the same name as an index.

Here is a sample of associating the alias `alias1` with index `test1`:
    
    
    POST /_aliases
    {
        "actions" : [
            { "add" : { "index" : "test1", "alias" : "alias1" } }
        ]
    }

And here is removing that same alias:
    
    
    POST /_aliases
    {
        "actions" : [
            { "remove" : { "index" : "test1", "alias" : "alias1" } }
        ]
    }

Renaming an alias is a simple `remove` then `add` operation within the same API. This operation is atomic, no need to worry about a short period of time where the alias does not point to an index:
    
    
    POST /_aliases
    {
        "actions" : [
            { "remove" : { "index" : "test1", "alias" : "alias1" } },
            { "add" : { "index" : "test2", "alias" : "alias1" } }
        ]
    }

Associating an alias with more than one index is simply several `add` actions:
    
    
    POST /_aliases
    {
        "actions" : [
            { "add" : { "index" : "test1", "alias" : "alias1" } },
            { "add" : { "index" : "test2", "alias" : "alias1" } }
        ]
    }

Multiple indices can be specified for an action with the `indices` array syntax:
    
    
    POST /_aliases
    {
        "actions" : [
            { "add" : { "indices" : ["test1", "test2"], "alias" : "alias1" } }
        ]
    }

To specify multiple aliases in one action, the corresponding `aliases` array syntax exists as well.

For the example above, a glob pattern can also be used to associate an alias to more than one index that share a common name:
    
    
    POST /_aliases
    {
        "actions" : [
            { "add" : { "index" : "test*", "alias" : "all_test_indices" } }
        ]
    }

In this case, the alias is a point-in-time alias that will group all current indices that match, it will not automatically update as new indices that match this pattern are added/removed.

It is an error to index to an alias which points to more than one index.

It is also possible to swap an index with an alias in one operation:
    
    
    PUT test     ![](images/icons/callouts/1.png)
    PUT test_2   ![](images/icons/callouts/2.png)
    POST /_aliases
    {
        "actions" : [
            { "add":  { "index": "test_2", "alias": "test" } },
            { "remove_index": { "index": "test" } }  ![](images/icons/callouts/3.png)
        ]
    }

![](images/icons/callouts/1.png)

| 

An index we’ve added by mistake   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The index we should have added   
  
![](images/icons/callouts/3.png)

| 

`remove_index` is just like [_Delete Index_](indices-delete-index.html)  
  
### Filtered Aliases

Aliases with filters provide an easy way to create different "views" of the same index. The filter can be defined using Query DSL and is applied to all Search, Count, Delete By Query and More Like This operations with this alias.

To create a filtered alias, first we need to ensure that the fields already exist in the mapping:
    
    
    PUT /test1
    {
      "mappings": {
        "type1": {
          "properties": {
            "user" : {
              "type": "keyword"
            }
          }
        }
      }
    }

Now we can create an alias that uses a filter on field `user`:
    
    
    POST /_aliases
    {
        "actions" : [
            {
                "add" : {
                     "index" : "test1",
                     "alias" : "alias2",
                     "filter" : { "term" : { "user" : "kimchy" } }
                }
            }
        ]
    }

#### Routing

It is possible to associate routing values with aliases. This feature can be used together with filtering aliases in order to avoid unnecessary shard operations.

The following command creates a new alias `alias1` that points to index `test`. After `alias1` is created, all operations with this alias are automatically modified to use value `1` for routing:
    
    
    POST /_aliases
    {
        "actions" : [
            {
                "add" : {
                     "index" : "test",
                     "alias" : "alias1",
                     "routing" : "1"
                }
            }
        ]
    }

It’s also possible to specify different routing values for searching and indexing operations:
    
    
    POST /_aliases
    {
        "actions" : [
            {
                "add" : {
                     "index" : "test",
                     "alias" : "alias2",
                     "search_routing" : "1,2",
                     "index_routing" : "2"
                }
            }
        ]
    }

As shown in the example above, search routing may contain several values separated by comma. Index routing can contain only a single value.

If a search operation that uses routing alias also has a routing parameter, an interdiv of both search alias routing and routing specified in the parameter is used. For example the following command will use "2" as a routing value:
    
    
    GET /alias2/_search?q=user:kimchy&routing=2,3

If an index operation that uses index routing alias also has a parent routing, the parent routing is ignored.

### Add a single alias

An alias can also be added with the endpoint

`PUT /{index}/_alias/{name}`

where

`index`

| 

The index the alias refers to. Can be any of `* | _all | glob pattern | name1, name2, …`  
  
---|---  
  
`name`

| 

The name of the alias. This is a required option.   
  
`routing`

| 

An optional routing that can be associated with an alias.   
  
`filter`

| 

An optional filter that can be associated with an alias.   
  
You can also use the plural `_aliases`.

#### Examples:

Adding time based alias 
    
    
    
    PUT /logs_201305/_alias/2013

Adding a user alias 
    

First create the index and add a mapping for the `user_id` field:
    
    
    PUT /users
    {
        "mappings" : {
            "user" : {
                "properties" : {
                    "user_id" : {"type" : "integer"}
                }
            }
        }
    }

Then add the alias for a specific user:
    
    
    PUT /users/_alias/user_12
    {
        "routing" : "12",
        "filter" : {
            "term" : {
                "user_id" : 12
            }
        }
    }

### Aliases during index creation

Aliases can also be specified during [index creation](indices-create-index.html#create-index-aliases):
    
    
    PUT /logs_20162801
    {
        "mappings" : {
            "type" : {
                "properties" : {
                    "year" : {"type" : "integer"}
                }
            }
        },
        "aliases" : {
            "current_day" : {},
            "2016" : {
                "filter" : {
                    "term" : {"year" : 2016 }
                }
            }
        }
    }

### Delete aliases

The rest endpoint is: `/{index}/_alias/{name}`

where

`index`| `* | _all | glob pattern | name1, name2, …`    
---|---    
`name`| `* | _all | glob pattern | name1, name2, …`  
  
Alternatively you can use the plural `_aliases`. Example:
    
    
    DELETE /logs_20162801/_alias/current_day

### Retrieving existing aliases

The get index alias API allows to filter by alias name and index name. This api redirects to the master and fetches the requested index aliases, if available. This api only serialises the found index aliases.

Possible options:

`index`| The index name to get aliases for. Partial names are supported via wildcards, also multiple index names can bespecified separated with a comma. Also the alias name for an index can be used.     
---|---    
`alias`| The name of alias to return in the response. Like the index option, this option supports wildcards and the option thespecify multiple alias names separated by a comma.     
`ignore_unavailable`| What to do if an specified index name doesn’t exist. If set to `true` then those indices are ignored.   
  
The rest endpoint is: `/{index}/_alias/{alias}`.

#### Examples:

All aliases for the index users:
    
    
    GET /logs_20162801/_alias/*

Response:
    
    
    {
     "logs_20162801" : {
       "aliases" : {
         "2016" : {
           "filter" : {
             "term" : {
               "year" : 2016
             }
           }
         }
       }
     }
    }

All aliases with the name 2016 in any index:
    
    
    GET /_alias/2016

Response:
    
    
    {
      "logs_20162801" : {
        "aliases" : {
          "2016" : {
            "filter" : {
              "term" : {
                "year" : 2016
              }
            }
          }
        }
      }
    }

All aliases that start with 20 in any index:
    
    
    GET /_alias/20*

Response:
    
    
    {
      "logs_20162801" : {
        "aliases" : {
          "2016" : {
            "filter" : {
              "term" : {
                "year" : 2016
              }
            }
          }
        }
      }
    }

There is also a HEAD variant of the get indices aliases api to check if index aliases exist. The indices aliases exists api supports the same option as the get indices aliases api. Examples:
    
    
    HEAD /_alias/2016
    HEAD /_alias/20*
    HEAD /logs_20162801/_alias/*
