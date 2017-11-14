# 执行查询

现在我们已经看到了一些基本的搜索参数，让我们再深入查询DSL。 我们先来看看返回的文档字段。 默认情况下，完整的JSON文档作为所有搜索的一部分返回。 这被称为源（搜索匹配中的_source字段）。 如果我们不希望整个源文档返回，我们有能力只需要返回源内的几个字段。

此示例显示如何从搜索中返回两个字段account_number和balance（在_source之内）：

```sh
GET /bank/_search
{
  "query": { "match_all": {} },
  "_source": ["account_number", "balance"]
}
```

请注意，上面的例子简单地减少了_source字段。 它仍然只会返回一个名为_source的字段，但在其中只包含字段account_number和balance。

如果您尝过SQL的相关知道，则上述内容在概念上与SQL SELECT FROM字段列表有些相似。

现在我们来看看查询部分。 以前，我们已经看过如何使用match_all查询来匹配所有文档。 现在我们来介绍一个叫做匹配查询的新查询，这个查询可以被看作是基本的搜索查询（即针对特定字段或者字段集合进行的搜索）。

此示例返回编号为20的帐户：

```sh
GET /bank/_search
{
  "query": { "match": { "account_number": 20 } }
}
```
此示例返回地址中包含“mill”的所有帐户：

```sh
GET /bank/_search
{
  "query": { "match": { "address": "mill" } }
}
```
此示例返回地址中包含“mill”或“lane”的所有帐户：

```sh
GET /bank/_search
{
  "query": { "match": { "address": "mill lane" } }
}
```
此示例返回地址中包含短语“mill lane”的所有帐户：

```sh
GET /bank/_search
{
  "query": { "match_phrase": { "address": "mill lane" } }
}
```
现在我们来介绍一下bool（布尔）查询。 bool查询允许我们使用布尔逻辑将更小的查询组合成更大的查询。

此示例组成两个匹配查询，并返回地址中包含“mill”和“lane”的所有帐户：

```sh
GET /bank/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}
```
在上面的例子中，bool must子句指定了一个文档被认为是匹配的所有查询。

相反，这个例子组成两个匹配查询，并返回地址中包含“mill”或“lane”的所有帐户：

```sh
GET /bank/_search
{
  "query": {
    "bool": {
      "should": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}
```
在上面的例子中，bool should子句指定了一个查询列表，其中任何一个查询都必须是真的才能被认为是匹配的文档。

本示例组成两个匹配查询，并返回地址中既不包含“mill”也不包含“lane”的所有帐户：

```sh
GET /bank/_search
{
  "query": {
    "bool": {
      "must_not": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}
```
在上面的例子中，bool must_not子句指定了一个查询列表，其中任何一个查询都不可以被认为是匹配的。

我们可以在一个bool查询中同时结合***must，should和must_not子句***。 此外，我们可以在任何这些bool子句中编写布尔查询来模拟任何复杂的多级布尔逻辑。

这个例子返回所有40岁但不住ID（aho）的人的账号：

```sh
GET /bank/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "age": "40" } }
      ],
      "must_not": [
        { "match": { "state": "ID" } }
      ]
    }
  }
}
```