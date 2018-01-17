## 合查询 Compound queries

复合查询包含其他复合或叶子查询，可以将其结果与分数相结合，更改其行为或从查询切换到过滤器上下文。

本节的查询有如下的内容:


[`constant_score` query](query-dsl-constant-score-query.html)

    包含另一个查询的查询，但在过滤器上下文(filter context)中执行。 所有匹配的文件都被赋予相同的“常量”_score. 

[`bool` query](query-dsl-bool-query.html)

     用于组合多个叶子或复合查询子句的默认查询，例如`must`，`should`，`must_not`或`filter`子句。 `must`和`should`子句的分数相加 - 匹配的子句越多越好，而`must_not`和`filter`子句在过滤器上下(filter context)文中执行。

[`dis_max` query](query-dsl-dis-max-query.html)

     一个查询接受多个查询，并返回任何匹配任何查询子句的文档。 当`bool`查询结合所有匹配查询的分数时，`dis_max`查询使用单个最佳匹配查询子句的分数。

[`function_score` query](query-dsl-function-score-query.html)

    使用函数修改主查询返回的分数，以考虑流行度，新近度，距离或使用脚本实现的自定义算法等因素。

[`boosting` query](query-dsl-boosting-query.html)

     返回与查询相匹配的文档，但会降低不匹配的文档的分数。

[`indices` query](query-dsl-indices-query.html)

    对指定的索引执行一个查询，对其他索引执行另一个查询。
