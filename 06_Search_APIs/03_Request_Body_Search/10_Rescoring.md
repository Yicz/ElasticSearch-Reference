## 重评分

通过对[`query`](search-request-query.html)和[`post_filter`](search-request-post-filter.html)返回的顶部（例如100-500）文档进行重新排序，重新分类可以帮助提高精度。html）阶段，使用次要的（通常更昂贵的）算法，而不是将昂贵的算法应用于索引中的所有文档。

在每个分片上执行一个`rescore`请求，然后返回结果，由处理整个搜索请求的节点排序。

目前rescore API只有一个实现：查询rescorer，它使用查询来调整评分。 在将来，可以提供替代的rescorers，例如`pair-wise rescorer`


![Note](/images/icons/note.png)

当使用[`sort`](search-request-sort.html)时`rescore`阶段不执行。

![Note](/images/icons/note.png)

当向用户公开分页时，当您逐页浏览每个页面（通过传递不同的`from`值）时，不应该更改`window_size`，因为这可能会改变顶部的点击，从而导致在用户遍历页面时导致结果易混淆。

### Query rescorer

查询rescorer只对[`query`](search-request-query.html) 和[`post_filter`](search-request-post-filter.html)阶段返回的Top-K结果执行第二个查询。 将在每个分片上检查的文档的数量可以通过`window_size`参数来控制，该参数默认为[`from`和`size`](search-request-from-size.html).

默认情况下，原始查询和重新评分查询的分数线性组合，为每个文档生成最终的`_score`。 原始查询和重新评分查询的相对重要性可以分别用`query_weight`和`rescore_query_weight`来控制。 两者都默认为`1`。
    
    POST /_search
    {
       "query" : {
          "match" : {
             "message" : {
                "operator" : "or",
                "query" : "the quick brown"
             }
          }
       },
       "rescore" : {
          "window_size" : 50,
          "query" : {
             "rescore_query" : {
                "match_phrase" : {
                   "message" : {
                      "query" : "the quick brown",
                      "slop" : 2
                   }
                }
             },
             "query_weight" : 0.7,
             "rescore_query_weight" : 1.2
          }
       }
    }

分数的组合方式可以通过`score_mode`控制：

分数模式| 描述
---|---  
`total`| 添加原始分数和重新查询分数。 默认。    
`multiply`| 将原始分数乘以rescore查询分数。 用于[`函数查询`](query-dsl-function-score-query.html)重新定义。    
`avg`| 平均原始分数和重新查询分数。
`max`| 取原始分数和重新查询分数的最大值。    
`min`| 取原始分数和重新查询分数的最小值。
  
### Multiple Rescores

也可以按顺序执行多个重新评分：    
    
    POST /_search
    {
       "query" : {
          "match" : {
             "message" : {
                "operator" : "or",
                "query" : "the quick brown"
             }
          }
       },
       "rescore" : [ {
          "window_size" : 100,
          "query" : {
             "rescore_query" : {
                "match_phrase" : {
                   "message" : {
                      "query" : "the quick brown",
                      "slop" : 2
                   }
                }
             },
             "query_weight" : 0.7,
             "rescore_query_weight" : 1.2
          }
       }, {
          "window_size" : 10,
          "query" : {
             "score_mode": "multiply",
             "rescore_query" : {
                "function_score" : {
                   "script_score": {
                      "script": {
                        "inline": "Math.log10(doc.likes.value + 2)"
                      }
                   }
                }
             }
          }
       } ]
    }

第一个获取查询的结果，第二个获得第一个的结果等等。第二个rescore将“看到”第一个rescore完成的排序，因此可以在第一个rescore上使用一个大窗口 将文档拉到更小的窗口进行第二次重新打印。
