## 多查询模板 Multi Search Template

多搜索模板API允许使用`_msearch/template` API在同一个API中执行多个搜索模板请求。


请求的格式与[Multi Search API](search-multi-search.html)格式类似：

    header\n
    body\n
    header\n
    body\n

标题部分支持与通常的Multi Search API相同的`index`，`types`，`search_type`，`preference`和`routing`选项。


正文包含搜索模板正文请求，并支持内嵌，存储和文件模板。 这里是一个例子：    
    
    $ cat requests
    {"index": "test"}
    {"inline": {"query": {"match":  {"user" : "{ {username} }" } } }, "params": {"username": "john"} } <1>
    {"index": "_all", "types": "accounts"}
    {"inline": {"query": {"{ {query_type} }": {"name": "{ {name} }" } } }, "params": {"query_type": "match_phrase_prefix", "name": "Smith"} }
    {"index": "_all"}
    {"id": "template_1", "params": {"query_string": "search for these words" } } <2>
    {"types": "users"}
    {"file": "template_2", "params": {"field_name": "fullname", "field_value": "john smith" } } <3>
    
    $ curl -H "Content-Type: application/x-ndjson" -XGET localhost:9200/_msearch/template --data-binary "@requests"; echo

<1>| 内嵌搜索模板请求    
---|---    
<2>| 基于存储的模板搜索模板请求     
<3>| 基于文件模板的搜索模板请求   


响应返回一个`responses`数组，其中包括每个搜索模板请求的搜索模板响应，以匹配原始多搜索模板请求中的顺序。如果该特定搜索模板请求完全失败，将返回带有`error`消息的对象，而不是实际的搜索响应。
