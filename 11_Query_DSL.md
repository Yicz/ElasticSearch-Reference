# 查询结构语言

Elasticsearch provides a full Query DSL based on JSON to define queries. Think of the Query DSL as an AST of queries, consisting of two types of clauses:

Leaf query clauses 
     Leaf query clauses look for a particular value in a particular field, such as the [`match`](query-dsl-match-query.html "Match Query"), [`term`](query-dsl-term-query.html "Term Query") or [`range`](query-dsl-range-query.html "Range Query") queries. These queries can be used by themselves. 
Compound query clauses 
     Compound query clauses wrap other leaf **or** compound queries and are used to combine multiple queries in a logical fashion (such as the [`bool`](query-dsl-bool-query.html "Bool Query") or [`dis_max`](query-dsl-dis-max-query.html "Dis Max Query") query), or to alter their behaviour (such as the [`constant_score`](query-dsl-constant-score-query.html "Constant Score Query") query). 

Query clauses behave differently depending on whether they are used in [query context or filter context](query-filter-context.html "Query and filter context").
