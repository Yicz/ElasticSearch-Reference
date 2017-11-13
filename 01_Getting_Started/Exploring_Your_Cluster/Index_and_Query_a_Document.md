# 索引并查询一个文档

现在让我们把东西放入我们的客户索引。 请记住，为了索引文件，我们必须告诉Elasticsearch索引(index)中的哪一个类型(type)。

让我们将一个简单的客户文档编入索引为“external”的客户索引，ID为1，如下所示：

```sh
#使用kibana
PUT /customer/external/1?pretty
{
  "name": "John Doe"
}
```
它会响应：

```sh
{
  "_index" : "customer",
  "_type" : "external",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "created" : true
}
```

从以上可以看出，在客户索引和外部类型中成功创建了新的客户文档。 该文件也有一个我们在索引时间指定的内部ID。

请注意，Elasticsearch不需要您先创建一个索引，然后再创建一个文档。 在前面的例子中，如果事先不存在索引的话。Elasticsearch将自动创建客户索引。

现在我们来检索我们刚编入索引的那个文档：

```sh
#使用kibana
GET /customer/external/1?pretty
# 响应
{
  "_index" : "customer",
  "_type" : "external",
  "_id" : "1",
  "_version" : 1,
  "found" : true,
  "_source" : { "name": "John Doe" }
}
```
我们发现一个文档与所要求的ID 1和其他字段_source，它返回从上一步建立索引中完整的JSON文档。