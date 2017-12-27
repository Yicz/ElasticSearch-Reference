## 多获取API Multi Get API

Multi GET API允许基于索引，类型（可选）和id（以及可能的路由）获取多个文档。 响应包括一个带有所有获取文档的“docs”数组，每个元素的结构与[get](docs-get.html)API提供的文档相似。 这里是一个例子：
    
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

`_mget`接口也可以用于索引（在这种情况下，它不是必需的）：    
    
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

还有文档类型:
    
    
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

在这种情况下，`id`元素可以直接用来作简单请求：    
    
    GET test/type/_mget
    {
        "ids" : ["1", "2"]
    }

### 可选的类型 Optional Type

mget API 允许`类型（type）`作为可选项，取全或者设置`_all`会首先匹配到id的第一个文档。

如果没有设置类型同时不类类型的文件有着相同的`_id`,你只先匹配到一个文档。

例如：如果你在 类型A和类型B中有一个id为1的文档，发出如下的请求，你只会拿到同一个文档两次。
    
    GET test/_mget
    {
        "ids" : ["1", "1"]
    }

在这个例子里，你需要显示指定类型（type）
    
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

### 源过滤 Source filtering

默认地,`_source`将会返回存储了的文档。类似于[get API](docs-get.html#get-source-filtering)，你可以通过指定`_source`参数进行过滤`_source`字段中返回的属性。你可以使用url参数`_source`,`_source_include`和`_source_exclude`设定每个文档`_source`返回的默认字段。

例如:
    
    
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

### 字段 Fields

类似 Get API的[字段存储 stored field](docs-get.html#get-stored-fields),存储了的字段可以在请求的时候进行返回。例如：
    
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
或者，您可以将查询字符串中的`stored_fields`参数指定为默认值，以应用于所有文档。

```sh
    GET test/type/_mget?stored_fields=field1,field2
    {
        "docs" : [
            {
                "_id" : "1" #1
            },
            {
                "_id" : "2",
                "stored_fields" : ["field3", "field4"] #2
            }
        ]
    }
```

#1 | Returns `field1` and `field2`    
---|---    
#2 | Returns `field3` and `field4`  
  
### 生成字段 Generated fields

[生成字段 Generated fields](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-get.html#generated-fields)只有在建立索引的时候才有效

### 路由 Routing

您还可以指定路由值（routing）作为参数：    
    
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

在这个例子中，文件`test/type/2`将从路由关键字`key1`对应的分片中获取，而文档`test/type/1`将从对应于路由关键词`key2`的分片中获取。

### 安全 Security

请查看[基于URL的访问控制](url-access-control.html)
