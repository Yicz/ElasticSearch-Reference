## 拓展数据统计聚合 Extended Stats Aggregation

`多值（multi-value）`度量聚合，计算从文档中提取出的数据状态。也可以人为地使用脚本进行提供数据。

拓展数据统计聚合是是`stats`聚合的一个拓展版本，添加了额外的度量数据 `sum_of_squares`, `variance`, `std_deviation` 和 `std_deviation_bounds`。

假设数据包含代表考试成绩（介于0和100之间）的学生，我们可以将他们的成绩展示为：    
    
    {
        "aggs" : {
            "grades_stats" : { "extended_stats" : { "field" : "grade" } }
        }
    }

上述的聚合会计算所有`grades`文档的数据，使用的聚合类型是`extended_stats`并定义`field`进行了指定用于计算的字段。请返回如下的内容：
    
    {
        ...
    
        "aggregations": {
            "grade_stats": {
               "count": 9,
               "min": 72,
               "max": 99,
               "avg": 86,
               "sum": 774,
               "sum_of_squares": 67028,
               "variance": 51.55555555555556,
               "std_deviation": 7.180219742846005,
               "std_deviation_bounds": {
                "upper": 100.36043948569201,
                "lower": 71.63956051430799
               }
            }
        }
    }

聚合的名称`grades_stats`也作为响应内容中的键值进行检索返回。

### 标准差 Standard Deviation Bounds 
默认地，`extended_stats`聚合会返回一个叫做`std_deviation_bounds`的对象，它提供了内部一正一负的标准差（stand deviations），可以方便的查看你的方差数据的边界。例如，下面的方差例子，你可以在请求中设置`sima`:
    
    
    {
        "aggs" : {
            "grades_stats" : {
                "extended_stats" : {
                    "field" : "grade",
                    "sigma" : 3 <1>
                }
            }
        }
    }

<1>| `sima`控制着标准差的显示范围
---|---    

`sima`可心是任意的非负的双精度类型，意味着你的可以请求一个非整型的值，如`1.5`,`0`也是有效值，只是它只会简单地返回`upper`和`lower`边界。

![Note](/images/icons/note.png)

### 标准差和边界需要一个常量 Standard Deviation and Bounds require normality

标准差和它的边界会默认进行显示，但它并不是在所有的数据集中都是可以应用的。你的数据必须进行常态的分布，标准差的统计计算假设了数据的常态分布。如果你提供的数据是轻度或者重量的偏斜，将会导致标准差产生巨大的误差。

### Script

使用脚本进行计算`grade`:
    
    
    {
        ...,
    
        "aggs" : {
            "grades_stats" : {
                "extended_stats" : {
                    "script" : {
                        "inline" : "doc['grade'].value",
                        "lang" : "painless"
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
                "extended_stats" : {
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

#### Value Script

事实证明，考试是远高于学生的水平，需要适用等级修正。 我们可以使用值脚本来获得新的数据统计：
    
    
    {
        "aggs" : {
            ...
    
            "aggs" : {
                "grades_stats" : {
                    "extended_stats" : {
                        "field" : "grade",
                        "script" : {
                            "lang" : "painless",
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

### Missing value

`missing`参数定义了如何处理缺少值的文档。 默认情况下，它们将被忽略，但也可以把它们看作是有价值的。
    
    
    {
        "aggs" : {
            "grades_stats" : {
                "extended_stats" : {
                    "field" : "grade",
                    "missing": 0 <1>
                }
            }
        }
    }

<1>|  文档中如果`grade`字段中没有值，将会默认设置`0`进行使用。
---|---