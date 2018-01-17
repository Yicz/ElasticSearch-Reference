## 多词条（项）查询 Terms Query

过滤具有符合任何所提供词条的字段的文档（**未分析**）。 例如：    
    
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

`terms`查询也用`in`作为过滤器名称，用于更简单的用法[5.0.0]在5.0.0中不推荐使用。 使用`terms`来代替。

##### 多词条查找机制

When it’s needed to specify a `terms` filter with a lot of terms it can be beneficial to fetch those term values from a document in an index. A concrete example would be to filter tweets tweeted by your followers. Potentially the amount of user ids specified in the terms filter can be a lot. In this scenario it makes sense to use the terms filter’s terms lookup mechanism.

The terms lookup mechanism supports the following options:

`index`| 查询词条的索引，默认当前索引    
---|---    
`type`| 查询词条的类型     
`id`| 查找词条的id     
`path`| The field specified as path to fetch the actual values for the `terms` filter.     
`routing`| 自定义的词条路由   
  
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

在上面的例子中，查找的词条路径是 `followers.id`.
