## Reindex API

![Important](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/important.png)

Reindex不试图设置目标索引。它不复制源索引的设置。在运行`_reindex`操作之前，应该设置目标索引，包括设置映射、碎片计数、副本等。

`_reindex`的最基本形式只是将文档从一个索引复制到另一个索引。这将把`twitter`索引中的文档复制到`new_twitter`索引中:
    
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter"
      }
    }

它会返回这样的内容:    
    
    {
      "took" : 147,
      "timed_out": false,
      "created": 120,
      "updated": 0,
      "deleted": 0,
      "batches": 1,
      "version_conflicts": 0,
      "noops": 0,
      "retries": {
        "bulk": 0,
        "search": 0
      },
      "throttled_millis": 0,
      "requests_per_second": -1.0,
      "throttled_until_millis": 0,
      "total": 120,
      "failures" : [ ]
    }

就像[`_update_by_query`](docs-update-by-query.html)一样，`_reindex`获取源索引的快照，但它的目标必须是一个**不同的**索引，所以不太可能出现版本冲突。`dest`的元素可以配置成索引API来控制乐观并发控制。只留下`version_type`(如上)或将其设置为`internal `将导致ES索盲目地将文档转储到目标中，覆盖任何碰巧具有相同类型和id的文件:
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "version_type": "internal"
      }
    }

将`version_type`设置为`external`将导致ES从源中保存`version`，创建其没有的文档的任何文档，并更新在目标索引中有较老版本的文档，而不是源索引中的文档:
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "version_type": "external"
      }
    }

设置`op_type`为`create`将导致`_reindex`只在目标索引中创建其没有的文档。所有现有文件将导致版本冲突:
    
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "op_type": "create"
      }
    }

默认情况下，冲突中止了`_reindex`进程，但是您可以通过设置`conflicts`来运行它们:
    
    
    POST _reindex
    {
      "conflicts": "proceed",
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "op_type": "create"
      }
    }

您可以通过向`source`添加类型（type）或添加查询(query)来限制文档。下面的例子会将`kimchy`的`tweet`复制到`new_twitter`中:    
    
    POST _reindex
    {
      "source": {
        "index": "twitter",
        "type": "tweet",
        "query": {
          "term": {
            "user": "kimchy"
          }
        }
      },
      "dest": {
        "index": "new_twitter"
      }
    }

`soucre`中的`index`和`type`都可以是列表，允许您在一个请求中复制大量的源。这将从`twitter`和`blog`索引中复制`tweet`和`post`类型的文档。它包括`twitter`索引中的`post`类型，以及`blog`索引中的`tweet`类型。如果想要更具体，就需要使用`query`。它也不费力处理ID冲突。目标索引仍然有效，但是由于迭代顺序没有很好地定义，所以很难预测哪个文档能够存活。
    
    POST _reindex
    {
      "source": {
        "index": ["twitter", "blog"],
        "type": ["tweet", "post"]
      },
      "dest": {
        "index": "all_together"
      }
    }

还可以通过设置`size`来限制已处理文档的数量。这只会将`twitter`的一个文档复制到`new_twitter`:
    
    
    POST _reindex
    {
      "size": 1,
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter"
      }
    }

如果您想要从twitter索引中获得一组特定的文档，您需要进行排序。排序使滚动变得低效，但在某些情况下，它是值得的。如果可能的话，选择`size`和`sort`的更有选择性的查询。这将从`推特`复制10000个文档到`new_twitter`:
    
    
    POST _reindex
    {
      "size": 10000,
      "source": {
        "index": "twitter",
        "sort": { "date": "desc" }
      },
      "dest": {
        "index": "new_twitter"
      }
    }

`source`部分支持[search request](search-request-body.html)中支持的所有元素。例如，只有原始文档中字段的一个子集可以使用源筛选来进行索引，如下所示:
    
    POST _reindex
    {
      "source": {
        "index": "twitter",
        "_source": ["user", "tweet"]
      },
      "dest": {
        "index": "new_twitter"
      }
    }

与`update_by_query`类似，`reindex`支持修改文档的脚本。与`_update_by_query`不同，该脚本可以修改文档的元数据。本例将对源文档的版本进行修改:
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "version_type": "external"
      },
      "script": {
        "inline": "if (ctx._source.foo == 'bar') {ctx._version++; ctx._source.remove('foo')}",
        "lang": "painless"
      }
    }

正如在`_update_by_query`中，您可以设置`ctx。op`更改目的地索引处执行的操作:

`noop`

    如果你的脚本决定不需要做任何改变,可以设置`ctx.op ="noop"`。 这将导致`_update_by_query`从其更新中忽略该文档。 这个没有任何操作会在响应主体的noop计数器中报告。

`delete`

    如果您的脚本决定删除文档，请设置`ctx.op ="delete"`。 删除将在响应主体的删除计数器中报告。


将`ctx.op`设置为其他任何内容都是错误的。 在`ctx`中设置任何其他字段是一个错误。

可以修改的属性!只是小心些而已!你可以改变:

  * `_id`
  * `_type`
  * `_index`
  * `_version`
  * `_routing`
  * `_parent`


将`_version`设置为`null`或者从`ctx`映射中清除它就像不在索引请求中发送版本一样。 这会导致目标索引中的文档被覆盖，而不管目标上的版本或`_reindex`请求中使用的版本类型如何。

默认情况下，如果`_reindex`看到带有`routing`的文档，那么`routing`将被保留，除非它被脚本改变了。 你可以在`dest`请求上设置`routing`来改变这个：

`keep`
    将发送给每个匹配的批量请求的路由设置为匹配的路由。 默认。
`discard`
    将为每个匹配发送的批量请求的路由设置为空。
`=<some text>`
    将发送给每个匹配的批量请求的路由设置为`=`之后的所有文本。
    
例如，您可以使用以下请求将公司名称为cat的`source`索引中的所有文档复制到路由设置为`cat`的`dest`索引中:    
    
    POST _reindex
    {
      "source": {
        "index": "source",
        "query": {
          "match": {
            "company": "cat"
          }
        }
      },
      "dest": {
        "index": "dest",
        "routing": "=cat"
      }
    }

默认情况下`_reindex`使用滚动批量为1000.你可以用`source`元素中的`size`字段来改变批量大小：    
    
    POST _reindex
    {
      "source": {
        "index": "source",
        "size": 100
      },
      "dest": {
        "index": "dest",
        "routing": "=cat"
      }
    }

Reindex也可以通过像这样指定`pipeline'来使用[Ingest Node](ingest.html)特性：
    
    
    POST _reindex
    {
      "source": {
        "index": "source"
      },
      "dest": {
        "index": "dest",
        "pipeline": "some_ingest_pipeline"
      }
    }

### 从远程重建索引 Reindex from Remote

![Warning](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/warning.png)

来自远程的Reindex在5.4.0中是[broken](https://github.com/elastic/elasticsearch/issues/24520)，在5.4.1中是修复。

Reindex支持从远程Elasticsearch集群重建索引：    
    
    POST _reindex
    {
      "source": {
        "remote": {
          "host": "http://otherhost:9200",
          "username": "user",
          "password": "pass"
        },
        "index": "source",
        "query": {
          "match": {
            "test": "data"
          }
        }
      },
      "dest": {
        "index": "dest"
      }
    }


`host`参数必须包含`schema`，`host`和`port`（例如`https：// otherhost：9200`）。 “用户名(username)”和“密码(password)”参数是可选的，当它们出现时，reindex将使用基本身份验证连接到远程Elasticsearch节点。使用基本身份验证时一定要使用“https”，否则密码将以纯文本形式发送。

远程主机必须使用`reindex.remote.whitelist`属性在`elasticsearch.yaml`中显式列入白名单。它可以设置为允许的远程“主机”和“端口”组合的逗号分隔列表（例如`otherhost：9200，另一个：9200,127.0.10。*：9200，localhost：*`）。白名单忽略Scheme - 仅使用主机和端口。

这个功能应该适用于你可能找到的任何版本的Elasticsearch远程集群。这应该允许您从任何版本的Elasticsearch升级到当前版本，方法是从旧版本的集群中重新索引。

为了使查询发送到旧版本的Elasticsearch，`query`参数直接发送到远程主机而无需验证或修改。

从远程服务器重新编译使用默认最大大小为100MB的堆缓冲区。如果远程索引包含非常大的文档，则需要使用较小的批量。下面的例子设置了非常非常小的批量“10”。

    POST _reindex
    {
      "source": {
        "remote": {
          "host": "http://otherhost:9200"
        },
        "index": "source",
        "size": 10,
        "query": {
          "match": {
            "test": "data"
          }
        }
      },
      "dest": {
        "index": "dest"
      }
    }

也可以使用`socket_timeout`字段在远程连接上设置套接字读取超时，并使用`connect_timeout`字段设置连接超时。 两者都默认为三十秒。 此示例将套接字读取超时设置为一分钟，将连接超时设置为十秒：    
    
    POST _reindex
    {
      "source": {
        "remote": {
          "host": "http://otherhost:9200",
          "socket_timeout": "1m",
          "connect_timeout": "10s"
        },
        "index": "source",
        "query": {
          "match": {
            "test": "data"
          }
        }
      },
      "dest": {
        "index": "dest"
      }
    }

### URL Parameters

除了`pretty`这样的标准参数外，Reindex API还支持`refresh`，`wait_for_completion`，`wait_for_active_shards`和`timeout`、 `requests_per_second`.

当请求完成时，发送`refresh`将更新正在更新的索引中的所有分片。 这与Index API的`refresh`参数不同，这个参数只会导致接收到新数据的索引分片。

如果请求包含`wait_for_completion = false`，那么ES将执行一些预检查后再启动请求，然后返回可用于[Tasks APIs]的任务(docs-update-by-query.html#docs-update-by-query-task-api)用来取消或获取任务的状态。 ES也会在`.tasks/task/${taskId}`中创建这个任务的记录。由你决定它的存留。当你完成它，删除它，方便ES可以回收它使用的空间。

`wait_for_active_shards`控制一个分片的多少个副本在继续请求之前必须被激活。有关详细信息，请[查看](docs-index_.html#index-wait-for-active-shards)。 `timeout`控制每个写请求等待不可用分片变得可用的时间。两参数在[Bulk API](docs-bulk.html)中的工作方式完全相同。

`request_per_second`可以设置为任意正数（`1.4`，`6`，`1000`等），并且可以限制每秒查询次数，或者可以设置为`-1`禁用节流。节流是在批量批量之间等待，以便它可以操纵滚动超时。等待时间是批次完成所需的时间与`request_per_second * requests_in_the_batch`时间之间的时间差。由于批处理没有被分解为多个批量请求，因此大批量处理会导致Elasticsearch创建很多请求，然后等待一段时间再开始下一个批处理。这是“突发”代替“流畅”。默认是`-1`。

### 响应体 Response body

返回如下类似的JSON内容：    
    
    {
      "took" : 639,
      "updated": 0,
      "created": 123,
      "batches": 1,
      "version_conflicts": 2,
      "retries": {
        "bulk": 0,
        "search": 0
      }
      "throttled_millis": 0,
      "failures" : [ ]
    }

`took`
     整个操作从开始到结束的毫秒数。
`updated`
     成功更新的文档数。
`created`
     成功创建的文档数. 
`batches`
     通过查询更新拉回滚动响应的数量。
`version_conflicts`
     查询更新的版本冲突次数。 
`retries`
     通过查询更新尝试的重试次数。 `bulk`是重试批量操作的次数，`search`是重试的搜索操作的次数。 
`throttled_millis`
     请求以符合`requests_per_second`的毫秒数。 
`failures`
     所有索引失败的数组。 如果这是非空的，则请求由于这些故障而中止。 有关如何防止版本冲突终止操作的信息，请参阅[冲突]()。 

与任务API协作

您可以使用[任务API](tasks.html)获取所有正在运行的逐个重建索引请求的状态:

  
    
    GET _tasks?detailed=true&actions=*reindex

响应如下:
    
    
    {
      "nodes" : {
        "r1A2WoRbTwKZ516z6NEs5A" : {
          "name" : "r1A2WoR",
          "transport_address" : "127.0.0.1:9300",
          "host" : "127.0.0.1",
          "ip" : "127.0.0.1:9300",
          "attributes" : {
            "testattr" : "test",
            "portsfile" : "true"
          },
          "tasks" : {
            "r1A2WoRbTwKZ516z6NEs5A:36619" : {
              "node" : "r1A2WoRbTwKZ516z6NEs5A",
              "id" : 36619,
              "type" : "transport",
              "action" : "indices:data/write/reindex",
              "status" : {    <1>
                "total" : 6154,
                "updated" : 3500,
                "created" : 0,
                "deleted" : 0,
                "batches" : 4,
                "version_conflicts" : 0,
                "noops" : 0,
                "retries": {
                  "bulk": 0,
                  "search": 0
                },
                "throttled_millis": 0
              },
              "description" : ""
            }
          }
        }
      }
    }
    
<1>| 该对象包含实际状态。 这就像`total`字段的重要补充json的响应一样。 总数是reindex预期执行的操作总数。 您可以通过累加`updated`，`created`和`deleted`字段来估计进度。 当他们的总和等于`total`字段时，请求将完成。
---|---  
  
使用任务ID，您可以直接查找任务：    
    
    GET /_tasks/taskId:1

这个API的优点是它与`wait_for_completion = false`集成，透明地返回已完成任务的状态。 如果任务完成，并且wait_for_completion = false被设置，那么它会返回一个`results`或`error`字段。 这个特性的成本是在 `.tasks/task/${taskId}`创建`wait_for_completion = false`的文件。 删除该文件由您决定。

### 使用task API 取消任务  Works with the Cancel Task API

任何通过查询更新可以使用[任务取消API](tasks.html)取消：
    
    POST _tasks/task_id:1/_cancel

可以使用上面的任务API找到`task_id`。

取消应该很快，但可能需要几秒钟。 上面的任务状态API将继续列出任务，直到它被唤醒以取消自己。

### 重节流 Rethrottling

`request_per_second`的值可以在正在运行的更新中通过使用`_rethrottle` API进行查询来更改：    
    
    POST _update_by_query/task_id:1/_rethrottle?requests_per_second=-1

可以使用上面的任务API找到`task_id`。

就像在`_update_by_query` API上设置`request_per_second`一样，可以使用'-1'来禁用节流，或者使用'1.7'或'12'等十进制数来节流。 加快查询速度的重新生效会立即生效，但是在完成当前批次后，重新生成查询会减慢查询生效。 这可以防止滚动超时。

### 利用重建索引修改一个字段的名称 Reindex to change the name of a field

`_reindex`可以用来建立索引的一个拷贝，包含重命名的字段。 假设你创建一个包含如下所示的文档的索引：

    
    POST test/test/1?refresh
    {
      "text": "words words",
      "flag": "foo"
    }

但是你不喜欢`flag`这个名字，并且想用`tag`替换它。 `_reindex`可以为你创建另一个索引：
   
    POST _reindex
    {
      "source": {
        "index": "test"
      },
      "dest": {
        "index": "test2"
      },
      "script": {
        "source": "ctx._source.tag = ctx._source.remove(\"flag\")"
      }
    }

现在你可以等到一个新的文档类型:    
    
    GET test2/test/1

内容如下:
    
    
    {
      "found": true,
      "_id": "1",
      "_index": "test2",
      "_type": "test",
      "_version": 1,
      "_source": {
        "text": "words words",
        "tag": "foo"
      }
    }

或者你可以通过`tag`或任何你想要的搜索。

#### 手动分页  Manual slicing

Reindex 支持[切片滚动](search-request-scroll.html#sliced-scroll)，使您可以相对容易地手动并行化进程：
    
    
    POST _reindex
    {
      "source": {
        "index": "twitter",
        "slice": {
          "id": 0,
          "max": 2
        }
      },
      "dest": {
        "index": "new_twitter"
      }
    }
    POST _reindex
    {
      "source": {
        "index": "twitter",
        "slice": {
          "id": 1,
          "max": 2
        }
      },
      "dest": {
        "index": "new_twitter"
      }
    }

你可以使用如下的命令进行验证:
    
    
    GET _refresh
    POST new_twitter/_search?size=0&filter_path=hits.total

结果就像这样一个合理的`total`：    
    
    {
      "hits": {
        "total": 120
      }
    }

### 自动分片 Automatic slicing

你也可以让reindex使用[Sliced Scroll](search-request-scroll.html#sliced-scroll)自动并行分割在`_uid`上：

    
    
    POST _reindex?slices=5&refresh
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter"
      }
    }

你可以使用如下的命令进行验证:
    
    
    POST new_twitter/_search?size=0&filter_path=hits.total

结果就像这样一个合理的`total`：    
    
    
    {
      "hits": {
        "total": 120
      }
    }

在`_reindex`中添加`slices`只是自动执行上面内容中的手动过程，创建子请求，这意味着它的处理过程稍有不同：

  *您可以在[任务API](docs-update-by-query.html#docs-update-by-query-task-api)中看到这些请求。这些子请求是“切片”请求任务的“子”任务。
  *用“切片”获取请求任务的状态只包含已完成切片的状态。
  *这些子请求可单独解决，如取消和重节流（rethrottling）。
  *使用`slices`重新调整请求将按比例重新调整未完成的子请求。
  *用“切片”取消请求将取消每个子请求。
  *由于“切片”的性质，每个子请求将不会获得完全平坦的文档部分。所有的文件将被解决，但一些切片可能比其他切片大。期待更大的切片有更均匀的分布。
  *带有`slices`的请求中的`requests_per_second`和`size`参数按比例分配给每个子请求。结合上面关于分布不均匀的观点，你应该得出结论：使用带'slices'的`size`可能不会导致正确的`size`文件被`_update_by_query`ed。
  *每个子请求都会得到一个略有不同的源索引快照，尽管这些都是在大约同一时间进行的。

### 选择切片的数量 Picking the number of slices

在这一点上，我们提供了一些围绕要使用的"slices"数量的建议（如果手动并行化，则切片API中的“max”参数）：

   *不要使用大数字。 `500`创建相当庞大的CPU垃圾。
   *从查询性能角度来看，使用源索引中多个分片的数量会更有效率。
   *从查询性能的角度来看，使用与源索引完全一样多的分片是最有效的。
   *索引性能应该以可用资源与`slices`的数量成线性比例。
   *索引或查询性能在这个过程中占主要地位取决于很多因素，比如重新索引的文档和重新索引的集群。

### 重建每天的索引 Reindex daily indices

您可以将`_reindex`与[ 内置脚本语言 Painless](modules-scripting-painless.html)结合使用来重新索引每日索引以将新模板应用于现有文档。

假设您的索引包含以下文档：

    PUT metricbeat-2016.05.30/beat/1?refresh
    {"system.cpu.idle.pct": 0.908}
    PUT metricbeat-2016.05.31/beat/1?refresh
    {"system.cpu.idle.pct": 0.105}

`metricbeat-*`索引的新模板已经加载到elasticsearch中，但仅适用于新创建的索引。 `Painless`可用于重新索引现有文档并应用新模板。

下面的脚本从索引名称中提取日期，并创建一个附加了`-1`的新索引。 所有来自`metricbeat-2016.05.31`的数据将被重新索引到`metricbeat-2016.05.31-1`。

    POST _reindex
    {
      "source": {
        "index": "metricbeat-*"
      },
      "dest": {
        "index": "metricbeat"
      },
      "script": {
        "lang": "painless",
        "inline": "ctx._index = 'metricbeat-' + (ctx._index.substring('metricbeat-'.length(), ctx._index.length())) + '-1'"
      }
    }

以前的度量标准索引中的所有文档现在都可以在`*-1`索引中找到。
    
    GET metricbeat-2016.05.30-1/beat/1
    GET metricbeat-2016.05.31-1/beat/1

以前的方法也可以与[更改字段名称 change the name of a field](docs-reindex.html#docs-reindex-change-name)组合使用，只将现有数据加载到新索引中，但也可以根据需要重命名字段。

###提取一个测试索引的随机子集  Extracting a random subset of an index

Reindex可以用来提取一个测试索引的随机子集:    
    
    POST _reindex
    {
      "size": 10,
      "source": {
        "index": "twitter",
        "query": {
          "function_score" : {
            "query" : { "match_all": {} },
            "random_score" : {}
          }
        },
        "sort": "_score"    <1>
      },
      "dest": {
        "index": "random_twitter"
      }
    }
    
<1>| Reindex默认为按`_doc`排序，所以`random_score`不会有任何效果，除非你将sort值覆盖到`_score`
---|---
