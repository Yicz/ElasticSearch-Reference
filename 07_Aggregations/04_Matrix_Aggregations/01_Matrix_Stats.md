## Matrix Stats

`matrix_stats`聚合是一个数字聚合，它计算一组文档字段的以下统计信息：

`count`| 包含在计算中的每个字段样本的数量。     
---|---    
`mean`| 每个字段的平均值。    
`variance`| 每场测量样本是如何分散的平均值。     
`skewness`| 每场测量量化均值周围的不对称分布。    
`kurtosis`| 每场测量量化分布的形状。    
`covariance`| 定量描述一个领域的变化与另一个领域相关联的矩阵。    
`correlation`| 协方差矩阵缩放到-1到1（含）的范围。 介绍字段分布之间的关系
  
下面的例子演示了使用矩阵统计来描述收入和贫困之间的关系。    
    
    {
        "aggs": {
            "matrixstats": {
                "matrix_stats": {
                    "fields": ["poverty", "income"]
                }
            }
        }
    }

聚合类型是`matrix_stats`，`fields`设置定义了用于计算统计的字段集（作为数组）。 上述请求返回以下响应：
    
    
    {
        ...
        "aggregations": {
            "matrixstats": {
                "fields": [{
                    "name": "income",
                    "count": 50,
                    "mean": 51985.1,
                    "variance": 7.383377037755103E7,
                    "skewness": 0.5595114003506483,
                    "kurtosis": 2.5692365287787124,
                    "covariance": {
                        "income": 7.383377037755103E7,
                        "poverty": -21093.65836734694
                    },
                    "correlation": {
                        "income": 1.0,
                        "poverty": -0.8352655256272504
                    }
                }, {
                    "name": "poverty",
                    "count": 50,
                    "mean": 12.732000000000001,
                    "variance": 8.637730612244896,
                    "skewness": 0.4516049811903419,
                    "kurtosis": 2.8615929677997767,
                    "covariance": {
                        "income": -21093.65836734694,
                        "poverty": 8.637730612244896
                    },
                    "correlation": {
                        "income": -0.8352655256272504,
                        "poverty": 1.0
                    }
                }]
            }
        }
    }

### 多值字段

`matrix_stats`聚合将每个文档字段视为一个独立样本。 `mode`参数控制聚合将用于数组或多值字段的数组值。 该参数可以采取下列之一：

`avg`| （默认）使用所有值的平均值。    
---|---    
`min`| 取最小值     
`max`| 取最大值    
`sum`| 取和.     
`median`| 取中间值   
  
### 缺少值

`missing`参数定义了如何处理缺少值的文档。默认情况下，它们将被忽略，但也可以把它们看作是有价值的。这是通过添加一组fieldname：value映射来指定每个字段的默认值。
    
    
    {
        "aggs": {
            "matrixstats": {
                "matrix_stats": {
                    "fields": ["poverty", "income"],
                    "missing": {"income" : 50000} <1>
                }
            }
        }
    }

<1>| 在`income`字段中没有值的文档将具有默认值“50000”。    
---|---  
  
### 脚本

这个汇总系列还不支持脚本。