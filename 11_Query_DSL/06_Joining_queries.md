## 连接查询 Joining queries

在像Elasticsearch这样的分布式系统中执行完整的SQL风格的连接是代价昂贵的。 相反，Elasticsearch提供了两种连接形式，可以水平扩展。

[`nested` query](query-dsl-nested-query.html)
    
    文档可能包含[`nested`](nested.html)类型的字段。 这些字段用于索引对象数组，其中每个对象可以作为独立文档被查询（使用`嵌套`查询）。
     
[`has_child`](query-dsl-has-child-query.html) and [`has_parent`](query-dsl-has-parent-query.html) queries 

    一个索引中的两个文档类型之间可以存在[父子关系]（mapping-parent-field.html）。 `has_child`查询返回其子文档与指定查询相匹配的父文档，而`has_parent`查询返回其父文档与指定查询匹配的子文档。
    
另请参阅“terms”查询中的[terms-lookup mechanism](query-dsl-terms-query.html#query-dsl-terms-lookup)，它允许您从另一个文档构建一个`terms`查询。

