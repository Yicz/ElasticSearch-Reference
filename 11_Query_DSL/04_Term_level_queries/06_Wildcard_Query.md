## 通配符查询 Wildcard Query

匹配具有与通配符表达式匹配的字段的文档（**未分析**）。 支持的通配符是`*`，匹配任何字符序列（包括空字符）和匹配任何单个字符的`？`。 请注意，这个查询可能很慢，因为它需要迭代许多词条。 为了防止极其缓慢的通配符查询，通配符词条不应该以通配符“*”或“？”之一开头。 通配符查询映射到Lucene`WildcardQuery`。

    GET /_search
    {
        "query": {
            "wildcard" : { "user" : "ki*y" }
        }
    }

可以给查询指定一个提升因子:
    
    
    GET /_search
    {
        "query": {
            "wildcard" : { "user" : { "value" : "ki*y", "boost" : 2.0 } }
        }
    }

或 :
    
    
    GET /_search
    {
        "query": {
            "wildcard" : { "user" : { "wildcard" : "ki*y", "boost" : 2.0 } }
        }
    }

这个多项查询允许你使用[rewrite](query-dsl-multi-term-rewrite.html)参数来控制它被重写的方式。
