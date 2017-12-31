## 平均值聚合 Avg Aggregation

`单值(single-value)`度量值聚合，计算从聚合文档中提取的数值的平均值。 这些值可以从文档中的特定数字字段中提取，也可以由提供的脚本生成。

假设数据包含代表考试成绩（介于0和100之间）的学生，我们可以将他们的成绩平均为：
    
    
    POST /exams/_search?size=0
    {
        "aggs" : {
            "avg_grade" : { "avg" : { "field" : "grade" } }
        }
    }

上面的聚合计算了所有文档的平均分数。 聚合类型是`avg`，`field`设置定义了将要计算平均值的文档的数字字段。 以上将返回以下内容：
    
    
    {
        ...
        "aggregations": {
            "avg_grade": {
                "value": 75.0
            }
        }
    }

聚集的名称（上面的`avg_grade`）也可以作为从返回的响应中检索聚合结果的键。

### 脚本

根据脚本计算平均成绩：    
    
    POST /exams/_search?size=0
    {
        "aggs" : {
            "avg_grade" : {
                "avg" : {
                    "script" : {
                        "inline" : "doc.grade.value"
                    }
                }
            }
        }
    }

这将使用`painless`脚本语言将`script`参数解释为`inline`脚本，并且没有脚本参数。 要使用文件脚本，请使用以下语法：
    
    
    POST /exams/_search?size=0
    {
        "aggs" : {
            "avg_grade" : {
                "avg" : {
                    "script" : {
                        "file": "my_script",
                        "params": {
                            "field": "grade"
                        }
                    }
                }
            }
        }
    }

![Tip](/images/icons/tip.png)

对于保存在`.script`索引脚本，用`id`参数替换`file`参数。

#### 值脚本 Value Script

事实证明，考试是远高于学生的水平，需要适用等级修正。 我们可以使用值脚本来获得新的平均值：
    
    
    POST /exams/_search?size=0
    {
        "aggs" : {
            "avg_corrected_grade" : {
                "avg" : {
                    "field" : "grade",
                    "script" : {
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

### 缺少值 Missing value

`missing`参数定义了如何处理缺少值的文档。 默认情况下，它们将被忽略，但也可以把它们看作是有价值的。
    
    
    POST /exams/_search?size=0
    {
        "aggs" : {
            "grade_avg" : {
                "avg" : {
                    "field" : "grade",
                    "missing": 10 <1>
                }
            }
        }
    }

<1>| 在`grade`字段中没有值的文档将与具有值“10”的文档一起归入同一个文档。
---|---
