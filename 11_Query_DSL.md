# 查询结构语言

ES提供了一个使用JSON定义的完整查询结构语言（Query DSL），将DSL查询看作查询的AST，由两种类型的子句组成：

叶查询子句 
     子查询子句就是一对特殊的键值对。例如：[`match`](query-dsl-match-query.html ), [`term`](query-dsl-term-query.html) or [`range`](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-range-query.html）
复合查询子句
     复合查询条款包装其他叶查询子句或复合查询和逻辑的方式用于组合多个查询(如[`bool`](query-dsl-bool-query.html)或[`dis_max`](query-dsl-dis-max-query.html)查询),或改变他们的行为(如constant_score查询)。

查询子句的行为取决于它们是在[查询上下文还是过滤器上下文(query context or filter context)](query-filter-context.html)中使用.

