# 执行过虑器
在上一节中，我们跳过了一个称为文档分数（document score）（搜索结果中的_score字段）的细节。得分是一个数字值，它是文档与我们指定的搜索查询匹配度的相对度量。分数越高，文档越相关，分数越低，文档就越不相关。

但查询并不总是需要产生分数，特别是当它们仅用于“过滤”文档集时。 Elasticsearch检测这些情况并自动优化查询执行，以便不计算无用分数。

我们在前一节介绍的[bool查询](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/query-dsl-bool-query.html)还支持***filter子句***，它允许使用查询来限制将被其他子句匹配的文档，而不改变计算得分的方式。作为一个例子，我们来介绍一下[range filter](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/query-dsl-range-query.html)，它允许我们通过一系列的值来过滤文档。这通常用于数字或日期过滤。

本示例使用bool查询返回余额在20000和30000之间的所有帐户。换句话说，我们要查找大于或等于20000且小于等于30000的帐户:

```sh
GET /bank/_search
{
  "query": {
    "bool": {
      "must": { "match_all": {} },
      "filter": {
        "range": {
          "balance": {
            "gte": 20000,
            "lte": 30000
          }
        }
      }
    }
  }
}
```

解析上述内容，bool查询包含一个match_all查询（查询部分）和一个范围查询（过滤器部分）。 我们可以将其他查询替换为查询和过滤器部分。 在上述情况中，范围查询是非常有意义的，因为落入该范围的文档全部匹配“平等”，即没有文档比另一个更相关。

除了match_all，match，bool和range查询之外，还有很多其他查询类型可用，我们不在这里介绍。 由于我们已经对其工作原理有了一个基本的了解，所以将这些知识应用于其他查询类型的学习和实验并不难。