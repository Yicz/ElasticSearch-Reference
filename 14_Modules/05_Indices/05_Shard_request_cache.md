## 分片请求缓存 Shard request cache

当针对一个或多个索引运行搜索请求时，每个涉及的分片在本地执行搜索，并将其本地结果返回到_coordinating node_，该结点将这些分片级结果组合成“全局”结果集。

分片级请求缓存模块在每个分片上缓存本地结果。 这允许经常使用（可能很频繁）的搜索请求几乎立即返回结果。 请求缓存非常适合日志用例，其中只有最近的索引正在被主动更新 - 旧索引的结果将直接从缓存中提供。

![Important](/images/icons/important.png)

默认地请求缓存只会缓存请求结果`size=0`的请求，它不会绑在命中的文档，但可以缓存了`hist.total` [aggregations](search-aggregations.html), and [suggestions](search-suggesters.html).
。

Most queries that use `now` (see [Date Math cannot be cached]).

#### 缓存失效 Cache invalidation

缓存非常智能，它保持与未缓存的搜索同样的近实时性。

每当分片刷新时，缓存的结果都会自动失效，但只有当分片中的数据实际发生更改时才会失效。 换句话说，您将始终从缓存中获得与未缓存的搜索请求相同的结果。

刷新间隔越长，缓存条目的有效期就越长。 如果缓存已满，则RUC缓存算法。

可以使用[`clear-cache` API](indices-clearcache.html)手动设置绑在失效:
    
    
    POST /kimchy,elasticsearch/_cache/clear?request=true

#### 使用和禁用缓存 Enabling and disabling caching

缓存是默认使用的，但可以通过如下的设置进行在创建一个索引的时候进行禁用。
    
    PUT /my_index
    {
      "settings": {
        "index.requests.cache.enable": false
      }
    }

也可以使用[`update-settings`](indices-update-settings.html) API进行动态地修改:
    
    
    PUT /my_index/_settings
    { "index.requests.cache.enable": true }

#### 每个请求单独的绑在设置 Enabling and disabling caching per request

 查询字符串参数`request_cache`可以针对每个请求进行单独设置绑在的内容。如果设置了，就会覆盖索引级别的设置：  
    
    GET /my_index/_search?request_cache=true
    {
      "size": 0,
      "aggs": {
        "popular_colors": {
          "terms": {
            "field": "colors"
          }
        }
      }
    }

![Important](/images/icons/important.png)

如果您的查询使用的结果不是确定性的脚本（例如，它使用随机函数或引用当前时间），则应将`request_cache`标志设置为`false`以禁用该请求的缓存。

即使在索引设置中启用了请求缓存，请求`size`大于0也不会被缓存。 要缓存这些请求，您将需要使用此处详细描述的query-string参数。

#### 缓存键值 Cache key

整个JSON体被用作缓存键。 这意味着如果JSON发生变化（例如，按不同顺序输出密钥），那么缓存密钥将不会被识别。

![Tip](/images/icons/tip.png)

大多数JSON库都支持一个_canonical_模式，以确保JSON密钥始终以相同的顺序发射。 这个规范模式可以在应用程序中使用，以确保请求总是以相同的方式序列化。

#### 缓存设置 Cache settings

缓存的管理是在节点级别上的，默认最大的缓存是堆内存大小的1%。可以在`config/elasticsearch.yml`进行修改：

    
    indices.requests.cache.size: 2%

你也可以使用`indices.requests.cache.expire`指定缓存的生命周期（TTL），但没有理由去修改这个。请记住陈旧的缓存在索引刷新的时候会自动过期。这个设置仅仅是为了完整性而提供的。

#### 监控缓存的使用 Monitoring cache usage

使用[`indices-stats`](indices-stats.html) API可以查看缓存的大小（字节级别），和过期的索引缓存。
    
    GET /_stats/request_cache?human

或者使用[`nodes-stats`](cluster-nodes-stats.html) API:
    
    
    GET /_nodes/stats/indices/request_cache?human
