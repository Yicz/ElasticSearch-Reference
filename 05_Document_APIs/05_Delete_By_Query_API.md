# Delete By Query API
`_delete_by_query`是通过滤查询结果，批量地将匹配到的内容进行删除。它的用法是：

```sh
curl -XPOST 'localhost:9200/twitter/_delete_by_query?pretty' -H 'Content-Type: application/json' -d'
{
  "query": { 
    "match": {
      "message": "some message"
    }
  }
}
'
# 上面的DSL结构跟search API的格式一致，并且还可以采用url上的参数`q`来实现一样的作用。
# 返回结果
{
  "took" : 147,
  "timed_out": false,
  "deleted": 119,
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
  "total": 119,
  "failures" : [ ]
}

```

`_delete_by_query`使用的原理是采用了一个快照的模式进行了处理，当请求开始时，给索引作一个快照作为查询处理，这意味着有可能产生一个版本的冲突，因为在生成快照的同时一个delete的请求也进行了执行，这时候版本就已经发生了变化。

> 因为内部版本不支持0作为一个有效的版本号,文件版本等于零时不能使用_delete_by_query进行删除，\_delete\_by\_query请求将失败。

在`_delete_by_query`执行的时候，会发出一批有序的search请求，去查询匹配的文档，当发现匹配的文档的时候，再一个批量的delete请求，如果search或delete请求被拒绝的时候，`_delete_by_query`会根据默认的尝试策略再去请求一次（最高的重试次数是10），当达到10次的时候，`_delete_by_query `请求会终止并将失败的结果放入到响应内容`failures`中,因止`_delete_by_query `请求有可以返回一部分失败的结果。

如果你想计算版本冲突,而不是使他们中止，在url添加`conflict=process`或者在请求主体中添加`“conflict”:“process”`。

上面的栗子是删除一个索引下，能匹配的内容，我们还可以设置他只删除索引下一个文档类型的内容：

```sh
# 指定一个索引中的一个文档类型进行匹配删除
curl -XPOST 'localhost:9200/twitter/tweet/_delete_by_query?conflicts=proceed&pretty' -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_all": {}
  }
}
'
```

当还可以进行多个索引，多个文档类型内容的匹配删除：

```sh
curl -XPOST 'localhost:9200/twitter,blog/tweet,post/_delete_by_query?pretty' -H 'Content-Type: application/json' -d'
{
  "query": {
    "match_all": {}
  }
}
'

```

当我们删除曾经强制指定routing参数的索引内容的时候，我们也要指定相同的routing参数，才能将这个文档进行删除。

```sh
curl -XPOST 'localhost:9200/twitter/_delete_by_query?routing=1&pretty' -H 'Content-Type: application/json' -d'
{
  "query": {
    "range" : {
        "age" : {
           "gte" : 10
        }
    }
  }
}
'
```

`_delete_by_query` 默认设置批量的大小是1000，通过指定`scroll_size`进行修改这个大小：

```sh
curl -XPOST 'localhost:9200/twitter/_delete_by_query?scroll_size=5000&pretty' -H 'Content-Type: application/json' -d'
{
  "query": {
    "term": {
      "user": "kimchy"
    }
  }
}
'

```

### URL 参数

`_delete_by_query`还支持标准的参数`pretty`,还有`refresh`, `wait_for_completion`, `wait_for_active_shards`, and `timeout`.

`refresh`参数将刷新所有分片，区别于`delete` api 中只会刷新修改过内容的分片。

`wait_for_completion=false`参数会让请求直接回返一个task_id(任务的id),可以通过[Task API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-delete-by-query.html#docs-delete-by-query-task-api)去取消或者查看这个任务的状态。ElasticSearch会在`.tasks/task/${taskId}`建立一个文档。你可以根据你的喜好进行删除它，当然为了节省磁盘空间，最好选择是删除它。

`wait_for_active_shards`要求它在至少存在多少个活跃的分片才进行处理请求。[查看详情](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-index_.html#index-wait-for-active-shards)

`timeout`设置请求的至多等待时间。

**`缺少部分`**


