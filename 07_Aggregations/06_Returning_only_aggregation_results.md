## Returning only aggregation results

有很多场合需要聚合，但不是需要搜索命中文档。 对于这些情况，可以通过设置`size = 0`来忽略命中文档。 例如：
    
    
    GET /twitter/tweet/_search
    {
      "size": 0,
      "aggregations": {
        "my_agg": {
          "terms": {
            "field": "text"
          }
        }
      }
    }

将`size`设置为`0`可以避免执行搜索的提取阶段，使请求更加高率。