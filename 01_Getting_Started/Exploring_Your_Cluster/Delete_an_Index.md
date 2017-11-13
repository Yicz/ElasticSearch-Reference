# 删除一个文档

现在让我们删除刚刚创建的索引，然后再次列出所有索引：

```sh
# 使用kibana
DELETE /customer?pretty
GET /_cat/indices?v
# 响应
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size

```
这意味着索引已经成功删除了，现在我们回到我们在集群中没有任何东西的地方。

在我们继续之前，让我们再仔细看看迄今为止学到的一些API命令：

```sh
# 建立一个索引
PUT /customer
# 添加一个文档
PUT /customer/external/1
{
  "name": "John Doe"
}
# 获取一个索引文档
GET /customer/external/1
# 删除一个索引文档
DELETE /customer
```

如果我们仔细研究上面的命令，我们实际上可以看到我们如何在Elasticsearch中访问数据的模式。 这种模式可以概括如下：

```sh
# <REST 动词>/<索引>/<类型>/主键
<REST Verb> /<Index>/<Type>/<ID>
```

这种REST访问模式在所有的API命令中都很普遍，如果你能简单地记住它，你将在掌握Elasticsearch方面有一个良好的开端。