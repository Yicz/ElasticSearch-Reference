## 更新API Update API

更新API允许根据提供的脚本更新文档。操作从索引获取文档（与分片之前并行执行），运行脚本（使用可选的脚本语言和参数），并返回索引结果（也允许删除或忽略操作）。 它使用版本控制来确保在“get”和“reindex”期间没有更新。

请注意，此操作仍然意味着文档的完全重新索引，它只是消除了一些网络往返，并减少了获取和索引之间的版本冲突的机会。 需要启用`_source`字段才能使用此功能。

例如，让索引一个简单的文档：    
    
    PUT test/type1/1
    {
        "counter" : 1,
        "tags" : ["red"]
    }

### 使用脚本进行更新  Scripted updates

现在，我们可以执行一个脚本来增加计数器数字：
    
    
    POST test/type1/1/_update
    {
        "script" : {
            "inline": "ctx._source.counter += params.count",
            "lang": "painless",
            "params" : {
                "count" : 4
            }
        }
    }

我们可以添加一个标签到标签列表（注意，如果标签存在，它仍然会添加它，因为它是一个列表）：    
    
    POST test/type1/1/_update
    {
        "script" : {
            "inline": "ctx._source.tags.add(params.tag)",
            "lang": "painless",
            "params" : {
                "tag" : "blue"
            }
        }
    }

除`_source`之外，通过`ctx`映射还可以使用以下变量：`_index`，`_type`，`_id`，`_version`，`_routing`，`_parent`和`_now`。

我们也可以在文档中添加一个新的字段：
    
    
    POST test/type1/1/_update
    {
        "script" : "ctx._source.new_field = \"value_of_new_field\""
    }

或删除一个字段:
    
    
    POST test/type1/1/_update
    {
           "script" : "ctx._source.remove(\"new_field\")"
    }


而且，我们甚至可以改变执行的操作。 如果`tags`字段包含`green`，则此示例将删除文档，否则它将不执行任何操作（`noop`）    
    
    POST test/type1/1/_update
    {
        "script" : {
            "inline": "if (ctx._source.tags.contains(params.tag)) { ctx.op = \"delete\" } else { ctx.op = \"none\" }",
            "lang": "painless",
            "params" : {
                "tag" : "green"
            }
        }
    }

### 用部分文件更新 Updates with a partial document

更新API还支持传递将被合并到现有文档中的部分文档（简单的递归合并，对象的内部合并，替换核心“键/值”和数组）。 例如：
    
    
    POST test/type1/1/_update
    {
        "doc" : {
            "name" : "new_name"
        }
    }

如果指定了`doc`和`script`，则`doc`被忽略。 最好的办法是将你的部分文档的字段对放在脚本本身中。

### 检测没有更新 Detecting noop updates

如果指定了`doc`，则它的值将与现有的`_source`合并。 默认情况下，不会更改任何内容的更新会检测到它们不会更改任何内容，并返回“result”：“noop”，如下所示：
    
    
    POST test/type1/1/_update
    {
        "doc" : {
            "name" : "new_name"
        }
    }

如果在发送请求之前`name`是`new_name`，那么整个更新请求将被忽略。 如果请求被忽略，响应中的`result`元素返回`noop`。
    
    
    {
       "_shards": {
            "total": 0,
            "successful": 0,
            "failed": 0
       },
       "_index": "test",
       "_type": "type1",
       "_id": "1",
       "_version": 6,
       "result": noop
    }

您可以通过设置`"detect_noop":false`来禁用此行为：    
    
    POST test/type1/1/_update
    {
        "doc" : {
            "name" : "new_name"
        },
        "detect_noop": false
    }

### Upserts

如果文档不存在，`upsert`元素的内容将作为新文档插入。 如果文档确实存在，那么脚本将被执行：

    POST test/type1/1/_update
    {
        "script" : {
            "inline": "ctx._source.counter += params.count",
            "lang": "painless",
            "params" : {
                "count" : 4
            }
        },
        "upsert" : {
            "counter" : 1
        }
    }

#### `scripted_upsert`

如果您希望脚本不管文档是否存在，都可以运行脚本 - 即脚本处理初始化文档而不是`upsert`元素 - 然后将`scripted_upsert`设置为`true`：
    
    
    POST sessions/session/dh3sgudg8gsrgl/_update
    {
        "scripted_upsert":true,
        "script" : {
            "id": "my_web_session_summariser",
            "params" : {
                "pageViewEvent" : {
                    "url":"foo.com/bar",
                    "response":404,
                    "time":"2014-01-01 12:32"
                }
            }
        },
        "upsert" : {}
    }

#### `doc_as_upsert`

不要发送部分`doc`加上`upsert`文档，将`doc_as_upsert`设置为`true`会使用`doc`的内容作为`upsert`值：
    
    POST test/type1/1/_update
    {
        "doc" : {
            "name" : "new_name"
        },
        "doc_as_upsert" : true
    }

### 参数 Parameters

更新操作支持以下查询字符串参数：

`retry_on_conflict`| 在更新的获取和索引阶段之间，另一个进程可能已经更新了同一个文档。 默认情况下，更新将会失败并出现版本冲突异常。 `retry_on_conflict`参数控制最后抛出异常之前重试更新的次数。  
---|---    
`routing`| 路由用于将更新请求路由到对的分片，并在正在更新的文档不存在时设置upsert请求的路由。 不能用于更新现有文档的路由。
`parent`| Parent用于将更新请求路由到对的分片，并在正在更新的文档不存在时为upsert请求设置父项。 不能用来更新现有文档的“父文档”。 如果指定了别名索引路由，则会覆盖父路由，并用于路由请求。     
`timeout`| 超时等待分片变为可用状态。    
`wait_for_active_shards`| 在进行更新操作之前，需要激活的分片副本的数量.  [点击查看更多详情](docs-index_.html#index-wait-for-active-shards)
`refresh`| 控制此请求所做的更改对搜索是否可见。 查看[_`?refresh`_](docs-refresh.html).     
`_source`|允许控制是否以及如何在响应中返回更新的源代码。 默认情况下，更新的源不会被返回。 查看[`source filtering`](search-request-source-filtering.html) 
`version` & `version_type`| 更新API在内部使用Elasticsearch的版本控制支持来确保文档在更新期间不会更改。 您可以使用`version`参数来指定文档只有在版本与指定版本匹配的情况下才能更新。 通过设置版本类型为`force`，您可以在更新后强制更新文档的新版本（小心使用！`force`，不保证文档没有变化）。
  
![Note](images/icons/note.png)

### The update API does not support external versioning

更新API不支持外部版本控制（版本类型`external`＆`external_gte`），因为这会导致Elasticsearch版本号与外部系统不同步。 改用[`index` API](docs-index_.html).

