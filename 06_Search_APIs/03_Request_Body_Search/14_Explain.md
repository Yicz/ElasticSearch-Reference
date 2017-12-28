## 明细 Explain

对每个命中文档的分数进行解释。    
    
    GET /_search
    {
        "explain": true,
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }
