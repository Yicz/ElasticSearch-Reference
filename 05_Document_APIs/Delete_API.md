# Delete API
Delete API 允诉我们指定一个ID进行删除一个文档。

这时有一个粟子：删除了twitter索引下类型为type且ID=1的文档
```sh
$ curl -XDELETE 'http://localhost:9200/twitter/tweet/1'
# 响应结果
{
    "_shards" : {
        "total" : 10,
        "failed" : 0,
        "successful" : 10
    },
    "found" : true,
    "_index" : "twitter",
    "_type" : "tweet",
    "_id" : "1",
    "_version" : 2,
    "result": "deleted"
}
```

# 版本控制
每个文档索引都有自己的版本。当删除一个文档时,可以指定它的版本,以确保我们正在试图删除的相关文件实际上是被删除了，还是没有变化的。每一个写操作上执行文档,包括删除,导致其版本递增。

# routing
一个文档是由我们指定路由参数进行分片的时候，我们进行删除的时候也的指定相同的routing参数，否则我们将删除文档失败。
# 父关系

# 自动索引创建
当我们进行删除一个之前没有建立的索引文档的时候，elasticsearch会建立一个文档，并会动态映射它的类型。

# 分发
删除操作被散列到一个特定的分片。然后被重定向到主分片和复制分片进行删除内容。

# 刷新
`refresh`参数，会让当前执行的操作立刻可见。

# 超时
任何的操作都可能会发现网络超时的情况，我们可以设置一个超时时长，如果超过了这个时长，就说明了该操作失败。

```sh
curl -XDELETE 'http://localhost:9200/twitter/tweet/1?timeout=5m'
```


