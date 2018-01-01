## 类型查询 Type Query


通过提供的映射类型（document/mapping）进行过滤文档
    
    GET /_search
    {
        "query": {
            "type" : {
                "value" : "my_type"
            }
        }
    }
