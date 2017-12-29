## Sort

允许在特定字段上添加一个或多个排序。 每种排序也可以颠倒。 排序是在每个字段级别上定义的，`_score`的特殊字段名称按分数排序，`_doc`按索引排序排序。

假设以下索引映射：
    
    
    PUT /my_index
    {
        "mappings": {
            "my_type": {
                "properties": {
                    "post_date": { "type": "date" },
                    "user": {
                        "type": "keyword"
                    },
                    "name": {
                        "type": "keyword"
                    },
                    "age": { "type": "integer" }
                }
            }
        }
    }
    
    
    GET /my_index/my_type/_search
    {
        "sort" : [
            { 
                "post_date" : { "order" : "asc" } 
            },
            "user",
            { "name" : "desc" },
            { "age" : "desc" },
            "_score"
        ],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

![Note](/images/icons/note.png)

除了最有效的排序顺序外，`_doc`没有真正的用例。 所以如果你不关心文件返回的顺序，那么你应该用`_doc`来排序。 这在[滚动 scrolling](search-request-scroll.html)时特别有用。

### 排序值 Sort Values

返回的每个文档的排序值也作为响应的一部分返回。

### Sort Order

`order`选项可以有以下值：

`asc`| 按升序排序     
---|---    
`desc`| 按倒序排序  

当在`_score`上进行排序时，顺序默认为`desc`，排序时默认为`asc`。

### 排序模式选项 Sort mode option

Elasticsearch支持按数组或多值字段进行排序。 `mode`选项控制选择哪个数组值来排序它所属的文档。 `mode`选项可以有以下值：

`min`|选择最小的价值。    
---|---    
`max`| 选择最大的价值。  
`sum`| 使用所有值的总和作为排序值。 仅适用于基于数字的数组字段。     
`avg`| 使用所有值的平均值作为排序值。 仅适用于基于数字的数组字段。     
`median`| 使用所有值的中位数作为排序值。 仅适用于基于数字的数组字段。  
  
#### 排序模式示例用法

在下面的示例中，字段价格具有每个文档的多个价格。 在这种情况下，结果点击将根据每份文件的平均价格按照价格上升进行排序。
    
    
    PUT /my_index/my_type/1?refresh
    {
       "product": "chocolate",
       "price": [20, 4]
    }
    
    POST /_search
    {
       "query" : {
          "term" : { "product" : "chocolate" }
       },
       "sort" : [
          {"price" : {"order" : "asc", "mode" : "avg"} }
       ]
    }

### 在嵌套对象中排序 Sorting within nested objects.

Elasticsearch也支持在一个或多个嵌套对象内的字段进行排序。 嵌套字段支持的排序在已有的排序选项之上具有以下参数：

`nested_path`
     定义要排序的嵌套对象。 实际的排序字段必须是此嵌套对象内的直接字段。 当按嵌套字段排序时，该字段是必需的。
`nested_filter`
     一个过滤器，嵌套路径内的内部对象应匹配，以便通过排序考虑其字段值。 常见的情况是在嵌套的过滤器或查询中重复查询/过滤器。 默认情况下，没有激活`nested_filter`。

#### 嵌套排序的例子 Nested sorting example

在下面的例子中`offer`是一个`nested`类型的字段。 需要指定`nested_path`; 否则，elasticsearch不知道需要捕获什么嵌套级别的排序值。
    
    
    POST /_search
    {
       "query" : {
          "term" : { "product" : "chocolate" }
       },
       "sort" : [
           {
              "offer.price" : {
                 "mode" :  "avg",
                 "order" : "asc",
                 "nested_path" : "offer",
                 "nested_filter" : {
                    "term" : { "offer.color" : "blue" }
                 }
              }
           }
        ]
    }

当按脚本排序和按地理距离排序时，也支持嵌套排序。

### 缺少值 Missing Values

`missing`参数指定应如何处理丢失字段的文档：`missing`值可以设置为`_last`，`_first`或自定义值（将用于丢失的文档作为排序值）。 默认是`_last`。


用例：
    
    GET /_search
    {
        "sort" : [
            { "price" : {"missing" : "_last"} }
        ],
        "query" : {
            "term" : { "product" : "chocolate" }
        }
    }

![Note](/images/icons/note.png)

如果嵌套的内部对象与`nested_filter`不匹配，则使用缺少的值。

### 忽略未映射的字段 Ignoring Unmapped Fields

默认情况下，如果没有与字段关联的映射，搜索请求将失败。 `unmapped_type`选项允许忽略没有映射的字段，而不是按照它们排序。 此参数的值用于确定要发射的排序值。 这是一个如何使用它的例子：
    
    
    GET /_search
    {
        "sort" : [
            { "price" : {"unmapped_type" : "long"} }
        ],
        "query" : {
            "term" : { "product" : "chocolate" }
        }
    }

如果查询的任何索引没有`price`的映射，那么Elasticsearch将处理它，就好像存在`long`类型的映射一样，该索引中的所有文档都没有该字段的值。

### 地理距离排序

允许按`_geo_distance`进行排序。 这里是一个例子，假设`pin.location`是一个类型为`geo_point`的字段：    
    
    GET /_search
    {
        "sort" : [
            {
                "_geo_distance" : {
                    "pin.location" : [-70, 40],
                    "order" : "asc",
                    "unit" : "km",
                    "mode" : "min",
                    "distance_type" : "arc"
                }
            }
        ],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

`distance_type`
     如何计算距离。 既可以是`arc（弧形)`（默认），也可以是`plane(平面）`（更快，但在远距离和接近极点时不准确）。
`mode`
     如果某个字段有几个地理位置，该怎么办。默认情况下，按升序排序时将考虑最短距离，按降序排序时最长距离。支持的值是`min`，`max`，`median`和`avg`。
`unit`
     计算排序值时使用的单位。 默认值是`m`（米）。
![Note](/images/icons/note.png)

地理距离排序不支持可配置的缺失值：当文档没有用于距离计算的字段的值时，距离总是被认为等于“无穷大”。

提供坐标支持以下格式：

#### Lat Lon（纬度，经度）作为属性
    
    
    GET /_search
    {
        "sort" : [
            {
                "_geo_distance" : {
                    "pin.location" : {
                        "lat" : 40,
                        "lon" : -70
                    },
                    "order" : "asc",
                    "unit" : "km"
                }
            }
        ],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

#### Lat Lon （纬度，经度）作为字符

格式 `lat,lon`（纬度，经度）.
    
    
    GET /_search
    {
        "sort" : [
            {
                "_geo_distance" : {
                    "pin.location" : "40,-70",
                    "order" : "asc",
                    "unit" : "km"
                }
            }
        ],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

#### 地理散列 Geohash
    
    
    GET /_search
    {
        "sort" : [
            {
                "_geo_distance" : {
                    "pin.location" : "drm3btev3e86",
                    "order" : "asc",
                    "unit" : "km"
                }
            }
        ],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

#### Lat Lon （纬度，经度）作为数组

在`[lon，lat]`中格式化，请注意这里lon/lat的顺序，以符合[GeoJSON](http://geojson.org/)。
    
    GET /_search
    {
        "sort" : [
            {
                "_geo_distance" : {
                    "pin.location" : [-70, 40],
                    "order" : "asc",
                    "unit" : "km"
                }
            }
        ],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

### 多个参考点 Multiple reference points

例如，多个地理点可以作为包含任何`geo_point`格式的数组传递    
    
    GET /_search
    {
        "sort" : [
            {
                "_geo_distance" : {
                    "pin.location" : [[-70, 40], [-71, 42]],
                    "order" : "asc",
                    "unit" : "km"
                }
            }
        ],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

等等。

文档的最终距离将被包含在文档中的所有点的`最小距离 min`/`最大距离 max`/`平均距离 avg`（通过`mode`定义）到排序请求中给出的所有点。

### 基于脚本的排序 Script Based Sorting

允许根据自定义脚本进行排序，这里是一个例子：    
    
    GET /_search
    {
        "query" : {
            "term" : { "user" : "kimchy" }
        },
        "sort" : {
            "_script" : {
                "type" : "number",
                "script" : {
                    "lang": "painless",
                    "inline": "doc['field_name'].value * params.factor",
                    "params" : {
                        "factor" : 1.1
                    }
                },
                "order" : "asc"
            }
        }
    }

### 跟踪分数 Track Scores

在字段排序时，不计算分数。 通过将“track_scores”设置为true，分数仍将被计算和跟踪。
    
    
    GET /_search
    {
        "track_scores": true,
        "sort" : [
            { "post_date" : {"order" : "desc"} },
            { "name" : "desc" },
            { "age" : "desc" }
        ],
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

### 内存注意事项 Memory Considerations

排序时，相关的排序字段值被加载到内存中。 这意味着每个碎片都应该有足够的内存来容纳它们。 对于基于字符串的类型，不应该对排序的字段进行分析/标记。 对于数字类型，如果可能的话，建议将类型显式设置为更窄的类型（如`short`，`integer`和`float`）。
