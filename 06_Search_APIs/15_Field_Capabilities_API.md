## 字段职能API Field Capabilities API

![Warning](/images/icons/warning.png)此功能是实验性的，可能会在将来的版本中完全更改或删除。ES将采取尽最大努力解决任何问题，但实验功能不受支持官方遗传算法功能的SLA。

字段功能API允许在多个索引中检索字段的功能。

默认情况下字段功能api在所有索引上执行：
    
    
    GET _field_caps?fields=rating

但是请求也可以限制在特定的索引中：
    
    GET twitter/_field_caps?fields=rating

或者，也可以在请求主体中定义`fields`选项：    
    
    POST _field_caps
    {
       "fields" : ["rating"]
    }

支持的请求选项：

`fields`|计算统计信息的字段列表。 该字段名称支持通配符表示法。 例如，使用`text_ *`将导致返回匹配表达式的所有字段。    
---|---   
`searchable`| 该字段是否被索引用于在所有索引上进行搜索。    
`aggregatable`| 该字段是否可以汇总在所有的指标上。    
`indices`| 该字段具有相同类型的索引列表;如果所有索引具有相同类型的字段，则为null。
`non_searchable_indices`| 该字段不可搜索的索引列表;如果所有索引具有相同的字段定义，则为null。
`non_aggregatable_indices`| 该字段不可聚合的索引列表;如果所有索引具有相同的字段定义，则为null。 
  
### 响应格式

请求:
    
    
    GET _field_caps?fields=rating,title

响应：

    {
        "fields": {
            "rating": { <1>
                "long": {
                    "searchable": true,
                    "aggregatable": false,
                    "indices": ["index1", "index2"],
                    "non_aggregatable_indices": ["index1"] <2>
                },
                "keyword": {
                    "searchable": false,
                    "aggregatable": true,
                    "indices": ["index3", "index4"],
                    "non_searchable_indices": ["index4"] <3>
                }
            },
            "title": { <4>
                "text": {
                    "searchable": true,
                    "aggregatable": false
    
                }
            }
        }
    }

<1>| 字段`rating`在`index1`和`index2`中定义为一个`long`类型，在`index3`和`index4`中定义为`keyword`类型。    
---|---    
<2>| `rating`字段不能在`index1`中聚合.     
<3>| `index4`中不能搜索`rating`字段。    
<4>| 在所有索引中，`title`字段被定义为`text`。
