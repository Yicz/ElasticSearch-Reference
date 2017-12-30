## 滚动 Scroll

当“搜索”请求返回单个“页面”结果时，“scroll”API可用于从单个搜索请求中检索大量结果（甚至是所有结果），与您使用传统数据库上的光标的方法大致相同 。

滚动不是为了实时的用户请求，而是为了处理大量的数据，例如， 以便将一个索引的内容重新索引到具有不同配置的新索引中。

  **客户端支持滚动和重新索引**

一些官方支持的客户提供帮助来帮助滚动搜索和重新索引文件从一个索引到另一个：

Perl 
    [Search::Elasticsearch::Client::5_0::Bulk](https://metacpan.org/pod/Search::Elasticsearch::Client::5_0::Bulk) 和 [Search::Elasticsearch::Client::5_0::Scroll](https://metacpan.org/pod/Search::Elasticsearch::Client::5_0::Scroll)
Python 
    [elasticsearch.helpers.\*](http://elasticsearch-py.readthedocs.org/en/master/helpers.html)

![Note](/images/icons/note.png)

滚动请求返回的结果反映了在发出初始“搜索”请求时索引的状态，就像是快照。 文档的后续更改（索引，更新或删除）只会影响稍后的搜索请求。

为了使用滚动，最初的搜索请求应该在查询字符串中指定`scroll`参数，它告诉Elasticsearch应该保持“搜索上下文”保持多久（参见[Keeping the search context alive](search-request-scroll.html#scroll-search-context)），例如`？scroll = 1m`。
    
    POST /twitter/tweet/_search?scroll=1m
    {
        "size": 100,
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        }
    }

上述请求的结果包含一个`_scroll_id`，它应该被传递给`scroll` API以获取下一批结果。
    
    
    POST <1> /_search/scroll <2>
    {
        "scroll" : "1m", <3>
        "scroll_id" : "DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ==" <4>
    }

<1>| 可以使用 `GET` 或 `POST`     
---|---    
<2>| 该URL不应包含`index`或`type`的名称 - 这些在原始的“搜索”请求中指定。     
<3>| `scroll`参数告诉Elasticsearch保持搜索上下文打开另一个`1m`。   
<4>| `scroll_id`参数   
  
`size`参数允许您配置每批结果返回的最大命中数。 每次调用“scroll”API都会返回下一批结果，直到没有更多结果返回，即“hits”数组为空。

![Important](/images/icons/important.png)

最初的搜索请求和每个后续的滚动请求返回一个新的_scroll_id - 只应使用最近的_scroll_id。

![Note](/images/icons/note.png)

如果请求指定了聚合，则只有最初的搜索响应将包含聚合结果。

![Note](/images/icons/note.png)

滚动请求具有优化功能，当排序顺序为`_doc`时，它们会更快。 如果您要遍历所有文档，而不考虑顺序，这是最有效的选择：
    
    
    GET /_search?scroll=1m
    {
      "sort": [
        "_doc"
      ]
    }

### Keeping the search context alive

`scroll`参数（传递给“搜索”请求和每个“滚动”请求）告诉Elasticsearch应该保持搜索上下文多长时间。 其值（例如`1m`，参见[时间单位]设置新的到期时间)。

通常情况下，后台合并过程通过合并较小的段来创建新的更大的段来优化索引，此时较小的段被删除。 这个过程在滚动过程中继续，但是一个开放的搜索上下文可以防止旧的段在被使用时被删除。 这就是Elasticsearch如何能够返回初始搜索请求的结果，而不管随后对文档所做的更改。

![Tip](/images/icons/tip.png)

保持较旧的段活着意味着需要更多的文件句柄。 确保你已经配置了你的节点有足够的空闲文件句柄。 请参见[文件描述符](file-descriptors.html)。

您可以使用[nodes stats API](cluster-nodes-stats.html)检查打开了多少个搜索上下文：    
    
    GET /_nodes/stats/indices/search

### Clear scroll API

搜索上下文会在超过滚动超时时自动删除。 然而，保持滚动打开有一个成本，正如[前面内容](search-request-scroll.html#scroll-search-context)中所讨论的那样，只要不再使用滚动，滚动就应该使用 `clear-scroll` API明确地清除
    
    DELETE /_search/scroll
    {
        "scroll_id" : ["DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ=="]
    }

多个滚动ID可以作为数组传递：    
    
    DELETE /_search/scroll
    {
        "scroll_id" : [
          "DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ==",
          "DnF1ZXJ5VGhlbkZldGNoBQAAAAAAAAABFmtSWWRRWUJrU2o2ZExpSGJCVmQxYUEAAAAAAAAAAxZrUllkUVlCa1NqNmRMaUhiQlZkMWFBAAAAAAAAAAIWa1JZZFFZQmtTajZkTGlIYkJWZDFhQQAAAAAAAAAFFmtSWWRRWUJrU2o2ZExpSGJCVmQxYUEAAAAAAAAABBZrUllkUVlCa1NqNmRMaUhiQlZkMWFB"
        ]
    }

所有的搜索上下文都可以用`_all`参数清除：    
    
    DELETE /_search/scroll/_all

`scroll_id`也可以作为查询字符串参数或请求主体传递。 多个滚动ID可以作为逗号分隔值传递：
    
    
    DELETE /_search/scroll/DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ==,DnF1ZXJ5VGhlbkZldGNoBQAAAAAAAAABFmtSWWRRWUJrU2o2ZExpSGJCVmQxYUEAAAAAAAAAAxZrUllkUVlCa1NqNmRMaUhiQlZkMWFBAAAAAAAAAAIWa1JZZFFZQmtTajZkTGlIYkJWZDFhQQAAAAAAAAAFFmtSWWRRWUJrU2o2ZExpSGJCVmQxYUEAAAAAAAAABBZrUllkUVlCa1NqNmRMaUhiQlZkMWFB

### Sliced Scroll

对于返回大量文档的滚动查询，可以将滚动拆分为可以独立使用的多个切片：
    
    
    GET /twitter/tweet/_search?scroll=1m
    {
        "slice": {
            "id": 0, <1>
            "max": 2 <2>
        },
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        }
    }
    GET /twitter/tweet/_search?scroll=1m
    {
        "slice": {
            "id": 1,
            "max": 2
        },
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        }
    }

<1>| 切片的ID   
---|---    
<2>| 切片的最大数量  
  
The result from the first request returned documents that belong to the first slice (id: 0) and the result from the second request returned documents that belong to the second slice. Since the maximum number of slices is set to 2 the union of the results of the two requests is equivalent to the results of a scroll query without slicing. By default the splitting is done on the shards first and then locally on each shard using the   \_uid field with the following formula: `slice(doc) = floorMod(hashCode(doc._uid), max)` For instance if the number of shards is equal to 2 and the user requested 4 slices then the slices 0 and 2 are assigned to the first shard and the slices 1 and 3 are assigned to the second shard.

Each scroll is independent and can be processed in parallel like any scroll request.

![Note](/images/icons/note.png)

If the number of slices is bigger than the number of shards the slice filter is very slow on the first calls, it has a complexity of O(N) and a memory cost equals to N bits per slice where N is the total number of documents in the shard. After few calls the filter should be cached and subsequent calls should be faster but you should limit the number of sliced query you perform in parallel to avoid the memory explosion.

To avoid this cost entirely it is possible to use the `doc_values` of another field to do the slicing but the user must ensure that the field has the following properties:

  * The field is numeric. 
  * `doc_values` are enabled on that field 
  * Every document should contain a single value. If a document has multiple values for the specified field, the first value is used. 
  * The value for each document should be set once when the document is created and never updated. This ensures that each slice gets deterministic results. 
  * The cardinality of the field should be high. This ensures that each slice gets approximately the same amount of documents. 


    
    
    GET /twitter/tweet/_search?scroll=1m
    {
        "slice": {
            "field": "date",
            "id": 0,
            "max": 10
        },
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        }
    }

只附加基于时间的索引，`timestamp`字段可以安全使用。
![Note](/images/icons/note.png)

默认情况下，每个滚动允许的最大切片数量限制为1024.您可以更新index.max_slices_per_scroll索引设置以绕过此限制。
