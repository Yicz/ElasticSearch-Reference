# 介绍查询语言

Elasticsearch提供了一种可用于执行查询的JSON式特定领域的语言（domain-specific language)。这被称为查询DSL。 查询语言非常全面，可以乍一看吓人，但实际学习的最好方法是从几个基本的例子开始。

回到我们的最后一个例子，我们执行了这个查询：

```sh
# 使用kibana
GET /bank/_search
{
  "query": { "match_all": {} }
}
```
解析上述内容，查询部分告诉我们我们的查询定义是什么，match_all部分只是我们想要运行的查询的类型。 match_all查询只是搜索指定索引中的所有文档。

除查询参数外，我们还可以传递其他参数来操作搜索结果。 在前面的例子中我们通过排序，在这里我们传递的大小：

```sh 
curl -XGET 'localhost:9200/bank/_search?pretty' -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ]
}
'
```

如果没有设置size参数，那么返回的结果大小默认是10.

下面的粟子，举例了match_all（匹配全部)并返回第11-20的结果数据：

```sh
GET /bank/_search
{
    "query":{"match_all":{}},
    "from":10,
    "size":20
}
```

from参数指定从哪个文档索引开始，size参数指定从from参数开始返回多少个文档。 在实现分页搜索结果时，此功能非常有用。 请注意，如果from不指定，则默认为0。

此示例执行match_all并按帐户余额按降序对结果进行排序，并返回前10个（默认大小）文档。

```sh
GET /bank/_search
{
    "query":{"match_all":{}},
    "sort":{"balance":{"order":"desc"}}
}
```