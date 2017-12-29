## 搜索之后 Search After

结果的分页可以通过使用`from`和`size`来完成，但是当达到深度分页时，成本变得过高。 默认为10000的`index.max_result_window`是一个安全措施，搜索请求占用堆内存，时间与`from + size`成比例。 建议使用[Scroll](search-request-scroll.html)api进行高效的深度滚动，但是滚动上下文代价高昂，建议不要将其用于实时用户请求。 `search_after`参数通过提供一个实时光标来解决这个问题。 这个想法是使用前一页的结果来帮助检索下一页。

假设检索第一页的查询如下所示：
    
    GET twitter/tweet/_search
    {
        "size": 10,
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        },
        "sort": [
            {"date": "asc"},
            {"_uid": "desc"}
        ]
    }

![Note](/images/icons/note.png)

应该使用每个文档具有一个唯一值的字段作为排序规范的仲裁者。 否则，具有相同排序值的文档的排序顺序将是未定义的。 推荐的方法是使用`_uid`字段，这个字段肯定包含每个文档的一个唯一值。

上述请求的结果包含每个文档的`sort values`数组。 这些`sort values`可以与`search_after`参数一起使用，以便在结果列表中的任何文档之后开始返回结果。 例如，我们可以使用最后一个文档的`sort values`，并将其传递给`search_after`来检索结果的下一页：
    
    
    GET twitter/tweet/_search
    {
        "size": 10,
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        },
        "search_after": [1463538857, "tweet#654323"],
        "sort": [
            {"date": "asc"},
            {"_uid": "desc"}
        ]
    }

![Note](/images/icons/note.png)

当使用`search_after`时，参数`from`必须设置为0（或-1）。

`search_after`不是自由跳转到随机页面的解决方案，而是并行滚动许多查询。 它和`scroll` API非常相似，不同之处在于`search_after`参数是无状态的，它总是与最新版本的搜索器进行解析。 出于这个原因，排序顺序可能会在步行过程中发生变化，具体取决于索引的更新和删除。
