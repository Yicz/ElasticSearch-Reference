## 百分比聚合 Percentiles Aggregation

一个`多值`度量聚合，用于计算从汇总文档中提取的数值的一个或多个百分比。 这些值可以从文档中的特定数字字段中提取，也可以由提供的脚本生成。

百分位数显示观测值出现一定百分比的点。 例如，百分之95是大于观测值的95％的值。

百分比通常用于查找离群值。 在正态分布中，0.13和99.87百分位代表三个标准偏差。 任何超出三个标准偏差的数据通常被认为是异常的。

当检索一定范围的百分位数时，可以用它们来估计数据分布并确定数据是否偏斜，双峰等。

假设您的数据由网站加载时间组成。 平均加载时间和中间加载时间对管理员来说不是太有用。 最大值可能很有趣，但是它可能很容易被一个缓慢的反应所响应。


我们来看一下代表加载时间的百分比范围：    
    
    {
        "aggs" : {
            "load_time_outlier" : {
                "percentiles" : {
                    "field" : "load_time" <1>
                }
            }
        }
    }

<1>| `load_time` 必须是一个数字类型的字段    
---|---  
  
默认地`percentile`度量会生成`[ 1, 5, 25, 50, 75, 95, 99 ]`范围，响应如下：
    
    {
        ...
    
       "aggregations": {
          "load_time_outlier": {
             "values" : {
                "1.0": 15,
                "5.0": 20,
                "25.0": 23,
                "50.0": 25,
                "75.0": 29,
                "95.0": 60,
                "99.0": 150
             }
          }
       }
    }

正如你所看到的，聚合将返回默认范围内每个百分位的计算值。 如果我们假设响应时间是以毫秒为单位的，那么网页通常会在15-30ms内加载，但是偶尔会突然增加到60-150ms。

通常，管理员只对异常值感兴趣 - 极端百分比。 我们可以只指定我们感兴趣的百分比（要求的百分位必须是0-100之间的一个值）：
    
    
    {
        "aggs" : {
            "load_time_outlier" : {
                "percentiles" : {
                    "field" : "load_time",
                    "percents" : [95, 99, 99.9] <1>
                }
            }
        }
    }

<1>|使用`percents`参数来指定特定的百分点来计算  
---|---  
  
###  控制响应内容 Keyed Response

默认的`keyed`参数设置的是`true`,它将一个唯一的字符串键与每个桶相关联，并将范围作为字典而不是数组返回。 将`keyed`标志设置为`false`将会返回数组类型的响应：

    POST bank/account/_search?size=0
    {
        "aggs": {
            "balance_outlier": {
                "percentiles": {
                    "field": "balance",
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
                        "key": 1.0,
                        "value": 1462.8400000000001
                    },
                    {
                        "key": 5.0,
                        "value": 3591.85
                    },
                    {
                        "key": 25.0,
                        "value": 13709.333333333334
                    },
                    {
                        "key": 50.0,
                        "value": 26020.11666666667
                    },
                    {
                        "key": 75.0,
                        "value": 38139.648148148146
                    },
                    {
                        "key": 95.0,
                        "value": 47551.549999999996
                    },
                    {
                        "key": 99.0,
                        "value": 49339.16
                    }
                ]
            }
        }
    }

### 脚本 Script

百分比度量支持脚本。 例如，如果我们的加载时间以毫秒为单位，但我们希望以秒为单位计算百分位数，那么我们可以使用脚本来即时转换它们：
    
    
    {
        "aggs" : {
            "load_time_outlier" : {
                "percentiles" : {
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
                "percentiles" : {
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

对于保存在索引中的脚本可以使用`id`来替换`file`参数。

### 百分比（通常）只是近似的 Percentiles are (usually) approximate

有许多不同的算法来计算百分位数。 本地的实现只是将所有的值存储在一个有序数组中。 要找到第50个百分点，只需找到位于my_array [count(my_array)* 0.5]的值。

`Percentiles`度量所使用的算法被称为TDigest（由Ted Dunning在[使用T-Digests计算准确量子](https://github.com/tdunning/t-digest/blob/master/docs/t-digest-paper/histo.pdf）。

在使用这个度量聚合时，要记住一些指导原则：

   * 准确度与q（1-q）成正比。 这意味着极端百分点（例如99％）比不太极端的百分点（例如中位数）更准确
   * 对于一小组数值，百分位数是非常准确的（如果数据足够小，可能100％准确）。
   * 随着桶中数值的增长，算法开始接近百分位数。 这是有效的内存节省交易准确性。 准确的不准确程度很难一概而论，因为它取决于你的数据分布和被聚合的数据量
下图显示了统一分配的相对误差，具体取决于收集的数量和请求的百分比：


![/images/percentiles_error.png](/images/percentiles_error.png)

它显示了精度对于极端百分比更好。 大数值的误差减少的原因是大数定律使得价值的分布越来越一致，而t-digest树可以更好地总结它。 在更偏态的分布情况下，情况并非如此。


###  压缩 Compression

![Warning](/images/icons/warning.png)

`compression`参数是特定于当前内部百分位数的实现，并可能在将来进行修改

近似算法必须平衡内存利用率与估计精度。 这个平衡可以通过`compression`参数来控制：    
    
    {
        "aggs" : {
            "load_time_outlier" : {
                "percentiles" : {
                    "field" : "load_time",
                    "tdigest": {
                      "compression" : 200 <1>
                    }
                }
            }
        }
    }

<1>| 压缩控制内存使用情况和近似误差   
---|---  
  
TDigest算法使用大量“节点”来近似百分点 - 可用节点越多，与数据量成正比的精度（和大内存占用量）越高。 `compression`参数将最大节点数限制为`20 * compression`。

因此，通过增加压缩值，可以增加百分比的准确性，但需要花费更多的内存。 较大的压缩值也会使算法变慢，因为基础树数据结构的大小增大，导致更昂贵的操作。 默认压缩值是`100`。

一个`节点`使用大约32个字节的内存，所以在最坏的情况下（大量的数据到达排序和有序），默认设置将产生一个大约64KB的TDigest。 在实践中，数据往往更随机，TDigest将使用更少的内存。

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
            "grade_percentiles" : {
                "percentiles" : {
                    "field" : "grade",
                    "missing": 10 <1>
                }
            }
        }
    }

<1>|文档中如果`grade`字段中没有值，将会默认设置`10`进行使用。
---|---
