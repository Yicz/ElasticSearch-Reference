# 批处理
除了能够索引，更新和删除单个文档外，Elasticsearch还提供了使用[_bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-bulk.html)批量执行上述任何操作的功能。 这个功能非常重要，因为它提供了一个非常有效的机制，尽可能快地完成多个操作，尽可能少的网络往返。

作为一个简单的例子，下面的调用在一个批量操作中索引两个文档（ID 1 - John Doe和ID 2 - Jane Doe）：

```sh
POST /customer/external/_bulk?pretty
{"index":{"_id":"1"}}
{"name": "John Doe" }
{"index":{"_id":"2"}}
{"name": "Jane Doe" }
```
本示例更新第一个文档（ID为1），然后在一个批量操作中删除第二个文档（ID为2）：

```sh
POST /customer/external/_bulk?pretty
{"update":{"_id":"1"}}
{"doc": { "name": "John Doe becomes Jane Doe" } }
{"delete":{"_id":"2"}}
```

请注意，对于删除操作，并没有真实删除对应的源文档，因为删除操作只需要对删除文档的进行标识。

***批量API不会因其中一个操作失败而失败***。 如果一个动作因任何原因失败，它将继续处理其余的动作。 批量API返回时，它将为每个操作提供一个状态（与发送的顺序相同），以便您可以检查特定操作是否失败。