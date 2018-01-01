## 获取字段映射关系 Get Field Mapping

获取字段映射API允许您检索一个或多个字段的映射定义。 当您不需要[_Get Mapping_](indices-get-mapping.html)API返回的完整类型映射时，这非常有用。

如下面的映射关系：
    
    PUT publications
    {
        "mappings": {
            "article": {
                "properties": {
                    "id": { "type": "text" },
                    "title":  { "type": "text"},
                    "abstract": { "type": "text"},
                    "author": {
                        "properties": {
                            "id": { "type": "text" },
                            "name": { "type": "text" }
                        }
                    }
                }
            }
        }
    }

使用如下的请求，可以只返回`title`的映射关系。
    
    GET publications/_mapping/article/field/title

响应如下:
    
    {
       "publications": {
          "mappings": {
             "article": {
                "title": {
                   "full_name": "title",
                   "mapping": {
                      "title": {
                         "type": "text"
                      }
                   }
                }
             }
          }
       }
    }

### 多索引，多类型，多字段  Multiple Indices, Types and Fields

get字段映射API可用于通过一次调用从多个索引或类型获取多个字段的映射。 API的一般用法如下：`host：port/{index}/{type}/_mapping/field/ {field}`其中`{index}`，`{type}`和`{field}`可以 代表逗号分隔的名单或通配符列表。 为了获得所有索引的映射，你可以在`{index}`中使用`_all`。 以下是一些例子：
    
    GET /twitter,kimchy/_mapping/field/message
    
    GET /_all/_mapping/tweet,book/field/message,user.id
    
    GET /_all/_mapping/tw*/field/*.id

### 指定字段 Specifying fields

获取映射api允许您指定逗号分隔的字段列表。

例如，要选择`author`字段的`id`，必须使用其全名`author.id`。
    
    GET publications/_mapping/article/field/author.id,abstract,name

响应内容:
    
    
    {
       "publications": {
          "mappings": {
             "article": {
                "author.id": {
                   "full_name": "author.id",
                   "mapping": {
                      "id": {
                         "type": "text"
                      }
                   }
                },
                "abstract": {
                   "full_name": "abstract",
                   "mapping": {
                      "abstract": {
                         "type": "text"
                      }
                   }
                }
             }
          }
       }
    }

获取字段映射API也支持通配符表示法。    
    
    GET publications/_mapping/article/field/a*

响应:
    
    {
       "publications": {
          "mappings": {
             "article": {
                "author.name": {
                   "full_name": "author.name",
                   "mapping": {
                      "name": {
                         "type": "text"
                      }
                   }
                },
                "abstract": {
                   "full_name": "abstract",
                   "mapping": {
                      "abstract": {
                         "type": "text"
                      }
                   }
                },
                "author.id": {
                   "full_name": "author.id",
                   "mapping": {
                      "id": {
                         "type": "text"
                      }
                   }
                }
             }
          }
       }
    }

### 其他选项 Other options

`include_defaults`| 将`include_defaults = true`添加到查询字符串将导致响应包含默认值，这会被正常抑制。  
---|---
