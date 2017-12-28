##  最小评分 min_score

排除具有小于`min_score`中指定的最小值_score的文档：    
    
    GET /_search
    {
        "min_score": 0.5,
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

请注意，大多数情况下，这没有多大意义，但提供给高级用例。