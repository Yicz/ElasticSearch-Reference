## 统计聚合 Stats Aggregation

一个`多值`度量聚合，用于计算从汇总文档中提取的数值的统计数据。 这些值可以从文档中的特定数字字段中提取，也可以由提供的脚本生成。

返回的统计信息包括：`min`，`max`，`sum`，`count`和`avg`。

假设数据由表示学生的考试成绩（0到100）的文档组成
    
    {
        "aggs" : {
            "grades_stats" : { "stats" : { "field" : "grade" } }
        }
    }
上面的聚合计算所有文档的等级统计。 聚合类型是`stats`，`field`设置定义了将要计算统计数据的文档的数字字段。 以上将返回以下内容：
    
    
    {
        ...
    
        "aggregations": {
            "grades_stats": {
                "count": 6,
                "min": 60,
                "max": 98,
                "avg": 78.5,
                "sum": 471
            }
        }
    }

聚集的名称（上面的`grades_stats`）也可以作为从返回的响应中检索聚合结果的键值。
### Script

根据脚本计算成绩统计：    
    
    {
        ...,
    
        "aggs" : {
            "grades_stats" : {
                 "stats" : {
                     "script" : {
                         "lang": "painless",
                         "inline": "doc['grade'].value"
                     }
                 }
             }
        }
    }

这将使用`painless`脚本语言将`script`参数解释为`inline`脚本，并且没有脚本参数。 要使用文件脚本，请使用以下语法：
    
    
    {
        ...,
    
        "aggs" : {
            "grades_stats" : {
                "stats" : {
                    "script" : {
                        "file": "my_script",
                        "params" : {
                            "field" : "grade"
                        }
                    }
                }
            }
        }
    }

![Tip](/images/icons/tip.png)

对于保存在`.script`索引脚本，用`id`参数替换`file`参数。

#### Value Script

事实证明，考试是远高于学生的水平，需要适用等级修正。 我们可以使用值脚本来获取新的统计信息：    
    
    {
        "aggs" : {
            ...
    
            "aggs" : {
                "grades_stats" : {
                    "stats" : {
                        "field" : "grade",
                        "script" :
                            "lang": "painless",
                            "inline": "_value * params.correction",
                            "params" : {
                                "correction" : 1.2
                            }
                        }
                    }
                }
            }
        }
    }

### 缺省值 Missing value

`missing`参数定义了如何处理缺少值的文档。 默认情况下，它们将被忽略，但也可以把它们看作是有价值的。
    
    
    {
        "aggs" : {
            "grades_stats" : {
                "stats" : {
                    "field" : "grade",
                    "missing": 0 <1>
                }
            }
        }
    }

<1>| 文档中如果`grade`字段中没有值，将会默认设置`0`进行使用。
---|---
