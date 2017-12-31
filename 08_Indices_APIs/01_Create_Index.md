## 创建索引 Create Index

创建索引API允许进行实例化一个索引。ES提供了多索引的支持，包含跨多个索引。

### 索引设置 Index Settings

每一个索引的创建都要指定如下的参数
    
    PUT twitter
    {
        "settings" : {
            "index" : {
                "number_of_shards" : 3, <1>
                "number_of_replicas" : 2 <2>
            }
        }
    }

<1>| `number_of_shards` 主分片的大小，默认大小`5`   
---|---    
<2>| `number_of_replicas` 默认大小`1` (即每个主分片都有一个复制分片)   
  
上述请展示了如何创建一个`titter`索引，并进行指定了设置，在上面的例子中，创建一个3个主分片和2个复制分片的索引，索引的设置可以定义为`JSON`:
    
    PUT twitter
    {
        "settings" : {
            "index" : {
                "number_of_shards" : 3,
                "number_of_replicas" : 2
            }
        }
    }

可以更加地简单：
    
    
    PUT twitter
    {
        "settings" : {
            "number_of_shards" : 3,
            "number_of_replicas" : 2
        }
    }

![Note](/images/icons/note.png)

可以不用显示地在`setting`进行指定`index`部分的内容。

更多关于创建索引时不同索引级别的设置，可以参考[`index modules`](index-modules.html)部分的内容。

### 映射关系 Mappings

创建索引API可以提供一个或者多个的映射关系:
    
    PUT test
    {
        "settings" : {
            "number_of_shards" : 1
        },
        "mappings" : {
            "type1" : {
                "properties" : {
                    "field1" : { "type" : "text" }
                }
            }
        }
    }

###  别名 Aliases

创建索引的API也可以提供一个[别名 alias ](indices-aliases.html)的集合。
    
    PUT test
    {
        "aliases" : {
            "alias_1" : {},
            "alias_2" : {
                "filter" : {
                    "term" : {"user" : "kimchy" }
                },
                "routing" : "kimchy"
            }
        }
    }

### 等待激活的人雪片 Wait For Active Shards

默认地，一个索引的请求只会返回每个分片都已经可以进行拷贝的响应内容，或者请求超时。下面是索引已经创建成功的响应内容：
    
    {
        "acknowledged": true,
        "shards_acknowledged": true
    }

`acknowledged` indicates whether the index was successfully created in the cluster, while `shards_acknowledged` indicates whether the requisite number of shard copies were started for each shard in the index before timing out. Note that it is still possible for either `acknowledged` or `shards_acknowledged` to be `false`, but the index creation was successful. These values simply indicate whether the operation completed before the timeout. If `acknowledged` is `false`, then we timed out before the cluster state was updated with the newly created index, but it probably will be created sometime soon. If `shards_acknowledged` is `false`, then we timed out before the requisite number of shards were started (by default just the primaries), even if the cluster state was successfully updated to reflect the newly created index (i.e. `acknowledged=true`).

We can change the default of only waiting for the primary shards to start through the index setting `index.write.wait_for_active_shards` (note that changing this setting will also affect the `wait_for_active_shards` value on all subsequent write operations):
    
    
    PUT test
    {
        "settings": {
            "index.write.wait_for_active_shards": "2"
        }
    }

or through the request parameter `wait_for_active_shards`:
    
    
    PUT test?wait_for_active_shards=2

A detailed explanation of `wait_for_active_shards` and its possible values can be found [here](docs-index_.html#index-wait-for-active-shards).
