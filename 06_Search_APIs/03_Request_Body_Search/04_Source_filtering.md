## 源文档过滤 Source filtering

允许控制`_source`字段在每个命中文档时是否返回。

默认情况下，操作会返回`_source`字段的内容，除非已经使用`stored_fields`参数或`_source`字段被禁用。


你可以使用`_source`参数关闭`_source`返回：

禁用`_source`检索设置为`false`：
    
    GET /_search
    {
        "_source": false,
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

`_source`还接受一个或多个通配符模式来控制`_source`的哪些部分应该被返回：

例如：
    
    
    GET /_search
    {
        "_source": "obj.*",
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

或
    
    GET /_search
    {
        "_source": [ "obj1.*", "obj2.*" ],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

最后，为了完全控制，你可以指定`includes`和`excludes`模式：    
    
    GET /_search
    {
        "_source": {
            "includes": [ "obj1.*", "obj2.*" ],
            "excludes": [ "*.description" ]
        },
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }
