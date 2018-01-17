## 词条级别查询 Term level queries

全文查询 [full text queries](full-text-queries.html) 会在查询之前对查询字符串进行分析。词条查询是查询保存在索引中的确切的词。


这些查询通常用于结构化数据，如数字，日期和枚举，而不是全文字段。 或者并在分析过程之前,它们允许您制作低级查询。

这个组中的查询有：

[`term` query](query-dsl-term-query.html)
     查找包含指定字段中指定的确切字词的文档。
[`terms` query](query-dsl-terms-query.html)
     查找包含指定字段中指定的任何一个确切字词的文档。
[`range` query](query-dsl-range-query.html)
    查找指定字段中包含指定范围内的值（日期，数字或字符串）的文档。
[`exists` query](query-dsl-exists-query.html)
     查找指定字段包含任何非空值的文档。
[`prefix` query](query-dsl-prefix-query.html)
     查找指定字段中包含以指定的确切前缀开头的词条的文档。 
[`wildcard` query](query-dsl-wildcard-query.html)
    查找指定字段中包含与指定模式匹配的术语的文档，其中模式支持单字符通配符（`？`）和多字符通配符（`*`）
[`regexp` query](query-dsl-regexp-query.html)
    查找指定字段中包含与指定的[正则表达式](query-dsl-regexp-query.html＃regexp-syntax)相匹配的术语的文档。
[`fuzzy` query](query-dsl-fuzzy-query.html)
     查找指定字段中包含与指定字词模糊相似的字词的文档。 模糊度被测量为1或2的[Levenshtein编辑距离](http://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance)。
[`type` query](query-dsl-type-query.html)
    查找指定类型的文档。
[`ids` query](query-dsl-ids-query.html)
     查找具有指定类型和ID的文档。
