## 最高命中聚合 Top hits Aggregation

`top_hits`聚合追踪最高相关度的文档。通常作为其他聚合的子聚合进行使用，所有可以结合归类聚合进行使用。

`top_hist`聚合可以使用归类聚合进行高效地分组。可以定义一个或都多个属性进行归类的划分。


### 选项

  * `from` 偏移量，用于获取分布的结果 
  * `size` 获取文档的大小。
  * `sort` 用于排序结果



### 支持的特性 Supported per hit features

top_hits聚合返回常规搜索文档，因为这可以支持许多每击中功能：

  * [Highlighting](search-request-highlighting.html)
  * [Explain](search-request-explain.html)
  * [Named filters and queries](search-request-named-queries-and-filters.html)
  * [Source filtering](search-request-source-filtering.html)
  * [Stored fields](search-request-stored-fields.html)
  * [Script fields](search-request-script-fields.html)
  * [Doc value fields](search-request-docvalue-fields.html)
  * [Include versions](search-request-version.html)



### Example

在下面的例子中，我们按标签和每个标签对问题进行分组，显示最后一个活动问题。 对于每个问题，只有标题字段被包含在源代码中。    
    
    POST /sales/_search?size=0
    {
        "aggs": {
            "top_tags": {
                "terms": {
                    "field": "type",
                    "size": 3
                },
                "aggs": {
                    "top_sales_hits": {
                        "top_hits": {
                            "sort": [
                                {
                                    "date": {
                                        "order": "desc"
                                    }
                                }
                            ],
                            "_source": {
                                "includes": [ "date", "price" ]
                            },
                            "size" : 1
                        }
                    }
                }
            }
        }
    }

响应内容:
    
    
    {
      ...
      "aggregations": {
        "top_tags": {
           "doc_count_error_upper_bound": 0,
           "sum_other_doc_count": 0,
           "buckets": [
              {
                 "key": "hat",
                 "doc_count": 3,
                 "top_sales_hits": {
                    "hits": {
                       "total": 3,
                       "max_score": null,
                       "hits": [
                          {
                             "_index": "sales",
                             "_type": "sale",
                             "_id": "AVnNBmauCQpcRyxw6ChK",
                             "_source": {
                                "date": "2015/03/01 00:00:00",
                                "price": 200
                             },
                             "sort": [
                                1425168000000
                             ],
                             "_score": null
                          }
                       ]
                    }
                 }
              },
              {
                 "key": "t-shirt",
                 "doc_count": 3,
                 "top_sales_hits": {
                    "hits": {
                       "total": 3,
                       "max_score": null,
                       "hits": [
                          {
                             "_index": "sales",
                             "_type": "sale",
                             "_id": "AVnNBmauCQpcRyxw6ChL",
                             "_source": {
                                "date": "2015/03/01 00:00:00",
                                "price": 175
                             },
                             "sort": [
                                1425168000000
                             ],
                             "_score": null
                          }
                       ]
                    }
                 }
              },
              {
                 "key": "bag",
                 "doc_count": 1,
                 "top_sales_hits": {
                    "hits": {
                       "total": 1,
                       "max_score": null,
                       "hits": [
                          {
                             "_index": "sales",
                             "_type": "sale",
                             "_id": "AVnNBmatCQpcRyxw6ChH",
                             "_source": {
                                "date": "2015/01/01 00:00:00",
                                "price": 150
                             },
                             "sort": [
                                1420070400000
                             ],
                             "_score": null
                          }
                       ]
                    }
                 }
              }
           ]
        }
      }
    }

### 字段折叠的例子 Field collapse example

字段折叠或结果分组是将结果集合逻辑地分组成组，并且每个组返回顶部文档的功能。 组的排序取决于组中第一个文档的相关性。 在Elasticsearch中，这可以通过一个桶聚合来实现，该聚合将`top_hits`聚合包装为子聚合。

在下面的例子中，我们搜索了爬网的网页。 对于每个网页，我们存储正文和网页所属的域。 通过在`domain`字段上定义`terms`聚合，我们按域分组网页的结果集。 然后，将“top_hits”聚合定义为子聚合，以便每个存储桶收集最高匹配的匹配。

另外还定义了一个`maxt`聚合，`terms`聚合的顺序特征使用“最大”聚合，通过桶中最相关文档的相关顺序返回分组。


    {
      "query": {
        "match": {
          "body": "elections"
        }
      },
      "aggs": {
        "top-sites": {
          "terms": {
            "field": "domain",
            "order": {
              "top_hit": "desc"
            }
          },
          "aggs": {
            "top_tags_hits": {
              "top_hits": {}
            },
            "top_hit" : {
              "max": {
                "script": {
                  "inline": "_score"
                }
              }
            }
          }
        }
      }
    }

目前需要`max`（或`min`）聚合来确保来自`terms`聚合的桶按照每个域最相关的网页的得分排序。 不幸的是，`top_hits`聚合不能用在`terms`聚合的`order`选项中。

### top_hits support in a nested or reverse_nested aggregator

如果`top_hits`聚合被封装在`nested`或`reverse_nested`聚合中，则嵌套命中被返回。嵌套命中在某种意义上隐藏了迷你文档，这些文档是常规文档的一部分，其中映射中嵌套的字段类型已被配置。如果包含`nested`或`reverse_nested`聚合，“top_hits”聚合可以取消隐藏这些文档。阅读更多关于嵌套在[嵌套类型映射](nested.html)。

如果已经配置嵌套类型，则单个文档实际上被索引为多个Lucene文档，并且它们共享相同的ID。为了确定一个嵌套命中的身份，需要的不仅仅是id，所以这就是为什么嵌套命中还包括它们的嵌套身份。嵌套标识保存在搜索命中的_nested字段下，并包含数组字段和嵌套的命中所属的数组字段中的偏移量。偏移量是从零开始的。

顶部命中带有嵌套命中的响应片段，它位于ID为1的文档中的数组字段“nested_field1”的第三个插槽中：
    
    
    ...
    "hits": {
     "total": 25365,
     "max_score": 1,
     "hits": [
       {
         "_index": "a",
         "_type": "b",
         "_id": "1",
         "_score": 1,
         "_nested" : {
           "field" : "nested_field1",
           "offset" : 2
         }
         "_source": ...
       },
       ...
     ]
    }
    ...

如果`_source`被请求，那么只返回嵌套对象的部分源，而不是整个文档的源。 也可以通过驻留在嵌套或reverse_nested聚合器中的`top_hits`聚合器来访问嵌套的内部对象层上的字段。

只有嵌套命中才会在命中中有_nested字段，非嵌套（常规）命中不会有_nested字段。

如果`_source`没有被启用，`_nested`中的信息也可以用来解析其他地方的源代码。

如果在映射中定义了多层嵌套对象类型，那么`_nested`信息也可以是分层的，以便表达嵌套深度为两层或更深的嵌套的标识。

在下面的例子中，嵌套命中位于字段`nested_grand_child_field`的第一个插槽，该字段位于`nested_child_field`字段的第二个缓慢区域：


    ...
    "hits": {
     "total": 2565,
     "max_score": 1,
     "hits": [
       {
         "_index": "a",
         "_type": "b",
         "_id": "1",
         "_score": 1,
         "_nested" : {
           "field" : "nested_child_field",
           "offset" : 1,
           "_nested" : {
             "field" : "nested_grand_child_field",
             "offset" : 0
           }
         }
         "_source": ...
       },
       ...
     ]
    }
    ...
