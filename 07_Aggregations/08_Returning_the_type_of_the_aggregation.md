## 返回聚合类型

有时您需要知道聚合的确切类型以解析其结果。 `typed_keys`参数可以用来在响应中改变聚合的名字，这样它的前缀就是它的内部类型。

考虑下列[`date_histogram`聚合](search-aggregations-bucket-datehistogram-aggregation.html)，名为`tweets_over_time`，它有一个sub [`top_hits`聚合](search-aggregations-metrics-top-hits-aggregation.html)名为`top_users`：
    
    GET /twitter/tweet/_search?typed_keys
    {
      "aggregations": {
        "tweets_over_time": {
          "date_histogram": {
            "field": "date",
            "interval": "year"
          },
          "aggregations": {
            "top_users": {
                "top_hits": {
                    "size": 1
                }
            }
          }
        }
      }
    }
在响应中，聚合名称将分别更改为`date_histogram＃tweets_over_time`和`top_hits＃top_users`，反映每个聚合的内部类型：
    
    
    {
        "aggregations": {
            "date_histogram#tweets_over_time": { <1>
                "buckets" : [
                    {
                        "key_as_string" : "2009-01-01T00:00:00.000Z",
                        "key" : 1230768000000,
                        "doc_count" : 5,
                        "top_hits#top_users" : {  <2>
                            "hits" : {
                                "total" : 5,
                                "max_score" : 1.0,
                                "hits" : [
                                    {
                                      "_index": "twitter",
                                      "_type": "tweet",
                                      "_id": "0",
                                      "_score": 1.0,
                                      "_source": {
                                        "date": "2009-11-15T14:12:12",
                                        "message": "trying out Elasticsearch",
                                        "user": "kimchy",
                                        "likes": 0
                                      }
                                    }
                                ]
                            }
                        }
                    }
                ]
            }
        },
        ...
    }

<1>| 现在`tweets_over_time`这个名字包含`date_histogram`前缀。     
---|---   
<2>| 名字`top_users`现在包含`top_hits`前缀。   
  
![Note](/images/icons/note.png)对于某些聚合，返回的类型可能与提供请求的类型不同。`Terms`, `Significant Terms`和 `Percentiles` 聚合的情况就是如此，其中返回的类型还包含有关目标字段类型的信息：`lterms`（对于长字段中的术语聚合），`sigsterms` (在字段字段上的聚合)，`tdigest_percentiles`（基于TDigest算法的百分位聚合）。
