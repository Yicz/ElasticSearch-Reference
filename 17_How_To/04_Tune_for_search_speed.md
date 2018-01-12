##  查询速度直言 Tune for search speed

###  给内存到文件系统缓存 Give memory to the filesystem cache

Elasticsearch严重依赖文件系统缓存来快速搜索。 一般来说，您应该确保至少有一半的可用内存进入文件系统缓存，以便elasticsearch可以将索引的热区域保留在物理内存中。

### 使用更快的硬件 Use faster hardware

如果您的搜索是I/O限制，您应该调查给文件系统缓存更多的内存（见上文）或购买更快的硬盘。 特别是SSD驱动器比旋转磁盘执行得更好。 使用本地存储，应避免远程文件系统，如NFS或SMB。 还要小心虚拟化存储，比如亚马逊的“Elastic Block Storage”。 虚拟化存储在Elasticsearch上运行得非常好，因为它的设置非常快速和简单，所以它非常吸引人，但是与专用的本地存储相比，虚拟化存储在本质上也是很慢的。 如果您在`EBS`上放置了一个索引，一定要使用预配置的IOPS，否则操作可能会被迅速遏制。

如果您的搜索是CPU限制，您应该调查购买更快的CPU。

### 文档模型化 Document modeling

文件应该建模，以便搜索时间操作尽可能快。

特别是应该避免加入连接（avoid）。 [`nested`](nested.html)可以使查询慢几倍，[parent-child](mapping-parent-field.html)关系可以使查询速度降低数百倍。 因此，如果相同的问题可以通过非规范化文件来加以解答，那么可以预期显着的加速。

### 预索引数据 Pre-index data

您应该利用查询中的模式来优化数据编制索引的方式。 例如，如果您的所有文档都有`price`字段，并且大多数查询在范围的固定列表上运行[`range`](search-aggregations-bucket-range-aggregation.html)聚合，则可以更快地进行聚合 将范围预先索引到索引中并使用[`terms`](search-aggregations-bucket-terms-aggregation.html)聚合。

例如,如果文档结构如下：
    
    PUT index/type/1
    {
      "designation": "spoon",
      "price": 13
    }

查询请求如下:
    
    
    GET index/_search
    {
      "aggs": {
        "price_ranges": {
          "range": {
            "field": "price",
            "ranges": [
              { "to": 10 },
              { "from": 10, "to": 100 },
              { "from": 100 }
            ]
          }
        }
      }
    }

然后，文档可以通过索引时的新建一个新`price_range`字段用户保存数据，它应该被映射为[`keyword`](keyword.html)数据类型：
    
    PUT index
    {
      "mappings": {
        "type": {
          "properties": {
            "price_range": {
              "type": "keyword"
            }
          }
        }
      }
    }
    
    PUT index/type/1
    {
      "designation": "spoon",
      "price": 13,
      "price_range": "10-100"
    }

然后，搜索请求可以聚合这个新字段，而不是在`price`字段上运行`range`聚合。    
    
    GET index/_search
    {
      "aggs": {
        "price_ranges": {
          "terms": {
            "field": "price_range"
          }
        }
      }
    }

### 映射关系 Mappings

一些数据是数字的事实并不意味着它应该总是被映射为[数字字段 numberic field](number.html)。 通常情况下，存储标识符（如“ISBN”）的字段或者标识来自另一个数据库的记录的任何数字可能会被映射为[`keyword`](keyword.html)而不是`integer`或`long`。

### 避免使用脚本 Avoid scripts

一般来说，脚本应该避免。 如果他们绝对需要，你应该有限使用`painless`和`expressions`引擎。

### 查询大概日期 Search rounded dates

使用`now`的日期字段的查询通常是不可缓存的，因为匹配的范围始终在变化。 不过，就用户体验而言，切换到四舍五入的日期通常是可以接受的，并且可以更好地使用查询缓存。

例如下面的查询：
   
    PUT index/type/1
    {
      "my_date": "2016-05-11T16:30:55.328Z"
    }
    
    GET index/_search
    {
      "query": {
        "constant_score": {
          "filter": {
            "range": {
              "my_date": {
                "gte": "now-1h",
                "lte": "now"
              }
            }
          }
        }
      }
    }

可以使用如下的请求代替:
    
    
    GET index/_search
    {
      "query": {
        "constant_score": {
          "filter": {
            "range": {
              "my_date": {
                "gte": "now-1h/m",
                "lte": "now/m"
              }
            }
          }
        }
      }
    }

在这种情况下，我们四舍五入到了分钟，所以如果当前时间是`16：31：29`，则范围查询将会匹配所有`my_date`字段在`15：31：00`和`16：31：59`。 如果多个用户在同一分钟内运行包含这个范围的查询，查询缓存可以帮助加快速度。 用于四舍五入的时间间隔越长，查询缓存可以提供的帮助就越多，但要注意过于积极的舍入也可能会伤害用户体验。

![Note](/images/icons/note.png)

为了能够利用查询缓存，可能很容易将范围分割成大的可缓存部分和更小的不可缓存的部分，如下所示：

    GET index/_search
    {
      "query": {
        "constant_score": {
          "filter": {
            "bool": {
              "should": [
                {
                  "range": {
                    "my_date": {
                      "gte": "now-1h",
                      "lte": "now-1h/m"
                    }
                  }
                },
                {
                  "range": {
                    "my_date": {
                      "gt": "now-1h/m",
                      "lt": "now/m"
                    }
                  }
                },
                {
                  "range": {
                    "my_date": {
                      "gte": "now/m",
                      "lte": "now"
                    }
                  }
                }
              ]
            }
          }
        }
      }
    }

然而，这种做法可能会使查询在某些情况下运行速度变慢，因为`bool`查询引入的开销可能会因更好地利用查询缓存而失败。

### 强制合并只读索引 Force-merge read-only indices

只读的索引将受益于[合并到单个段](indices-forcemerge.html)。 基于时间的索引通常就是这种情况：只有当前时间索引是获取新文档，而旧索引是只读索引。

![Important](/images/icons/important.png)

不要强制合并仍在写入的索引 - 让它到后台合并进程进行处理。

###  全部基数预热 Warm up global ordinals

全局序号是一个数据结构，用于在[`keyword`](keyword.html)字段上运行[`terms`](search-aggregations-bucket-terms-aggregation.html)聚合。 由于elasticsearch不知道哪些字段将被用于`terms`聚合中，哪些字段不会使用，所以它们在内存中会懒加载。 你可以通过下面的描述来告诉elasticsearch通过配置映射来在刷新的时候加载全局的序列：
    
    PUT index
    {
      "mappings": {
        "type": {
          "properties": {
            "foo": {
              "type": "keyword",
              "eager_global_ordinals": true
            }
          }
        }
      }
    }

### 文件系统缓存 Warm up the filesystem cache

如果运行elasticsearch的机器重新启动，文件系统缓存将为空，所以操作系统将索引的热区域加载到内存中需要一些时间，以便搜索操作很快。 您可以使用[`index.store.preload`](index-modules-store.html＃file-system)设置根据文件扩展名明确告诉操作系统哪些文件应该被加载到内存中。

![Warning](/images/icons/warning.png)
如果文件系统缓存不够大，无法容纳所有数据，那么将数据快速加载到文件系统缓存中的索引太多或文件太多将会搜索变慢。 谨慎使用。
