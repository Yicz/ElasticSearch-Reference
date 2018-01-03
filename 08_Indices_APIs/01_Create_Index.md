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

`acknowledged`指示索引是否在群集中成功创建，而`shards_acknowledged`指示是否在超时之前为索引中的每个分片启动了必要的分片副本数。 请注意，`acknowledged`或`shards_acknowledged`仍然可能是`false`，但索引创建是成功的。 这些值只是**表示操作是否在超时之前完成**。 如果`acknowledged`是`false`，表示在新创建的索引更新集群状态之前，我们超时了，但可能很快就会创建。 如果`shards_acknowledged`是`false`，那么是集群状态已经成功更新反映新创建的索引（即`acknowledge = true`），但在我们在激活所需数量的分片之前超时了（默认情况下只是主分片的数量））。

我们可以通过索引设置`index.write.wait_for_active_shards`来改变只等待主分片的默认值（注意改变这个设置也会影响所有后续写操作的wait_for_active_shards值）：

    PUT test
    {
        "settings": {
            "index.write.wait_for_active_shards": "2"
        }
    }

或者通过设置请求参数 `wait_for_active_shards`:
    
    
    PUT test?wait_for_active_shards=2

有关`wait_for_active_shards`及其可能值的详细解释可以在[这里]((docs-index_.html#index-wait-for-active-shards))找到。
