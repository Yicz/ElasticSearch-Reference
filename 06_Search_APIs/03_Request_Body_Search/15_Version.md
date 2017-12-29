## 版本 Version

为每个检索命中文档返回版本值。    
    
    GET /_search
    {
        "version": true,
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }
