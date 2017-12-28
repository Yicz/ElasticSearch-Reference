## 查询 Search

search API 允许执行一个查询并返回匹配到的内容，查询可以使用一个简单的uri[查询字符串 uery string as a parameter](search-uri-request.html)作为参数，也可以使用[请求体 request body](search-request-body.html)作为参数载荷。


### 多索引，多类型 Multi-Index, Multi-Type

所有的search APIs 都支持索引内跨类型查询，和使用多[索引语法]](multi-index.html)进行跨索引查询。例如，我们可以在`twitter`索引内进行跨类型查询。
    
    GET /twitter/_search?q=user:kimchy

也可以进行指定类型查询：
    
    GET /twitter/tweet,user/_search?q=user:kimchy

可以跨多个索引查询所有包含一个明确标签的`tweets`（例如，每个用户都有自己的索引）
    
    GET /kimchy,elasticsearch/tweet/_search?q=tag:wow

可以使用`_all`来代替所有可用的索引：
    
    GET /_all/tweet/_search?q=tag:wow

使用`_search`作为根查询所有索引和类型：
    
    GET /_search?q=tag:wow

By default elasticsearch doesn’t reject any search requests based on the number of shards the request hits. While elasticsearch will optimize the search execution on the coordinating node a large number of shards can have a significant impact CPU and memory wise. It is usually a better idea to organize data in such a way that there are fewer larger shards. In case you would like to configure a soft limit, you can update the `action.search.shard_count.limit` cluster setting in order to reject search requests that hit too many shards.
