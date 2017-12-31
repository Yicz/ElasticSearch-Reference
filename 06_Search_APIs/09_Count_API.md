## 统计API Count API

计数API允许轻松执行查询并获取该查询的匹配数量。 它可以跨越一个或多个索引并跨越一个或多个类型执行。 可以使用一个简单的查询字符串作为参数，或者使用请求主体中定义的[Query DSL](query-dsl.html)来提供查询。 这里是一个例子：
    
    
    PUT /twitter/tweet/1?refresh
    {
        "user": "kimchy"
    }
    
    GET /twitter/tweet/_count?q=user:kimchy
    
    GET /twitter/tweet/_count
    {
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

![Note](/images/icons/note.png)

正在发送的查询必须嵌套在`query`键中，与[search api](search-search.html)相同

上面的两个例子都做同样的事情，这是从一个特定的用户的twitter索引的数量。 结果是：    
    
    {
        "count" : 1,
        "_shards" : {
            "total" : 5,
            "successful" : 5,
            "failed" : 0
        }
    }

该查询是可选的，当不提供时，它将使用`match_all`来计算所有的文档。

### 多索引，多类型 

计数API可以应用于[多索引中的多类型](search-search.html#search-multi-index-type).

### 请求参数

当使用查询参数`q`执行计数时，传递的查询是使用Lucene查询解析器的查询字符串。 还有其他可以传递的参数：

名称 | 描述  
---|---    
`df`| 在查询中未定义字段前缀时使用的默认字段。   
`analyzer`| 分析查询字符串时要使用的分析器名称。 
`default_operator`| 要使用的默认运算符可以是`AND`或`OR`。 默认为`OR`。
`lenient`| 如果设置为true将导致基于格式的失败（如提供文本到数字字段）被忽略。 默认为`false`。
`analyze_wildcard`| 是否应该分析通配符和前缀查询。 默认为`false`。    
`terminate_after`| 每个分片的最大计数，一旦到达，查询执行将提前终止。 如果设置，响应将有一个布尔型字段`terminated_early`来指示查询执行是否实际已经提前结束。 缺省为不提前。  
  
### 请求体

计数可以使用[查询DSL](query-dsl.html)在其正文中，以表达应执行的查询。 主体内容也可以作为名为`source`的REST参数传递。

GET和POST方法都可以用请求体来执行计数API。 由于不是所有的客户端都支持GET，所以POST也是允许的。

### 分散式 Distributed
计数操作通过所有分片广播。 对于每个分片ID组，都会选择一个副本并对其执行。 这意味着副本增加了count的可扩展性。


### 路由 Routing

可以指定路由值（以逗号分隔的路由值列表），以控制要执行的计数请求的分片。
