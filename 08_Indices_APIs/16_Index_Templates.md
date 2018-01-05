## 索引模板 Index Templates

索引模板允许在建立索引的时候进行引用，无需再定义设置。索引模板包含设置和映射关系的信息，还一个用于在建立索引时候进行匹配是否引用的模式。

![Note](/images/icons/note.png)

模板只有在索引建立的时候进行使用。改变模板的内容并不会响应到使用该模板建立的索引。

例如：
    
    PUT _template/template_1
    {
      "template": "te*",
      "settings": {
        "number_of_shards": 1
      },
      "mappings": {
        "type1": {
          "_source": {
            "enabled": false
          },
          "properties": {
            "host_name": {
              "type": "keyword"
            },
            "created_at": {
              "type": "date",
              "format": "EEE MMM dd HH:mm:ss Z YYYY"
            }
          }
        }
      }
    }

![Note](/images/icons/note.png)

索引模板提供了类似C语言风格的块注释（/* \*/）.注释允许在JSON文档中进行解释说明，JSON文档中除了在开始的大括号之前，都允许注释。

下面定义了一个名为`template_1`的模板，使用的匹配模式为`te*`.所以该文档为应用于名称可以匹配`te*`的索引。

同时模板中可以包含索引别名。
    
    
    PUT _template/template_1
    {
        "template" : "te*",
        "settings" : {
            "number_of_shards" : 1
        },
        "aliases" : {
            "alias1" : {},
            "alias2" : {
                "filter" : {
                    "term" : {"user" : "kimchy" }
                },
                "routing" : "kimchy"
            },
            "{index}-alias" : {} <1>
        }
    }

<1>| 别名中使用的`{index}`点位符会在索引模板被应用去创建索引的时候，由真实的索引名称进行替换。
---|---  
  
### 删除一个索引模板 Deleting a Template

索引模板由模板的名称进行标识（在上面的例子中是`template_1`）,可以使用如下的请求进行删除：
    
    DELETE /_template/template_1

### 获取模板 Getting templates


索引模板由模板的名称进行标识（在上面的例子中是`template_1`）,可以使用如下的请求进行检索：    
    
    GET /_template/template_1

可以使用模式匹配或以逗号分隔的列表进行检索多个索引模板。    
    
    GET /_template/temp*
    GET /_template/template_1,template_2

获取全部的索引模板可以使用如下的请求:
    
    
    GET /_template

### 判断模板是否存在 Template exists

可以使用`HEAD`请求去判断一模板是否存在：    
    
    HEAD _template/template_1

返回的HTTP状态码可以表示索引模板是否存在：`404`表示不存在，`200`表示存在。

###  多模板匹配 Multiple Templates Matching

一个索引可以匹配多个索引模板，在这种情况下，会默认合并两个索引模板中的`settings`和`mappings`形成最后的索引。合并的顺序可以使用`order`参数进行指定，`order`大的模板会覆盖小的模板内容：
    
    
    PUT /_template/template_1
    {
        "template" : "*",
        "order" : 0,
        "settings" : {
            "number_of_shards" : 1
        },
        "mappings" : {
            "type1" : {
                "_source" : { "enabled" : false }
            }
        }
    }
    
    PUT /_template/template_2
    {
        "template" : "te*",
        "order" : 1,
        "settings" : {
            "number_of_shards" : 1
        },
        "mappings" : {
            "type1" : {
                "_source" : { "enabled" : true }
            }
        }
    }

在上面的例子中，`_source`的内容在两个定义的模板中不一样。但如果两个模板被应用于同一个索引，则会使用`template_2`中的配置覆盖`template_1`中不同的设置，其他不一样的设置将会进行合并应用。

### 模板的版本控制 Template Versioning

模板可以进行赋予一个`version`版本号,使用外部系统进行管理时，版本号可以是任意的整数。`version`是可选的配置。在未配置的时候，模板会被简单地替换。
    
    PUT /_template/template_1
    {
        "template" : "*",
        "order" : 0,
        "settings" : {
            "number_of_shards" : 1
        },
        "version": 123
    }

为了检查模板的`version`，可以使用`filter_path`进行只响应`version`的输出：
    
    
    GET /_template/template_1?filter_path=*.version

响应内容会变得简单而高效：    
    
    {
      "template_1" : {
        "version" : 123
      }
    }
