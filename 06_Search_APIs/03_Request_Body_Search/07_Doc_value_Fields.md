## 文档值字段 Doc value Fields

允许为每个匹配返回字段的[文档值doc value](doc-values.html)展示，例如：
Allows to return the [文档值 doc value](doc-values.html) representation of a field for each hit, for example:
    
    
    GET /_search
    {
        "query" : {
            "match_all": {}
        },
        "docvalue_fields" : ["test1", "test2"]
    }

文档值字段可以在未存储的字段上工作。

请注意，如果fields参数指定没有文档值的字段，则会尝试从fielddata缓存中加载该值，导致该字段的条件被加载到内存（缓存），这将导致更多的内存消耗。
