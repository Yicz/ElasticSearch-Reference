## Terms Query

Filters documents that have fields that match any of the provided terms ( **not analyzed** ). For example:
    
    
    GET /_search
    {
        "query": {
            "constant_score" : {
                "filter" : {
                    "terms" : { "user" : ["kimchy", "elasticsearch"]}
                }
            }
        }
    }

The `terms` query is also aliased with `in` as the filter name for simpler usage  [5.0.0] Deprecated in 5.0.0. use `terms` instead .

##### Terms lookup mechanism

When it’s needed to specify a `terms` filter with a lot of terms it can be beneficial to fetch those term values from a document in an index. A concrete example would be to filter tweets tweeted by your followers. Potentially the amount of user ids specified in the terms filter can be a lot. In this scenario it makes sense to use the terms filter’s terms lookup mechanism.

The terms lookup mechanism supports the following options:

`index`| The index to fetch the term values from. Defaults to the current index.     
---|---    
`type`| The type to fetch the term values from.     
`id`| The id of the document to fetch the term values from.     
`path`| The field specified as path to fetch the actual values for the `terms` filter.     
`routing`| A custom routing value to be used when retrieving the external terms doc.   
  
The values for the `terms` filter will be fetched from a field in a document with the specified id in the specified type and index. Internally a get request is executed to fetch the values from the specified path. At the moment for this feature to work the `_source` needs to be stored.

Also, consider using an index with a single shard and fully replicated across all nodes if the "reference" terms data is not large. The lookup terms filter will prefer to execute the get request on a local node if possible, reducing the need for networking.

##### Terms lookup twitter example

At first we index the information for user with id 2, specifically, its followers, then index a tweet from user with id 1. Finally we search on all the tweets that match the followers of user 2.
    
    
    PUT /users/user/2
    {
        "followers" : ["1", "3"]
    }
    
    PUT /tweets/tweet/1
    {
        "user" : "1"
    }
    
    GET /tweets/_search
    {
        "query" : {
            "terms" : {
                "user" : {
                    "index" : "users",
                    "type" : "user",
                    "id" : "2",
                    "path" : "followers"
                }
            }
        }
    }

The structure of the external terms document can also include an array of inner objects, for example:
    
    
    PUT /users/user/2
    {
     "followers" : [
       {
         "id" : "1"
       },
       {
         "id" : "2"
       }
     ]
    }

In which case, the lookup path will be `followers.id`.
