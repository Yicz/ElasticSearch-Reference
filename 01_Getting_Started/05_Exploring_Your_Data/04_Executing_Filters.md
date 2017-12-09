## 执行过滤
在前面的例子中，我们忽略了返回结果中的一些细节：查询结果中的一个`_score`字段。`_score`是一个数据类型的字段，是我们查询文档匹配度的一个度量标准。分值越高，证明文档的相关度就高，分值越低，文档的相关度就越低。

但查询并不需要一直产生分值。特别当我们使用过滤（filtering）文档的时候。ES检测情景并自动优化查询执行不比较分值。

在前面介绍的[`bool`查询](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/query-dsl-bool-query.html)支持过滤（filtering）子句，允诉查询文档但不修改它的分值。举个例子,[range 查询](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/query-dsl-range-query.html)(范围查询)允诉过滤一定范围的文档，这个过滤要求数值或者日期类型的字段。

下面的例子使用了一个bools查询返回acount的balances 在2000~3000的区间。 换句话说的我们要匹配文档条件是2000<=balance<=3000:
    
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

剖析上面的请求，`bool`查询使用了`match_all`查询和`range`过滤查询，我们可以替换任何的查询语句和过滤部分。在上面的例子中，范围（range）查询更适合使用。并跟文档的相关度无关。

除此`match_all`, `match`, `bool`, 和 `range`查询外，还有大量可用的查询类型可以使用，在里我们不进行阐述，我们只要理解他们是如何进行生效的，只要掌握了他们的原理，这样才可以举一反三地学习基他的查询类型。
