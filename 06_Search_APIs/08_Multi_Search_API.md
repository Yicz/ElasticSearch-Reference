## 多查询API Multi Search API

多搜索API允许在相同的API中执行多个搜索请求。 它的接口是`_msearch`。

请求的格式类似于批量（bluk）API格式，并使用换行符分隔的JSON（NDJSON）格式。 结构如下（如果特定的搜索结束重定向到另一个节点，则该结构被特别优化以减少解析）：
    
    header\n
    body\n
    header\n
    body\n

**注意**：最后一行数据必须以换行符`\n`结尾。 每个换行符都可以在回车符`\r`之后。 当向这个接口发送请求时，Content-Type头应该被设置为application/x-ndjson。

头部分包括搜索哪些索引/索引，可选（映射）类型来搜索，search_type，preference和routing。 主体包括典型的搜索主体请求（包括`query`，`aggregations`，`from`，`size`等等）。 这里是一个例子：
    
    
    $ cat requests
    {"index" : "test"}
    {"query" : {"match_all" : {} }, "from" : 0, "size" : 10}
    {"index" : "test", "search_type" : "dfs_query_then_fetch"}
    {"query" : {"match_all" : {} } }
    {}
    {"query" : {"match_all" : {} } }
    
    {"query" : {"match_all" : {} } }
    {"search_type" : "dfs_query_then_fetch"}
    {"query" : {"match_all" : {} } }
    
    
    $ curl -H "Content-Type: application/x-ndjson" -XGET localhost:9200/_msearch --data-binary "@requests"; echo

注意，上面包括了一个空头的例子（也可以是没有任何内容的），它也被支持。

响应返回一个`responses`数组，其中包含每个搜索请求的搜索响应和状态码，以匹配原始多重搜索请求中的顺序。 如果该特定搜索请求完全失败，将返回带有`error`消息和相应状态代码的对象，而不是实际的搜索响应。

接口还允许在URI本身中对`indices`和`types`进行搜索，在这种情况下，它将被用作默认值，除非在头中另外明确定义。 例如：
    
    
    GET twitter/_msearch
    {}
    {"query" : {"match_all" : {} }, "from" : 0, "size" : 10}
    {}
    {"query" : {"match_all" : {} } }
    {"index" : "twitter2"}
    {"query" : {"match_all" : {} } }

以上将针对所有未定义索引的请求执行针对`twitter`索引的搜索，最后一个针对`twitter2`索引执行。

`search_type`可以用类似的方式设置，以全局应用于所有的搜索请求。

msearch的`max_concurrent_searches`请求参数可以用来控制多搜索api将执行的最大并发搜索数。 此默认值基于数据节点的数量和默认搜索线程池大小。

### 安全

参见 [_URL-based access control_](url-access-control.html)

### 模板支持

就像`_search`资源的[_Search Template_](search-template.html)中所描述的一样，`_msearch`也提供了对模板的支持。 提交他们如下所示：
    
    GET _msearch/template
    {"index" : "twitter"}
    { "inline" : "{ \"query\": { \"match\": { \"message\" : \"{ {keywords} }\" } } } }", "params": { "query_type": "match", "keywords": "some message" } }
    {"index" : "twitter"}
    { "inline" : "{ \"query\": { \"match_{ {template} }\": {} } }", "params": { "template": "all" } }

内联模板。

您也可以创建搜索模板：
    
    
    POST /_search/template/my_template_1
    {
        "template": {
            "query": {
                "match": {
                    "message": "{ {query_string} }"
                }
            }
        }
    }
    
    
    POST /_search/template/my_template_2
    {
        "template": {
            "query": {
                "term": {
                    "{ {field} }": "{ {value} }"
                }
            }
        }
    }

并稍后在`_msearch`中使用它们：    
    
    GET _msearch/template
    {"index" : "main"}
    { "id": "my_template_1", "params": { "query_string": "some message" } }
    {"index" : "main"}
    { "id": "my_template_2", "params": { "field": "user", "value": "test" } }
