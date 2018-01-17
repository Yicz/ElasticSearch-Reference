## 前缀查询 Prefix Query

匹配包含具有指定前缀的字段的字段的文档（**未分析**）。 前缀查询映射到Lucene`PrefixQuery`。 以下匹配用户字段包含以`ki`开头的术语的文档：
    
    GET /_search
    { "query": {
        "prefix" : { "user" : "ki" }
      }
    }

可以给查询指定一个提升因子:
    
    GET /_search
    { "query": {
        "prefix" : { "user" :  { "value" : "ki", "boost" : 2.0 } }
      }
    }

或者使用 `prefix` [5.0.0] 版本中已经弃用. 使用 `value` 语法:
    
    
    GET /_search
    { "query": {
        "prefix" : { "user" :  { "prefix" : "ki", "boost" : 2.0 } }
      }
    }

这个多项查询允许你使用[rewrite](query-dsl-multi-term-rewrite.html)参数来控制它被重写的方式。
