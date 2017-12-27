## 查询更新API Update By Query API

`_update_by_query`最简单有效的用法是通过查询更新匹配的每一个文档的数据没有修改源。对[新增一个属性pick up a new property](docs-update-by-query.html#picking-up-a-new-property)或在线修改映射关系，非常有用，这是一个demo:
    
    POST twitter/_update_by_query?conflicts=proceed

会返回类似如下的内容:
    
    {
      "took" : 147,
      "timed_out": false,
      "updated": 120,
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

`_update_by_query` 发出请求的时候会得到一个使用ES内部版本控制的索引快照。这就意味着，请求在快照上进行处理的时候，可以会与实时索引之间产生版本冲突。当版本不冲突的时候，文档进行更新并会增加版本号（+1）。

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

内部版本控制并不支持使用0作为一个有效的版本号。文档使用了0作版本号的，并不能使用使用`_update_by_query`,如果使用了，请求会失败。

所有更新和查询失败都会导致`_update_by_query`中止，并在响应失败时返回。 已执行的更新保持不变。 换句话说，过程不回滚，只能中止。 当第一个失败导致中止时，由失败的批量请求返回的所有失败都返回到失败元素; 因此可能有相当多的失败实体。

如果想统计因为版本冲突而导致的中断，你可以设置`conflicts=proceed`查询字符串，或者在请求体中添加`"conflicts":proceed`,上面的例子就做了相应的配置，因为它只是试图获取一个在线映射的变化，而版本冲突只是意味着冲突的文档在`_update_by_query`的开始和尝试更新文档的时间之间被更新了。 这很好，因为这个更新会提取在线映射更新。

回到API格式，您可以将`_update_by_query`限制为单一类型。 这只会更新`twitter`索引中的`tweet`文件：    
    
    POST twitter/tweet/_update_by_query?conflicts=proceed

您还可以使用[Query DSL](query-dsl.html)来限制`_update_by_query`。 这将更新索引中的所有用户`kimchy`的`twitter`文档：
    
    
    POST twitter/_update_by_query?conflicts=proceed
    {
      "query": {   <1>
        "term": {
          "user": "kimchy"
        }
      }
    }


<1>| 查询必须以与[Search API](search-search.html)相同的方式作为值传递给`query`键。 您也可以像搜索api一样使用`q`参数。    


到目前为止，我们只是在不更改源文件的情况下更新文档。 这对于[新增的属性](docs-update-by-query.html#picking-up-a-new-property)这样的东西是真正有用的，但它只是一半的乐趣。 `_update_by_query`支持`脚本(script)`对象来更新文档。 这将增加所有kimchy的tweets上的`likes`字段：    
    
    POST twitter/_update_by_query
    {
      "script": {
        "inline": "ctx._source.likes++",
        "lang": "painless"
      },
      "query": {
        "term": {
          "user": "kimchy"
        }
      }
    }

就像[更新API](docs-update.html)一样，您可以设置`ctx.op`来更改执行的操作：

`noop`

    如果你的脚本决定不需要做任何改变,可以设置`ctx.op ="noop"`。 这将导致`_update_by_query`从其更新中忽略该文档。 这个没有任何操作会在响应主体的noop计数器中报告。

`delete`

    如果您的脚本决定删除文档，请设置`ctx.op ="delete"`。 删除将在响应主体的删除计数器中报告。

将`ctx.op`设置为其他任何内容都是错误的。 在`ctx`中设置任何其他字段是一个错误。

请注意，我们停止指定`conflicts=proceed`。 在这种情况下，我们想要一个版本冲突来中止这个过程，所以我们可以处理这个失败。

这个API不允许你移动它接触到的文档，只是修改它的源代码。 这是特意设置的！ 我们没有设计将文档从原始位置删除。

也可以一次完成多个索引和多个类型的请求，就像搜索API一样：    
    
    POST twitter,blog/tweet,post/_update_by_query

如果你提供了`routing`，那么路由被复制到滚动查询中，将进程限制在匹配路由值的分片上：    
    
    POST twitter/_update_by_query?routing=1

默认情况下，`_update_by_query`使用滚动批量为1000.您可以使用`scroll_size` URL参数更改批量大小：    
    
    POST twitter/_update_by_query?scroll_size=100

`_update_by_query`也可以使用[摄取结节 Ingest Node](ingest.html)特性，通过指定一个`pipeline`如下：
    
    
    PUT _ingest/pipeline/set-foo
    {
      "description" : "sets foo",
      "processors" : [ {
          "set" : {
            "field": "foo",
            "value": "bar"
          }
      } ]
    }
    POST twitter/_update_by_query?pipeline=set-foo

### URL参数 URL Parameters

除了`pretty`这样的标准参数外，Update By Query API还支持`refresh`，`wait_for_completion`，`wait_for_active_shards`和`timeout`。

当请求完成时，发送`refresh`将更新正在更新的索引中的所有分片。 这与Index API的`refresh`参数不同，这个参数只会导致接收到新数据的索引分片。

如果请求包含`wait_for_completion = false`，那么ES将执行一些预检查后再启动请求，然后返回可用于[Tasks APIs]的任务(docs-update-by-query.html#docs-update-by-query-task-api)用来取消或获取任务的状态。 ES也会在`.tasks/task/${taskId}`中创建这个任务的记录。由你决定它的存留。当你完成它，删除它，方便ES可以回收它使用的空间。

`wait_for_active_shards`控制一个分片的多少个副本在继续请求之前必须被激活。有关详细信息，请[查看](docs-index_.html#index-wait-for-active-shards)。 `timeout`控制每个写请求等待不可用分片变得可用的时间。两参数在[Bulk API](docs-bulk.html)中的工作方式完全相同。

`request_per_second`可以设置为任意正数（`1.4`，`6`，`1000`等），并且可以限制每秒查询次数，或者可以设置为`-1`禁用节流。节流是在批量批量之间等待，以便它可以操纵滚动超时。等待时间是批次完成所需的时间与`request_per_second * requests_in_the_batch`时间之间的时间差。由于批处理没有被分解为多个批量请求，因此大批量处理会导致Elasticsearch创建很多请求，然后等待一段时间再开始下一个批处理。这是“突发”代替“流畅”。默认是`-1`。

### 响应内容 Response body

返回如下类似的JSON内容:
    
    {
      "took" : 639,
      "updated": 0,
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


### 与任务API协作


您可以使用[任务API](tasks.html)获取所有正在运行的逐个查询请求的状态:
    
    
    GET _tasks?detailed=true&actions=*byquery

返回如下类似的JSON内容：    
    
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
              "action" : "indices:data/write/update/byquery",
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
                }
                "throttled_millis": 0
              },
              "description" : ""
            }
          }
        }
      }
    }


<1>| 该对象包含实际状态。 这就像"total”字段的重要补充json的响应一样。 总数是reindex预期执行的操作总数。 您可以通过添加"updated"，"created"和"deleted"字段来估计进度。 当他们的总和等于'total'字段时，请求将完成。


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

#### 手动分页 Manual slicing 

Update-by-query 支持[切片滚动](search-request-scroll.html#sliced-scroll)，使您可以相对容易地手动并行化进程：
    
    
    POST twitter/_update_by_query
    {
      "slice": {
        "id": 0,
        "max": 2
      },
      "script": {
        "inline": "ctx._source['extra'] = 'test'"
      }
    }
    POST twitter/_update_by_query
    {
      "slice": {
        "id": 1,
        "max": 2
      },
      "script": {
        "inline": "ctx._source['extra'] = 'test'"
      }
    }

你也可以验证效果：    
    
    
    GET _refresh
    POST twitter/_search?size=0&q=extra:test&filter_path=hits.total

结果就像这样一个合理的`total`：    
    
    
    {
      "hits": {
        "total": 120
      }
    }

### 自动分片 Automatic slicing

你也可以让_update_by_query使用[Sliced Scroll](search-request-scroll.html#sliced-scroll)自动并行分割在`_uid`上：

    
    POST twitter/_update_by_query?refresh&slices=5
    {
      "script": {
        "inline": "ctx._source['extra'] = 'test'"
      }
    }

你也可以验证效果：    
    
    POST twitter/_search?size=0&q=extra:test&filter_path=hits.total

结果就像这样一个合理的`total`：    
    
    {
      "hits": {
        "total": 120
      }
    }


在`_update_by_query`中添加`slices`只是自动执行上面内容中的手动过程，创建子请求，这意味着它的处理过程稍有不同：


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
   *索引性能应该以可用资源与“切片”的数量成线性比例。
   *索引或查询性能在这个过程中占主要地位取决于很多因素，比如重新索引的文档和重新索引的集群。

### 设置一个新的属性 Pick up a new property

假设您创建了一个没有动态映射的索引，并填充了数据，然后添加了一个映射值来从数据中获取更多的字段：    
    
    PUT test
    {
      "mappings": {
        "test": {
          "dynamic": false,   <1>
          "properties": {
            "text": {"type": "text"}
          }
        }
      }
    }
    
    POST test/test?refresh
    {
      "text": "words words",
      "flag": "bar"
    }
    POST test/test?refresh
    {
      "text": "words words",
      "flag": "foo"
    }
    PUT test/_mapping/test   <2>
    {
      "properties": {
        "text": {"type": "text"},
        "flag": {"type": "text", "analyzer": "keyword"}
      }
    }


<1>| 这意味着新字段不会被索引，只是存储在`_source`中。    
---|---    
<2>| 这会更新映射以添加新的“flag”字段。 要拿起新的领域，你必须重新索引所有的文件。


搜索数据将找不到任何内容：
    
    
    POST test/_search?filter_path=hits.total
    {
      "query": {
        "match": {
          "flag": "foo"
        }
      }
    }
    
    
    {
      "hits" : {
        "total" : 0
      }
    }

但是你可以发出一个`_update_by_query`请求来获取新的映射：    
    
    POST test/_update_by_query?refresh&conflicts=proceed
    POST test/_search?filter_path=hits.total
    {
      "query": {
        "match": {
          "flag": "foo"
        }
      }
    }
    
    
    {
      "hits" : {
        "total" : 1
      }
    }

将字段添加到多字段时，可以做同样的事情。
