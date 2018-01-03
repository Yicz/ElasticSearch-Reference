## 索引别名 Index Aliases

Elasticsearch中的API在处理特定索引时接受索引名称，在适用时接受多个索引。 索引别名API允许使用名称对索引进行别名，所有API都会自动将别名转换为实际的索引名称。 别名还可以映射到多个索引，并且在指定别名时，别名将自动扩展到别名索引。 一个别名还可以与一个过滤器相关联，这个过滤器在搜索和路由值时会自动应用。 别名不能与索引具有相同的名称。


以下是将别名alias1与索引test1关联的示例：
    
    
    POST /_aliases
    {
        "actions" : [
            { "add" : { "index" : "test1", "alias" : "alias1" } }
        ]
    }

这里是删除索引test1的alias1别名：
    
    
    POST /_aliases
    {
        "actions" : [
            { "remove" : { "index" : "test1", "alias" : "alias1" } }
        ]
    }

重命名一个别名是在同一个API中简单的`remove`，然后`add`操作。 这个操作是**原子**的，不用担心别名不指向索引的短时间：
    
    
    POST /_aliases
    {
        "actions" : [
            { "remove" : { "index" : "test1", "alias" : "alias1" } },
            { "add" : { "index" : "test2", "alias" : "alias1" } }
        ]
    }

将一个别名与多个索引关联起来只需要几个`add`操作：    
    
    POST /_aliases
    {
        "actions" : [
            { "add" : { "index" : "test1", "alias" : "alias1" } },
            { "add" : { "index" : "test2", "alias" : "alias1" } }
        ]
    }

可以为使用`indices`数组语法的操作指定多个索引：    
    
    POST /_aliases
    {
        "actions" : [
            { "add" : { "indices" : ["test1", "test2"], "alias" : "alias1" } }
        ]
    }

为了在一个动作中指定多个别名，也存在相应的`aliases`数组语法。

对于上面的示例，还可以使用glob模式将别名与多个共享通用名称的索引关联：

    POST /_aliases
    {
        "actions" : [
            { "add" : { "index" : "test*", "alias" : "all_test_indices" } }
        ]
    }

在这种情况下，别名是一个时间点别名，它将对所有匹配的当前索引进行分组，它不会自动更新，因为匹配此模式的新索引被添加/删除。

索引到指向多个索引的别名是错误的。

可以使用一个别名操作来交换索引：

    
    PUT test     <1>
    PUT test_2   <2>
    POST /_aliases
    {
        "actions" : [
            { "add":  { "index": "test_2", "alias": "test" } },
            { "remove_index": { "index": "test" } }  <3>
        ]
    }

<1>| 新增一个索引`test`    
---|---    
<2>| 新增索引`test_2`     
<3>| `remove_index` 的作用跟使用 [_Delete Index_](indices-delete-index.html)一致
  
### 过滤别名 Filtered Aliases

带过滤器的别名提供了一种简单的方法来创建相同索引的不同“视图”。 过滤器可以使用查询DSL进行定义，并应用于所有搜索，计数，删除查询以及更多类似此操作的别名。

要创建一个带过滤的别名，首先我们需要确保映射中已经存在的字段：

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

现在我们可以创建一个在`user`字段上使用过滤器的别名:
    
    
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

#### 路由 Routing

可以将路由值与别名相关联。 此功能可与过滤别名一起使用，以避免不必要的分片操作。

以下命令创建一个新的别名`alias1`，指向`test`索引。 创建`alias1`之后，具有该别名的所有操作将自动修改为使用值`1`进行路由：

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

也可以为搜索和索引操作指定不同的路由值：    
    
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

如上例所示，搜索路由可能包含用逗号分隔的多个值。 索引路由只能包含一个值。

如果使用路由别名的搜索操作也具有路由参数，则使用参数中指定的搜索别名路由和路由的路径。 例如，以下命令将使用“2”作为路由值：

    GET /alias2/_search?q=user:kimchy&routing=2,3

If an index operation that uses index routing alias also has a parent routing, the parent routing is ignored.

### 添加一个别名 Add a single alias

单个的别名可以使用的接口进行添加

`PUT /{index}/_alias/{name}`

说明

`index`| 可用传值 `* | _all | glob pattern | name1, name2, …`   
---|---    
`name`| 必填，别名的名称   
`routing`|一个可选的路由，可以与一个别名关联。    
`filter`|一个可选的过滤器，可以与一个别名关联。  
  
你也可以使用复数的形式 `_aliases`.

####  例子:

添加基于时间的别名    
    
    PUT /logs_201305/_alias/2013

添加一个用户别名    

首先创建索引并为`user_id`字段添加一个映射：

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

使用过滤器指定一个用户进行别名
    
    PUT /users/_alias/user_12
    {
        "routing" : "12",
        "filter" : {
            "term" : {
                "user_id" : 12
            }
        }
    }

### 可以在使用建立索引的时候就分配别名 Aliases during index creation

可以在使用[建立索引 index creation](indices-create-index.html#create-index-aliases)的时候就分配别名  :
    
    
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

### 删除别名

使用的接口是: `/{index}/_alias/{name}`


`index`| 可用值 `* | _all | glob pattern | name1, name2, …`    
---|---    
`name`| `* | _all | glob pattern | name1, name2, …`  
  
也可以使用复数的形式`_aliases`. 例如:
    
    
    DELETE /logs_20162801/_alias/current_day

### 检索已经存在的别名 Retrieving existing aliases

获取索引别名API允许按别名和索引名进行过滤。 这个api重定向到主服务器，并获取请求的索引别名（如果有的话）。 这个api只能序列化找到的索引别名。

可选项：

`index`|要获取别名的索引名称。 部分名称通过通配符支持，多个索引名称也可以用逗号分隔。 也可以使用索引的别名。     
---|---    
`alias`| 响应中返回的别名的名称。 与索引选项类似，此选项支持通配符，选项指定由逗号分隔的多个别名。 
`ignore_unavailable`|如果指定的索引名称不存在，该怎么办 设置为“true”，这些索引将被忽略。.   
  
接口是: `/{index}/_alias/{alias}`.

#### 例如:

索引用户的所有别名：    
    
    GET /logs_20162801/_alias/*

响应:
    
    
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

所有在任何索引中都以“2016”命名的别名：    
    
    GET /_alias/2016

响应:
    
    
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

在任何索引中以20开头的所有别名：    
    
    GET /_alias/20*

响应:
    
    
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

aliases api还有一个HEAD变体来检查是否存在索引别名。 索引别名存在api支持与获取索引别名api相同的选项。 例子： 
    
    HEAD /_alias/2016
    HEAD /_alias/20*
    HEAD /logs_20162801/_alias/*
