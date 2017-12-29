## `query`元素 Query

搜索请求主体中的`query`元素允许使用[结构查询语言](query-dsl.html)定义查询。
    
    GET /_search
    {
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }
