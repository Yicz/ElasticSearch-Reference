## 聚合元数据 Aggregation Metadata

您可以在请求时将一段元数据与单个聚合关联，并在响应时返回。

考虑这个例子，我们想把蓝色与我们的“terms”聚合关联起来。
    
    GET /twitter/tweet/_search
    {
      "size": 0,
      "aggs": {
        "titles": {
          "terms": {
            "field": "title"
          },
          "meta": {
            "color": "blue"
          }
        }
      }
    }

然后这段元数据将被返回到我们的`titles`词汇聚合    
    
    {
        "aggregations": {
            "titles": {
                "meta": {
                    "color" : "blue"
                },
                "doc_count_error_upper_bound" : 0,
                "sum_other_doc_count" : 0,
                "buckets": [
                ]
            }
        },
        ...
    }
