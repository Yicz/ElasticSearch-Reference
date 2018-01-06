## Percentile Ranks Aggregation
一个`多值`指标聚合，用于计算从汇总文档中提取的数值上的一个或多个百分比等级。 这些值可以从文档中的特定数字字段中提取，也可以由提供的脚本生成。

![Note](/images/icons/note.png)

请参阅[百分比（通常）近似值](search-aggregations-metrics-percentile-aggregation.html#search-aggregations-metrics-percentile-aggregation-approximation) 和[Compression](search-aggregations-metrics-percentile-aggregation.html#search-aggregations-metrics-percentile-aggregation-compression)获得关于百分位排名聚集的近似和记忆使用的建议

百分等级显示观测值低于一定值的百分比。 例如，如果一个值大于或等于观测值的95％，那么它就被认为是第95百分位数。

假设您的数据由网站加载时间组成。 您可能有一项服务协议，即在15毫秒内95％的页面加载完毕，在30毫秒内完成99％的页面加载。

我们来看一下代表加载时间的百分比范围：
    
    
    {
        "aggs" : {
            "load_time_outlier" : {
                "percentile_ranks" : {
                    "field" : "load_time", <1>
                    "values" : [15, 30]
                }
            }
        }
    }

<1>| `load_time`字段必须是数字字段    
---|---  
  
类似响应如下：    
    
    {
        ...
    
       "aggregations": {
          "load_time_outlier": {
             "values" : {
                "15": 92,
                "30": 100
             }
          }
       }
    }

根据这些信息，你可以确定你正在达到99％的加载时间目标，但是没有达到95％的加载时间目标

### 控制响应内容 Keyed Response

默认的`keyed`参数设置的是`true`,它将一个唯一的字符串键与每个桶相关联，并将范围作为字典而不是数组返回。 将`keyed`标志设置为`false`将会返回数组类型的响应：

    
    
    POST bank/account/_search?size=0
    {
        "aggs": {
            "balance_outlier": {
                "percentile_ranks": {
                    "field": "balance",
                    "values": [25000, 50000],
                    "keyed": false
                }
            }
        }
    }

响应:
    
    
    {
        ...
    
        "aggregations": {
            "balance_outlier": {
                "values": [
                    {
                        "key": 25000.0,
                        "value": 48.537724935732655
                    },
                    {
                        "key": 50000.0,
                        "value": 99.85567010309278
                    }
                ]
            }
        }
    }

### Script

百分比等级度量支持脚本。 例如，如果我们的加载时间以毫秒为单位，但我们希望以秒为单位指定值，那么我们可以使用脚本即时转换它们：
    
    
    {
        "aggs" : {
            "load_time_outlier" : {
                "percentile_ranks" : {
                    "values" : [3, 5],
                    "script" : {
                        "lang": "painless",
                        "inline": "doc['load_time'].value / params.timeUnit", <1>
                        "params" : {
                            "timeUnit" : 1000   <2>
                        }
                    }
                }
            }
        }
    }

<1>| 将原来的`field`字段使用`script`参数替换，提供内容给聚合进行计算
---|---    
<2>| 脚本跟其他不同类型的脚本一样支持参数化。
  
这将使用`painless`脚本语言将`script`参数解释为`inline`脚本，并且没有脚本参数。 要使用文件脚本，请使用以下语法：
    
    {
        "aggs" : {
            "load_time_outlier" : {
                "percentile_ranks" : {
                    "values" : [3, 5],
                    "script" : {
                        "file": "my_script",
                        "params" : {
                            "timeUnit" : 1000
                        }
                    }
                }
            }
        }
    }

![Tip](/images/icons/tip.png)

对于保存在`.script`索引脚本，用`id`参数替换`file`参数。

### HDR Histogram

![Warning](/images/icons/warning.png)

此功能是实验性的，可能会在将来的版本中完全更改或删除。 弹性将采取尽最大努力解决任何问题，但实验性功能不受支持官方GA功能的SLA。

[HDR Histogram](https://github.com/HdrHistogram/HdrHistogram) （高动态范围直方图）是一个替代的实现，在计算延迟测量的百分比时可能是有用的，因为它可以比t-digest实现更快，并且具有较大的内存占用量。 这个实现维护一个固定的最坏情况百分比错误（指定为有效位数）。 这意味着如果在直方图设置为3位有效数字的情况下将数据记录为从1微秒到1小时（3600,000,000微秒）的值，则对于1毫秒和3.6秒（或更好）的值，其值将保持1微秒 ）为最大跟踪值（1小时）。
                                                              
HDR直方图可以通过在请求中指定`method`参数来使用：

    {
        "aggs" : {
            "load_time_outlier" : {
                "percentiles" : {
                    "field" : "load_time",
                    "percents" : [95, 99, 99.9],
                    "hdr": { <1>
                      "number_of_significant_value_digits" : 3 <2>
                    }
                }
            }
        }
    }
<1>| `hdr`对象表示应该使用HDR直方图来计算百分比，并且可以在对象内部指定该算法的具体设置    
---|---    
<2>| `number_of_significant_value_digits`指定了有效数字的直方图值的分值率 
  
HDRHistogram只支持正值，如果通过负值，将会出错。 如果值的范围未知，则使用HDRHistogram也不是一个好主意，因为这可能导致高内存使用率。

### 缺省值 Missing value

`missing`参数定义了如何处理缺少值的文档。 默认情况下，它们将被忽略，但也可以把它们看作是有价值的。
    
    
    {
        "aggs" : {
            "grade_ranks" : {
                "percentile_ranks" : {
                    "field" : "grade",
                    "missing": 10 <1>
                }
            }
        }
    }

<1>| 文档中如果`grade`字段中没有值，将会默认设置`10`进行使用。
---|---
