## 脚本化度量聚合 Scripted Metric Aggregation

![Warning](/images/icons/warning.png)此功能是实验性的，可能会在将来的版本中完全更改或删除。 弹性将采取尽最大努力解决任何问题，但实验性功能不受支持官方GA功能的SLA。

度量聚合，使用脚本执行以提供度量输出。

举个例子:
    
    
    POST ledger/_search?size=0
    {
        "query" : {
            "match_all" : {}
        },
        "aggs": {
            "profit": {
                "scripted_metric": {
                    "init_script" : "params._agg.transactions = []",
                    "map_script" : "params._agg.transactions.add(doc.type.value == 'sale' ? doc.amount.value : -1 * doc.amount.value)", <1>
                    "combine_script" : "double profit = 0; for (t in params._agg.transactions) { profit += t } return profit",
                    "reduce_script" : "double profit = 0; for (a in params._aggs) { profit += a } return profit"
                }
            }
        }
    }

<1>| `map_script`是唯一的必要参数
---|---  
  
上面的聚合显示了如何使用脚本聚合计算销售和成本事务的总利润。

响应如下：    
    
    {
        "took": 218,
        ...
        "aggregations": {
            "profit": {
                "value": 240.0
            }
       }
    }

上面的例子也可以使用文件脚本来指定，如下所示：    
    
    POST ledger/_search?size=0
    {
        "aggs": {
            "profit": {
                "scripted_metric": {
                    "init_script" : {
                        "file": "my_init_script"
                    },
                    "map_script" : {
                        "file": "my_map_script"
                    },
                    "combine_script" : {
                        "file": "my_combine_script"
                    },
                    "params": {
                        "field": "amount", <1>
                        "_agg": {}        <2>
                    },
                    "reduce_script" : {
                        "file": "my_reduce_script"
                    }
                }
            }
        }
    }

<1>|必须在全局`params`对象中指定`init`，`map`和`combine`脚本的脚本参数，以便在脚本之间共享。  
---|---    
<2>|如果你指定脚本参数，那么你必须指定`"_agg": {}`.   
  
有关指定脚本的更多细节，请参阅 [script documentation](modules-scripting.html).

### 允许的返回类型 Allowed return types

虽然任何有效的脚本对象都可以在单个脚本中使用，但脚本必须只返回或存储`_agg`对象中的以下类型：

   * 原始类型
   * 字符串
   * Map（仅包含此处列出的类型的键和值）
   * 数组（仅包含此处列出的类型的元素）


### 脚本的范围 Scope of scripts

脚本度量聚合在其执行的4个阶段使用脚本：

#### init_script 初始化脚本
   
在收集文件之前执行。允许聚合设置任何初始状态。

在上面的例子中，init_script在_agg对象中创建了一个数组transactions。

#### map_script 映射化脚本

每个文件收集一次执行。这是唯一需要的脚本。如果没有指定combine_script，则结果状态需要存储在名为`_agg`的对象中。

在上面的例子中，`map_script`检查类型字段的值。如果值是_sale_，那么amount字段的值将被添加到transactions数组中。如果类型字段的值不是_sale_，则将金额字段的否定值添加到事务中。

#### combine_script 组合化脚本 
    
文件收集完成后，在每个碎片上执行一次。允许聚合合并从每个分片返回的状态。如果未提供combine_script，则合并阶段将返回聚合变量。

在上面的例子中，`combine_script`遍历所有存储的事务，将'profit`变量中的值相加，最后返回'profit'。

####  归化脚本 reduce_script
    
所有分片返回结果后，在协调节点上执行一次。该脚本提供了一个变量`_aggs`，它是每个分片上的combine_script的结果数组。如果没有提供reduce_script，reduce阶段将返回`_aggs`变量。

在上面的例子中，`reduce_script`循环遍历每个分片返回的'profit'，然后返回汇总响应中返回的最终合并利润。

### 工作示例 Worked Example

想象一下，将以下文档编入索引并使用2个分片的情况：    
    
    PUT /transactions/stock/_bulk?refresh
    {"index":{"_id":1} }
    {"type": "sale","amount": 80}
    {"index":{"_id":2} }
    {"type": "cost","amount": 10}
    {"index":{"_id":3} }
    {"type": "cost","amount": 30}
    {"index":{"_id":4} }
    {"type": "sale","amount": 130}

可以说，文档1和文档3在分片A上结束，文档2和4在分片B上结束。以下是上例中每个阶段聚合结果的细分。

#### Before init_script

没有指定params对象，所以使用默认的params对象：    
    
    "params" : {
        "_agg" : {}
    }

#### After init_script

在执行任何文档收集之前，在每个分片上运行一次，所以我们将在每个分片上有一个副本：

分片A
    
    
    
    "params" : {
        "_agg" : {
            "transactions" : []
        }
    }

分片B 
    
    
    
    "params" : {
        "_agg" : {
            "transactions" : []
        }
    }

#### After map_script

每个分片收集其文档，并在收集的每个文档上运行map_script：

分片A
    
    
    
    "params" : {
        "_agg" : {
            "transactions" : [ 80, -30 ]
        }
    }

分片B 
    
    
    
    "params" : {
        "_agg" : {
            "transactions" : [ -10, 130 ]
        }
    }

#### After combine_script

combine_script在文档收集完成后在每个分片上执行，并将所有事务减少为每个分片的单个利润数字（通过汇总事务数组中的值），然后传递给协调节点：

分片A
     50
分片B
     120

#### After reduce_script

reduce_script接收包含每个分片的组合脚本结果的_aggs数组：    
    
    "_aggs" : [
        50,
        120
    ]

它将对分片的响应降低到最终的总体利润数值（通过对这些值进行求和），并将其作为聚合的结果返回以产生响应：    
    
    {
        ...
    
        "aggregations": {
            "profit": {
                "value": 170
            }
       }
    }

### Other Parameters

params | 可选的。 一个对象，其内容将作为变量传递给`init_script`，`map_script`和`combine_script`。 这对于允许用户控制聚合的行为以及在脚本之间存储状态是有用的。 如果没有指定，默认等价于提供："params"：{"_agg"：{}}  
---|---  
  
### Empty Buckets

如果脚本度量聚合的父级桶不收集任何文档，则将使用“null”值从分片返回空的聚合响应。 在这种情况下，`reduce_script`的`_aggs`变量将包含`null`作为来自该分片的响应。 `reduce_script`因此应该期待并处理来自分片的`null`响应。