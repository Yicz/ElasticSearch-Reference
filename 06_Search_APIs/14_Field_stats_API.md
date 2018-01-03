## 字段状态API Field stats API（在 5.4.0版本中已经被弃用）

![Warning](/images/icons/warning.png)此功能是实验性的，可能会在将来的版本中完全更改或删除。ES将采取尽最大努力解决任何问题，但实验功能不受支持官方遗传算法功能的SLA。

![Warning](/images/icons/warning.png)

### 在 5.4.0版本中已经被弃用. 

不推荐使用`_field_stats`，而是使用`_field_caps`，或者在所需字段上运行最小/最大聚合

字段状态api允许查找字段的统计属性而不执行搜索，但查找Lucene索引中本地可用的度量。 这对探索一个你不太了解的数据集是有用的。 例如，这允许根据值的最小/最大范围创建具有有意义间隔的直方图聚合。

缺省情况下字段状态api在所有索引上执行，但也可以在特定索引上执行。

在所有索引上运行：

    
    
    GET _field_stats?fields=rating

指定索引:
    
    
    GET twitter/_field_stats?fields=rating

支持的请求选项：

`fields`| 计算统计信息的字段列表。 该字段名称支持通配符表示法。 例如，使用`text_*`将导致返回匹配表达式的所有字段。   
---|---    
`level`| 定义是否应在每个索引级别或集群级别上返回字段统计信息。 有效值是“索引”和“集群”（默认）。 
  
或者，也可以在请求主体中定义`fields`选项：    
    
    POST _field_stats?level=indices
    {
       "fields" : ["rating"]
    }

### 字段统计分析

字段状态api支持基于字符串，基于数字和日期的字段，并且可以返回以下每个字段的统计信息：

`max_doc`| 文件总数。    
---|---    
`doc_count`| 对于此字段至少有一个术语的文档数量，如果此度量在一个或多个分片上不可用，则为-1。  
`density`| 该字段至少有一个值的文档的百分比。 这是一个派生统计量，基于`max_doc`和`doc_count`。  
`sum_doc_freq`| 每个词条在此字段中文档频率的总和，如果此测量不适用于一个或多个分片，则为-1。 文档频率是包含特定词条的文档的数量。    
`sum_total_term_freq`| 所有文档中该字段中所有术语的术语频率总和，如果此测量不适用于一个或多个分片，则为-1。 术语频率是特定文档和字段中术语的总发生次数。  
  
`is_searchable`

    如果该字段的任何实例都是可搜索的，则为true，否则为false。

`is_aggregatable`

    如果该字段的任何实例是可聚合的，则为true，否则为false。

`min_value`

    该字段中的最低值。

`min_value_as_string`

    以可显示的形式表示的字段中的最小值。 所有字段，但字符串字段返回这个。 （因为字符串字段，表示值已经是字符串）

`max_value`

    在该字段的最大值。

`max_value_as_string`

    以可显示的形式表示的字段中的最高值。 所有字段，但字符串字段返回这个。 （因为字符串字段，表示值已经是字符串）

![Note](/images/icons/note.png)标记为已删除（但尚未被合并过程删除）的文档仍会影响所有提到的统计信息。

###  集群级别字段统计示例

请求:
    
    
    GET _field_stats?fields=rating,answer_count,creation_date,display_name

响应:
    
    
    {
       "_shards": {
          "total": 1,
          "successful": 1,
          "failed": 0
       },
       "indices": {
          "_all": { <1>
             "fields": {
                "creation_date": {
                   "max_doc": 1326564,
                   "doc_count": 564633,
                   "density": 42,
                   "sum_doc_freq": 2258532,
                   "sum_total_term_freq": -1,
                   "min_value": "2008-08-01T16:37:51.513Z",
                   "max_value": "2013-06-02T03:23:11.593Z",
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                },
                "display_name": {
                   "max_doc": 1326564,
                   "doc_count": 126741,
                   "density": 9,
                   "sum_doc_freq": 166535,
                   "sum_total_term_freq": 166616,
                   "min_value": "0",
                   "max_value": "정혜선",
                   "is_searchable": "true",
                   "is_aggregatable": "false"
                },
                "answer_count": {
                   "max_doc": 1326564,
                   "doc_count": 139885,
                   "density": 10,
                   "sum_doc_freq": 559540,
                   "sum_total_term_freq": -1,
                   "min_value": 0,
                   "max_value": 160,
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                },
                "rating": {
                   "max_doc": 1326564,
                   "doc_count": 437892,
                   "density": 33,
                   "sum_doc_freq": 1751568,
                   "sum_total_term_freq": -1,
                   "min_value": -14,
                   "max_value": 1277,
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                }
             }
          }
       }
    }

<1>| `_all`键表示它包含集群中所有索引的字段统计信息。     
---|---  
  
![Note](/images/icons/note.png)

在使用集群级别字段统计信息时，如果在具有不兼容类型的不同索引中使用相同字段，则可能会发生冲突。 例如，long类型的字段与`float`或`string`类型的字段不兼容。 如果发生一个或多个冲突，则将一个`conflict`内容添加到响应中。 它包含所有冲突的领域和不兼容的原因。
    
    
    {
       "_shards": {
          "total": 1,
          "successful": 1,
          "failed": 0
       },
       "indices": {
          "_all": {
             "fields": {
                "creation_date": {
                   "max_doc": 1326564,
                   "doc_count": 564633,
                   "density": 42,
                   "sum_doc_freq": 2258532,
                   "sum_total_term_freq": -1,
                   "min_value": "2008-08-01T16:37:51.513Z",
                   "max_value": "2013-06-02T03:23:11.593Z",
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                }
             }
          }
       },
       "conflicts": {
            "field_name_in_conflict1": "reason1",
            "field_name_in_conflict2": "reason2"
       }
    }

#### 指标级别字段统计示例

请求:
    
    
    GET _field_stats?fields=rating,answer_count,creation_date,display_name&level=indices

响应:
    
    
    {
       "_shards": {
          "total": 1,
          "successful": 1,
          "failed": 0
       },
       "indices": {
          "stack": { <1>
             "fields": {
                "creation_date": {
                   "max_doc": 1326564,
                   "doc_count": 564633,
                   "density": 42,
                   "sum_doc_freq": 2258532,
                   "sum_total_term_freq": -1,
                   "min_value": "2008-08-01T16:37:51.513Z",
                   "max_value": "2013-06-02T03:23:11.593Z",
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                },
                "display_name": {
                   "max_doc": 1326564,
                   "doc_count": 126741,
                   "density": 9,
                   "sum_doc_freq": 166535,
                   "sum_total_term_freq": 166616,
                   "min_value": "0",
                   "max_value": "정혜선",
                   "is_searchable": "true",
                   "is_aggregatable": "false"
                },
                "answer_count": {
                   "max_doc": 1326564,
                   "doc_count": 139885,
                   "density": 10,
                   "sum_doc_freq": 559540,
                   "sum_total_term_freq": -1,
                   "min_value": 0,
                   "max_value": 160,
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                },
                "rating": {
                   "max_doc": 1326564,
                   "doc_count": 437892,
                   "density": 33,
                   "sum_doc_freq": 1751568,
                   "sum_total_term_freq": -1,
                   "min_value": -14,
                   "max_value": 1277,
                   "is_searchable": "true",
                   "is_aggregatable": "true"
                }
             }
          }
       }
    }

<1>|`stack`键意味着它包含`stack`索引的所有字段统计信息。    
---|---  
  
### 字段统计索引约束

字段统计索引约束允许省略与约束不匹配的索引的所有字段统计信息。 索引约束可以根据“min_value”和“max_value”统计量来排除索引的字段统计信息。 这个选项只有在`level`选项设置为`indices`时才有用。 当索引约束被定义时，没有索引（不可搜索）的字段总是被省略。

例如，索引约束对于在基于时间的场景中查找数据的特定属性的最小值和最大值非常有用。 以下请求仅返回2014年创建的存有问题的索引的“answer_count”属性的字段统计信息：
    
    
    POST _field_stats?level=indices
    {
       "fields" : ["answer_count"], <1>
       "index_constraints" : { <2>
          "creation_date" : { <3>
             "max_value" : { <4>
                "gte" : "2014-01-01T00:00:00.000Z"
             },
             "min_value" : { <5>
                "lt" : "2015-01-01T00:00:00.000Z"
             }
          }
       }
    }

<1>|计算并返回字段统计信息的字段。   
---|---    
<2>| 设置索引约束。 请注意，索引约束可以为未在“fields”选项中定义的字段定义。    
<3>| “create_date”字段的索引约束。     
<4> <5>| 字段统计信息的`max_value`和`min_value`属性的索引限制。   
  
对于一个字段，可以在`min_value`统计量，`max_value`统计量或两者上定义索引约束。 每个索引约束都支持以下比较：

`gte`| 大于或等于    
---|---    
`gt`| 大于    
`lte`| 小于或等于
`lt`| 小于   
  
日期字段上的字段统计信息索引约束可以接受`format`选项，用于解析约束的值。 如果缺少，则使用字段映射中配置的格式。
    
    
    POST _field_stats?level=indices
    {
       "fields" : ["answer_count"],
       "index_constraints" : {
          "creation_date" : {
             "max_value" : {
                "gte" : "2014-01-01",
                "format" : "date_optional_time" <1>
             },
             "min_value" : {
                "lt" : "2015-01-01",
                "format" : "date_optional_time"
             }
          }
       }
    }

<1>| 自定义日期格式    
---|---
