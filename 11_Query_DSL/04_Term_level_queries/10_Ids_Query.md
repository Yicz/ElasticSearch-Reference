## Ids Query

过滤只有提供的ID的文档。 请注意，此查询使用[\_uid](mapping-uid-field.html)字段。
    
    GET /_search
    {
        "query": {
            "ids" : {
                "type" : "my_type",
                "values" : ["1", "4", "100"]
            }
        }
    }

`type`是可选的，可以省略，也可以接受一组值。 如果没有指定类型，则尝试在索引映射中定义的所有类型。
