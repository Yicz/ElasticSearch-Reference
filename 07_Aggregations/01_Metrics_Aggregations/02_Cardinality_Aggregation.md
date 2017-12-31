## 基数聚合 Cardinality Aggregation

计算不同值的近似计数的`单值(single-value)`度量值聚合。 值可以从文档的特定字段中提取，也可以由脚本生成。

假设您正在索引书籍，并希望统计与查询匹配的唯一作者：
    
    
    {
        "aggs" : {
            "author_count" : {
                "cardinality" : {
                    "field" : "author"
                }
            }
        }
    }

### 精度控制 Precision control

这个聚合还支持`precision_threshold`选项：

![Warning](/images/icons/warning.png)
`precision_threshold`选项特定于`cardinality` agg的当前内部实现，这在未来可能会改变
    
    {
        "aggs" : {
            "author_count" : {
                "cardinality" : {
                    "field" : "author_hash",
                    "precision_threshold": 100 <1>
                }
            }
        }
    }

<1>|`precision_threshold`选项允许交易内存的准确性，并定义一个独特的计数低于哪个计数预计接近准确。 超过这个值，计数可能会变得更加模糊。 支持的最大值是40000，高于此值的阈值与阈值40000的效果相同。默认值为“3000”。   
---|---  
  
### 计数是近似的 Counts are approximate

计算确切的计数需要将值加载到散列集并返回其大小。当处理高基数集和或大值作为所需内存使用量时，这并不会扩展，并且需要在节点之间传达这些每个分片集会利用集群的太多资源。

这个“基数”聚合基于[HyperLogLog ++](http://static.googleusercontent.com/media/research.google.com/fr//pubs/archive/40671.pdf)算法，该算法基于哈希值的一些有趣的属性：

   * 可配置的精度，决定如何交易内存的准确性，
   * 低基数集上的出色的准确性，
   * 固定的内存使用情况：不管是否有数十或数十亿的唯一值，内存使用率仅取决于配置的精度。

对于`c`的精度阈值，我们正在使用的实现需要大约`c * 8`个字节。

下图显示了错误在阈值之前和之后的变化情况：
![/images/cardinality_error.png](images/cardinality_error.png)

对于所有3个阈值，计数已准确到达配置的阈值（尽管不能保证，这可能是这种情况）。 另请注意，即使阈值低至100，即使计算数百万个项目，错误仍然很低。

### 预先计算散列 Pre-computed hashes

在基数高的字符串字段上，将字段值的散列存储在索引中，然后在此字段上运行基数聚合可能会更快。 这可以通过提供来自客户端的散列值或通过使用[`mapper-murmur3`](https://www.elastic.co/guide/en/elasticsearch/plugins/5.4/mapper-murmur3.html) 插件。


![Note](/images/icons/note.png)

预计算散列通常只在非常大或高基数字段上有用，因为它可以节省CPU和内存。但是，在数字字段中，散列速度非常快，存储原始值需要的内存多于或少于存储散列的内存。对于低基数字符串字段也是如此，尤其是考虑到这些优化是为了确保每个段的每个唯一值至多计算一次散列。

### Script

The `cardinality` metric supports scripting, with a noticeable performance hit however since hashes need to be computed on the fly.
    
    
    {
        "aggs" : {
            "author_count" : {
                "cardinality" : {
                    "script": {
                        "lang": "painless",
                        "inline": "doc['author.first_name'].value + ' ' + doc['author.last_name'].value"
                    }
                }
            }
        }
    }

这将使用`painless`脚本语言将`script`参数解释为`inline`脚本，并且没有脚本参数。 要使用文件脚本，请使用以下语法：
    
    
    {
        "aggs" : {
            "author_count" : {
                "cardinality" : {
                    "script" : {
                        "file": "my_script",
                        "params": {
                            "first_name_field": "author.first_name",
                            "last_name_field": "author.last_name"
                        }
                    }
                }
            }
        }
    }

![Tip](/images/icons/tip.png)

对于保存在`.script`索引脚本，用`id`参数替换`file`参数。

### Missing value

“missing”参数定义了如何处理缺少值的文档。 默认情况下，它们将被忽略，但也可以把它们看作是有价值的。
    
    
    {
        "aggs" : {
            "tag_cardinality" : {
                "cardinality" : {
                    "field" : "tag",
                    "missing": "N/A" <1>
                }
            }
        }
    }

<1>| 在“tag”字段中没有值的文档将与具有值“N / A”的文档属于同一个存储桶。
---|---
