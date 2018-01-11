## 全文查询 Full text queries


高级别全文查询通常用于在全文本字段（如电子邮件正文）上运行全文查询。他们了解被查询的字段是如何分析的（analysis.html），并在执行之前将每个字段的“分析器”（或“search_analyzer”）应用于查询字符串。


本部分的的涉及如下内容

[`match` query](query-dsl-match-query.html)

     执行全文查询的标准查询，包括模糊匹配和短语或近似查询。
[`match_phrase` query](query-dsl-match-query-phrase.html)

     与`匹配`查询类似，但用于匹配精确短语或单词近似匹配。
[`match_phrase_prefix` query](query-dsl-match-query-phrase-prefix.html)
    
     就像`match_phrase`查询一样，但对最后一个单词进行通配符搜索。
[`multi_match` query](query-dsl-multi-match-query.html)

     [`match` query]的多字段版本
[`common_terms` query](query-dsl-common-terms-query.html)

     一个更专门的查询，让更多的选择不常见的单词。 
[`query_string` query](query-dsl-query-string-query.html)

     支持复杂的Lucene 语法[query string syntax](query-dsl-query-string-query.html#query-string-syntax), 允许您在单个查询字符串中指定AND | OR | NOT条件和多字段搜索。 仅供专家用户使用。
[`simple_query_string`](query-dsl-simple-query-string-query.html)

     适用于直接向用户公开的`query_string`语法的更简单，更健壮的版本。
