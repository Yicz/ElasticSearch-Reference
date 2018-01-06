## 求和聚合 Sum Aggregation

计算文档中数据类型字段的总和的单值聚合，数据也可以使用脚本进行提供。

假设要统计销售记录中的总额，我们可以使用如下的请求：
    
    POST /sales/_search?size=0
    {
        "query" : {
            "constant_score" : {
                "filter" : {
                    "match" : { "type" : "hat" }
                }
            }
        },
        "aggs" : {
            "hat_prices" : { "sum" : { "field" : "price" } }
        }
    }

返回:
    
    {
        ...
        "aggregations": {
            "hat_prices": {
               "value": 450.0
            }
        }
    }

可以看到上述的聚合操作，将聚合的名称`intraday_return`,可以作为了响应内容中的键值进行返回和并可用于检索。

### Script

可以本用脚本统计销售总额：    
    
    POST /sales/_search?size=0
    {
        "query" : {
            "constant_score" : {
                "filter" : {
                    "match" : { "type" : "hat" }
                }
            }
        },
        "aggs" : {
            "hat_prices" : {
                "sum" : {
                    "script" : {
                       "inline": "doc.price.value"
                    }
                }
            }
        }
    }

这将使用`painless`脚本语言将`script`参数解释为`inline`脚本，并且没有脚本参数。 要使用文件脚本，请使用以下语法：

    
    
    POST /sales/_search?size=0
    {
        "query" : {
            "constant_score" : {
                "filter" : {
                    "match" : { "type" : "hat" }
                }
            }
        },
        "aggs" : {
            "hat_prices" : {
                "sum" : {
                    "script" : {
                        "file": "my_script",
                        "params" : {
                            "field" : "price"
                        }
                    }
                }
            }
        }
    }

![Tip](/images/icons/tip.png)

对于保存在`.script`索引脚本，用`id`参数替换`file`参数。

#### Value Script

在脚本中可以使用`_value`来访问字段中的值。例如，我们计算值的平方：
    
    
    POST /sales/_search?size=0
    {
        "query" : {
            "constant_score" : {
                "filter" : {
                    "match" : { "type" : "hat" }
                }
            }
        },
        "aggs" : {
            "square_hats" : {
                "sum" : {
                    "field" : "price",
                    "script" : {
                        "inline": "_value * _value"
                    }
                }
            }
        }
    }

### 缺省值 Missing value

`missing`参数定义了如何处理缺少值的文档。 默认情况下，它们将被忽略，但也可以把它们看作是有价值的。例如，下面将没有设置值的`prive`默认赋值为`100`
    
    POST /sales/_search?size=0
    {
        "query" : {
            "constant_score" : {
                "filter" : {
                    "match" : { "type" : "hat" }
                }
            }
        },
        "aggs" : {
            "hat_prices" : {
                "sum" : {
                    "field" : "price",
                    "missing": 100 <1>
                }
            }
        }
    }
