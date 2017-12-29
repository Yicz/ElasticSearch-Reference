## 内部命中 Inner hits

[parent / child](mapping-parent-field.html)和[nested](nested.html) 特性允许返回具有不同范围匹配的文档。在父/子情况下，根据子文档中的匹配返回父文档，或者根据父文档中的匹配返回子文档。在嵌套的情况下，基于嵌套的内部对象中的匹配返回文档。

在这两种情况下，隐藏导致文档被返回的不同作用域中的实际匹配。在很多情况下，知道哪些内部嵌套对象（在嵌套的情况下）或子/父文档（在父/子的情况下）导致某些信息被返回是非常有用的。内部命中功能可以用于此。此功能会返回搜索响应中的每个搜索命中，导致搜索命中匹配的其他嵌套命中。

可以通过在嵌套，`has_child`或`has_parent`查询和过滤器上定义`inner_hits`定义来使用内部命中。结构如下所示：
    
    
    "<query>" : {
        "inner_hits" : {
            <inner_hits_options>
        }
    }

如果在支持它的查询上定义了“inner_hits”，那么每个搜索命中文档都将包含一个具有以下结构的“inner_hits”json对象：
    
    
    "hits": [
         {
            "_index": ...,
            "_type": ...,
            "_id": ...,
            "inner_hits": {
               "<inner_hits_name>": {
                  "hits": {
                     "total": ...,
                     "hits": [
                        {
                           "_type": ...,
                           "_id": ...,
                           ...
                        },
                        ...
                     ]
                  }
               }
            },
            ...
         },
         ...
    ]

### 选项 Options

内部匹配支持以下选项：
`from`| 在返回的常规搜索中，每次搜索“inner_hits”的第一个匹配点的偏移量。    
---|---    
`size`| 每个`inner_hits`返回的最大点击数。 默认情况下返回前三个匹配的匹配。     
`sort`| 内部点击应该如何按照`inner_hits`排序。 默认情况下，按照分数排序。     
`name`| 在响应中用于特定内部命中定义的名称。 在单个搜索请求中定义了多个内部匹配时很有用。 默认取决于在哪个查询中定义了内部命中。 对于`has_child`查询和过滤，这是子类型，`has_parent`查询和过滤这是父类型和嵌套查询和过滤这是嵌套的路径。  
  
内部命中还支持以下每个文档功能：

  * [Highlighting](search-request-highlighting.html)
  * [Explain](search-request-explain.html)
  * [Source filtering](search-request-source-filtering.html)
  * [Script fields](search-request-script-fields.html)
  * [Doc value fields](search-request-docvalue-fields.html)
  * [Include versions](search-request-version.html)



### Nested inner hits

可以使用嵌套的`inner_hits`将嵌套的内部对象作为搜索命中的内部命中。

下面的例子假定有一个名为`comments`的嵌套对象字段：
    
    
    {
        "query" : {
            "nested" : {
                "path" : "comments",
                "query" : {
                    "match" : {"comments.message" : "[actual query]"}
                },
                "inner_hits" : {} <1>
            }
        }
    }

<1>| 嵌套查询中的内部命中定义。 没有其他选项需要定义。    
---|---  
  
可以从上述搜索请求生成的响应代码片段的示例：    
    
    ...
    "hits": {
      ...
      "hits": [
         {
            "_index": "my-index",
            "_type": "question",
            "_id": "1",
            "_source": ...,
            "inner_hits": {
               "comments": { <1>
                  "hits": {
                     "total": ...,
                     "hits": [
                        {
                           "_nested": {
                              "field": "comments",
                              "offset": 2
                           },
                           "_source": ...
                        },
                        ...
                     ]
                  }
               }
            }
         },
         ...

<1>| 搜索请求中内部命中定义中使用的名称。 自定义键可以通过`name`选项使用。   
---|---  
  
在上面的例子中`_nested`元数据是至关重要的，因为它定义了内部命中来自哪个内部嵌套对象。 `field`定义嵌套命中的对象数组字段和`_source`中相对于其位置的`offset`。 由于排序和计分，`inner_hits`中的命中对象的实际位置通常与定义嵌套内部对象的位置不同。

默认情况下`_source`也返回给`inner_hits`中的命中对象，但是这个可以改变。 无论是通过`_source`过滤功能的一部分源可以返回或禁用。 如果存储的字段是在嵌套级别上定义的，则也可以通过“fields”功能返回。

一个重要的默认值是`inner_hits`内返回的_source相对于`_nested`元数据。 所以在上面的例子中，只有注释部分是每个嵌套命中返回的，而不是包含注释的顶层文档的整个源。

### 嵌套内部命中和`_source`

嵌套的文档没有`_source`字段，因为整个文档的源文件与其根目录下的`_source`字段一起存储。 要包含嵌套文档的源代码，将解析根文档的源代码，并将嵌套文档的相关位作为源包含在内部命中中。 对每个匹配的嵌套文档执行此操作会影响执行整个搜索请求所花费的时间，特别是当“size”和内部匹配“size”设置为高于默认值时。 为了避免嵌套内部命中的相对昂贵的源提取，可以禁止包括源并且完全依靠存储的字段。

为您的映射中的嵌套对象字段下的字段启用存储字段：
    
    
    {
        "properties": {
            "comment": {
              "type": "comments",
              "properties" : {
                "message" : {
                    "type" : "text",
                    "store" : true
                }
              }
            }
        }
    }

禁用包含源并在内部匹配定义中包含特定的存储字段：    
    
    {
        "query" : {
            "nested" : {
                "path" : "comments",
                "query" : {
                    "match" : {"comments.message" : "[actual query]"}
                },
                "inner_hits" : {
                    "_source" : false,
                    "stored_fields" : ["comments.text"]
                }
            }
        }
    }

### 嵌套对象字段和内部命中的层次级别。 Hierarchical levels of nested object fields and inner hits.

如果一个映射有多层次的层次嵌套对象字段，则每个层次都可以通过点记号路径访问。 例如，如果有一个包含`votes`嵌套字段的`comments`嵌套字段，则应该直接使用根命中返回投票，则可以定义以下路径：
    
    
    {
       "query" : {
          "nested" : {
             "path" : "comments.votes",
             "query" : { ... },
             "inner_hits" : {}
          }
        }
    }

这个间接引用仅支持嵌套内部匹配。

### Parent/child inner hits

父/子`inner_hits`可以用来包含父或子

下面的例子假设在`comment`类型中有一个`_parent`字段映射：
    
    
    {
        "query" : {
            "has_child" : {
                "type" : "comment",
                "query" : {
                    "match" : {"message" : "[actual query]"}
                },
                "inner_hits" : {} <1>
            }
        }
    }

<1>| 内部命中定义就像在嵌套的例子中一样。     
---|---  
  
可以从上述搜索请求生成的响应代码片段的示例：    
    
    ...
    "hits": {
      ...
      "hits": [
         {
            "_index": "my-index",
            "_type": "question",
            "_id": "1",
            "_source": ...,
            "inner_hits": {
               "comment": {
                  "hits": {
                     "total": ...,
                     "hits": [
                        {
                           "_type": "comment",
                           "_id": "5",
                           "_source": ...
                        },
                        ...
                     ]
                  }
               }
            }
         },
         ...
