##  偏移量/大小  From / Size

结果的分页可以通过使用`from`和`size`参数来完成。 `from`参数定义了你想要获取的第一个结果的偏移量。 `size`参数允许您配置要返回的最大命中文档数量。

虽然`from`和`size`可以设置为请求参数，但是也可以在搜索体中设置。 `from`默认为`0`，`size`默认为`10`。
    
    
    GET /_search
    {
        "from" : 0, "size" : 10,
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

请注意`from`+`size`不能超过`index.max_result_window`索引设置，默认为`10000`。 查看[Scroll](search-request-scroll.html)或[Search After][Search After](search-request-search-after.html) API以获得更高效的深度滚动方法。
