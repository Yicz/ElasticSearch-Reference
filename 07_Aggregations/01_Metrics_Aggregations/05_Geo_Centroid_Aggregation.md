## 地理位置中心聚合 Geo Centroid Aggregation

一个用于衡量[Geo-point 数据类型](geo-point.html)中心定位的度量聚合，

示例:
    
    
    PUT /museums
    {
        "mappings": {
            "doc": {
                "properties": {
                    "location": {
                        "type": "geo_point"
                    }
                }
            }
        }
    }
    
    POST /museums/doc/_bulk?refresh
    {"index":{"_id":1} }
    {"location": "52.374081,4.912350", "city": "Amsterdam", "name": "NEMO Science Museum"}
    {"index":{"_id":2} }
    {"location": "52.369219,4.901618", "city": "Amsterdam", "name": "Museum Het Rembrandthuis"}
    {"index":{"_id":3} }
    {"location": "52.371667,4.914722", "city": "Amsterdam", "name": "Nederlands Scheepvaartmuseum"}
    {"index":{"_id":4} }
    {"location": "51.222900,4.405200", "city": "Antwerp", "name": "Letterenhuis"}
    {"index":{"_id":5} }
    {"location": "48.861111,2.336389", "city": "Paris", "name": "Musée du Louvre"}
    {"index":{"_id":6} }
    {"location": "48.860000,2.327000", "city": "Paris", "name": "Musée d'Orsay"}
    
    POST /museums/_search?size=0
    {
        "aggs" : {
            "centroid" : {
                "geo_centroid" : {
                    "field" : "location" <1>
                }
            }
        }
    }

<1>| `geo_centroid`聚合指定了用来计算一个定位中心。（提示：字段必须是一个[Geo-point datatype](geo-point.html) 类型）
---|---  
  
上述聚合演示了如何进行计算文档中的定位中心。

响应的内容如下：
    
    
    {
        ...
        "aggregations": {
            "centroid": {
                "location": {
                    "lat": 51.009829603135586,
                    "lon": 3.966213036328554
                }
            }
        }
    }

`geo_centorid`作为归类聚合的子聚合，会更加地有趣。

例如:
    
    
    POST /museums/_search?size=0
    {
        "aggs" : {
            "cities" : {
                "terms" : { "field" : "city.keyword" },
                "aggs" : {
                    "centroid" : {
                        "geo_centroid" : { "field" : "location" }
                    }
                }
            }
        }
    }

上述演示了使用`terms`归类聚合，并结合了`geo_centorid`聚合，用来计算城市的中心位置。

响应如下:
    
    
    {
        ...
        "aggregations": {
            "cities": {
                "sum_other_doc_count": 0,
                "doc_count_error_upper_bound": 0,
                "buckets": [
                   {
                       "key": "Amsterdam",
                       "doc_count": 3,
                       "centroid": {
                          "location": {
                             "lat": 52.371655656024814,
                             "lon": 4.909563269466162
                          }
                       }
                   },
                   {
                       "key": "Paris",
                       "doc_count": 2,
                       "centroid": {
                          "location": {
                             "lat": 48.86055544484407,
                             "lon": 2.331694420427084
                          }
                       }
                    },
                    {
                        "key": "Antwerp",
                        "doc_count": 1,
                        "centroid": {
                           "location": {
                              "lat": 51.222899928689,
                              "lon": 4.405199903994799
                           }
                        }
                     }
                ]
            }
        }
    }
