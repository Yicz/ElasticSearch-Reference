## 因子分数查询 Boosting Query

“boosting”查询可用于有效降级与给定查询匹配的结果。 与bool查询中的“NOT”子句不同，这仍然会选择包含不合意词汇的文档，但会降低总体分数。

    GET /_search
    {
        "query": {
            "boosting" : {
                "positive" : {
                    "term" : {
                        "field1" : "value1"
                    }
                },
                "negative" : {
                     "term" : {
                         "field2" : "value2"
                    }
                },
                "negative_boost" : 0.2
            }
        }
    }
