## 地理位置边界聚合 Geo Bounds Aggregation

一个用于计算字段中地理位置数据的度量聚合。


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
    {"location": "52.374081,4.912350", "name": "NEMO Science Museum"}
    {"index":{"_id":2} }
    {"location": "52.369219,4.901618", "name": "Museum Het Rembrandthuis"}
    {"index":{"_id":3} }
    {"location": "52.371667,4.914722", "name": "Nederlands Scheepvaartmuseum"}
    {"index":{"_id":4} }
    {"location": "51.222900,4.405200", "name": "Letterenhuis"}
    {"index":{"_id":5} }
    {"location": "48.861111,2.336389", "name": "Musée du Louvre"}
    {"index":{"_id":6} }
    {"location": "48.860000,2.327000", "name": "Musée d'Orsay"}
    
    POST /museums/_search?size=0
    {
        "query" : {
            "match" : { "name" : "musée" }
        },
        "aggs" : {
            "viewport" : {
                "geo_bounds" : {
                    "field" : "location", <1>
                    "wrap_longitude" : true <2>
                }
            }
        }
    }

<1>|  `geo_bounds` 指定了用于计算边界的字段     
---|---    
<2>| `wrap_longitude` 是一个可选的参数，定义着是否允许与国际日期变更线重叠，默认是`true`
  
上述的聚合用例演示了如如何计算全部文档的地理位置。

响应的内容是:
    
    {
        ...
        "aggregations": {
            "viewport": {
                "bounds": {
                    "top_left": {
                        "lat": 48.86111099738628,
                        "lon": 2.3269999679178
                    },
                    "bottom_right": {
                        "lat": 48.85999997612089,
                        "lon": 2.3363889567553997
                    }
                }
            }
        }
    }
