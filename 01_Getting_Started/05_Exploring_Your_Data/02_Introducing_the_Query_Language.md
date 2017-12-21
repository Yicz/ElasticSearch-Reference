## 介绍查询语句

ES提供了JSON风格的领域查询语言用来执行查询。参考[Query DSL](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/query-dsl.html)。第一眼看到查询语言的时候，可能会觉得过于庞大和吓人，但拥有一个好的方法即通过样例，可以快速学习并掌握它。

回到我们上一个例子并执行它：
    
    
    GET /bank/_search
    {
      "query": { "match_all": {} }
    }

剖析上面, `query` 查询的定义 ， `match_all` 是一种简单的查询类型. `match_all` 是简单地查询所有指定索引的所有文档。

除了`query`参数，我们还可以使用其他参数来影响查询结果，例如前面例子的`sort`,下面的`size`:    
    
    GET /bank/_search
    {
      "query": { "match_all": {} },
      "size": 1
    }

提示：如果没有指定`size`大小，默认的数值是10.

下面的例子是返回文档的第11到20条数据：    
    
    GET /bank/_search
    {
      "query": { "match_all": {} },
      "from": 10,
      "size": 10
    }

`from`参数指定了返回文档结果的的位置从哪里开始，结合`size`参数形成的效果是从结果from位置开始取size个数的文档。这个特性非常适合用于分页。

提示：如果没有指定`from`，系统默认值是0.

下面的例子，匹配全部的文档并按照account balance进行倒序排序，默认返回10条文档。
    
    GET /bank/_search
    {
      "query": { "match_all": {} },
      "sort": { "balance": { "order": "desc" } }
    }
