## 内容统计聚合 Value Count Aggregation

一个 `单值`聚合，用于统计文档中字段值出现的次数，数据可以使用脚本进行提供，通常来说，这个聚合会结合其他单值类型的聚合进行使用.例如,计算文档字段中值的出现次数的平均值。
    
    
    POST /sales/_search?size=0
    {
        "aggs" : {
            "types_count" : { "value_count" : { "field" : "type" } }
        }
    }

响应内容:
    
    
    {
        ...
        "aggregations": {
            "types_count": {
                "value": 7
            }
        }
    }

聚集的名称（上面的`types_count`）也可以作为从返回的响应中检索聚合结果的键。

### Script

使用脚本进行计算：    
    
    POST /sales/_search?size=0
    {
        "aggs" : {
            "type_count" : {
                "value_count" : {
                    "script" : {
                        "inline" : "doc['type'].value"
                    }
                }
            }
        }
    }

这将使用`painless`脚本语言将`script`参数解释为`inline`脚本，并且没有脚本参数。 要使用文件脚本，请使用以下语法：
    
    
    POST /sales/_search?size=0
    {
        "aggs" : {
            "grades_count" : {
                "value_count" : {
                    "script" : {
                        "file": "my_script",
                        "params" : {
                            "field" : "type"
                        }
                    }
                }
            }
        }
    }

![Tip](/images/icons/tip.png)

对于保存在`.script`索引脚本，用`id`参数替换`file`参数。
