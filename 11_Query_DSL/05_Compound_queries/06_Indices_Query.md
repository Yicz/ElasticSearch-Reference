## 索引查询 Indices Query

![Warning](/images/icons/warning.png)

### 5.0.0 版本中弃用 Deprecated in 5.0.0. 

Search on the `_index` field instead 

The `indices` query is useful in cases where a search is executed across multiple indices. It allows to specify a list of index names and an inner query that is only executed for indices matching names on that list. For other indices that are searched, but that don’t match entries on the list, the alternative `no_match_query` is executed.
    
    
    GET /_search
    {
        "query": {
            "indices" : {
                "indices" : ["index1", "index2"],
                "query" : { "term" : { "tag" : "wow" } },
                "no_match_query" : { "term" : { "tag" : "kow" } }
            }
        }
    }

你也可以使用`index`参数只指定一个索引。

`no_match_query` can also have "string" value of `none` (to match no documents), and `all` (to match all). Defaults to `all`.

`query` is mandatory, as well as `indices` (or `index`).
