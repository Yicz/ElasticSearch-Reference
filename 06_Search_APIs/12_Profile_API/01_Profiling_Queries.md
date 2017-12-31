## Profiling Queries

![Note](/images/icons/note.png)

Profile API提供的细节直接暴露了Lucene类的名称和概念，这意味着对结果的完整解释需要相当理解的Lucene知识。这个节内容试图给出Lucene如何执行查询的崩溃过程，以便您可以使用Profile API成功诊断和调试查询，但这只是一个概述。 有关完整的理解，请参阅Lucene的文档和地方的代码。

这样说，完整的理解往往不需要修复慢速查询。 查看查询的特定组件通常是足够的，例如，不一定理解为什么查询的“advance”阶段是原因。

### `query` 章节

`query` 部分包含了Lucene在特定分片上执行的查询树的详细时序。这个查询树的整体结构将类似于您的原始Elasticsearch查询，但可能稍微（或有时甚至是）不同。它也将使用类似的，但并不总是相同的命名。 使用我们以前的`match`查询示例，让我们分析一下`query`部分
    
    
    "query": [
        {
           "type": "BooleanQuery",
           "description": "message:message message:number",
           "time": "1.873811000ms",
           "time_in_nanos": "1873811",
           "breakdown": {...},               <1>
           "children": [
              {
                 "type": "TermQuery",
                 "description": "message:message",
                 "time": "0.3919430000ms",
                 "time_in_nanos": "391943",
                 "breakdown": {...}
              },
              {
                 "type": "TermQuery",
                 "description": "message:number",
                 "time": "0.2106820000ms",
                 "time_in_nanos": "210682",
                 "breakdown": {...}
              }
           ]
        }
    ]

<1>| 为简单起见，故障时间被省略    
---|---  

根据配置`profile`结构，我们可以看到我们的`match`查询被Lucene重写为带有两个子句的BooleanQuery（都是TermQuery）。 `type`字段显示Lucene类的名称，并且经常与Elasticsearch中的等价名称对齐。 `description`字段显示查询的Lucene说明文本，可用于帮助区分查询的各个部分（例如，message：search和message：test都是TermQuery，否则将显示相同的结果。

`time`字段显示这个查询花费了大约1.8ms的时间执行整个BooleanQuery。记录的时间包括所有的孩子。

`time_in_nanos`字段以毫微秒的精确机器可读格式显示定时信息。

`breakdown`字段会详细记录下如何花费时间，稍后我们再来看看。最后，`children`数组列出了可能存在的任何子查询。因为我们搜索了两个值（“搜索测试”），所以我们的BooleanQuery包含两个子查询TermQueries。他们有相同的信息（类型，时间，细目等）。儿童可以有自己的孩子。

![Note](/images/icons/note.png)

`time`字段仅用于人类阅读。 如果您需要准确的时间值，请使用`time_in_nanos`.`time`字段默认是输出的，但是会随着下一个主要版本（6.0.0）而改变，默认打印time_in_nanos。

#### Timing Breakdown

`breakdown`组件列出了关于底层Lucene执行的详细时间统计信息：    
    
    "breakdown": {
       "score": 51306,
       "score_count": 4,
       "build_scorer": 2935582,
       "build_scorer_count": 1,
       "match": 0,
       "match_count": 0,
       "create_weight": 919297,
       "create_weight_count": 1,
       "next_doc": 53876,
       "next_doc_count": 5,
       "advance": 0,
       "advance_count": 0
    }

计时器以挂钟纳秒列出，并且根本没有标准化。 关于整个`time`的所有警告在这里适用。 细分的目的是给你一个感觉：A）Lucene中的哪些机器实际上是在花时间，B）各个部件之间的时间差异的大小。 就像整体的时间一样，花费时间包括了所有的子层。

统计的含义如下：

#### 所有参数:

`create_weight`|Lucene中的查询必须能够跨多个IndexSearchers重用（将其视为针对特定Lucene索引执行搜索的引擎）。这使得Lucene处于棘手的地步，因为许多查询需要累积与正在使用的索引关联的临时状态/统计信息，但是Query合同要求它必须是不可变的。为了解决这个问题，Lucene要求每个查询生成一个Weight对象，该对象充当临时上下文对象，以保存与此特定（IndexSearcher，Query）元组关联的状态。“权重”度量显示了这个过程需要多长时间   
---|---    
`build_scorer`| 他的参数显示了为查询构建Scorer需要多长时间。Scorer是迭代匹配文档的机制，每个文档产生一个分数（例如，“foo”与文档匹配程度如何？）。 请注意，这将记录生成Scorer对象所需的时间，而不是实际评分文档。 根据优化，复杂性等，一些查询具有更快或更慢的Scorer初始化。如果启用和/或适用于查询，这也可以显示与缓存相关的时间   
`next_doc`| Lucene方法`next_doc`返回与查询匹配的下一个文档的Doc ID。 此统计信息显示确定哪个文档是下一个匹配所花费的时间，这个过程根据查询的性质而变化很大。Next_doc是advance（）的一个特殊形式，对于Lucene中的许多查询来说更方便。 相当于advance（docId（）+ 1） 
`advance`| `advance`是next_doc的“底层”版本：它用于找到下一个匹配文档的相同目的，但是需要调用查询来执行额外的任务，例如识别和移动跳过等等。但是，并不是所有的查询都可以使用next_doc，所以`advance`也为这些查询定时。 连接（例如boolean中的`must`子句）是`advance`的典型消费者
`matches`| 某些查询（如短语查询）使用“两阶段”过程来匹配文档。首先，文档是“大致”匹配的，如果大致匹配，则以更严格（且昂贵）的过程进行第二次检查。第二阶段验证是“匹配”统计措施。 例如，短语查询首先通过确保短语中的所有词语出现在文档中来检查文档。如果存在所有条款，则执行第二阶段验证，以确保条款按顺序形成短语，这比仅检查条款的存在相对昂贵。 由于这个两阶段过程只被少数查询使用，所以“度量”统计量通常为零
`score`| 这记录了通过Scorer`* _count` |评分特定文档所花费的时间 记录特定方法的调用次数。 例如``next_doc_count“：2，`表示在两个不同的文档上调用了`nextDoc（）`方法。 这可以用来通过比较不同查询组件之间的计数来帮助判断选择性查询的方式。  
  
### `collectors` Section

The Collectors portion of the response shows high-level execution details. Lucene works by defining a "Collector" which is responsible for coordinating the traversal, scoring and collection of matching documents. Collectors are also how a single query can record aggregation results, execute unscoped "global" queries, execute post-query filters, etc.

Looking at the previous example:
    
    
    "collector": [
       {
          "name": "CancellableCollector",
          "reason": "search_cancelled",
          "time": "0.3043110000ms",
          "time_in_nanos": "304311",
          "children": [
            {
              "name": "SimpleTopScoreDocCollector",
              "reason": "search_top_hits",
              "time": "0.03227300000ms",
              "time_in_nanos": "32273"
            }
          ]
       }
    ]

We see a single collector named `SimpleTopScoreDocCollector` wrapped into `CancellableCollector`. `SimpleTopScoreDocCollector` is the default "scoring and sorting" `Collector` used by Elasticsearch. The `reason` field attempts to give a plain english description of the class name. The `time` is similar to the time in the Query tree: a wall-clock time inclusive of all children. Similarly, `children` lists all sub-collectors. The `CancellableCollector` that wraps `SimpleTopScoreDocCollector` is used by elasticsearch to detect if the current search was cancelled and stop collecting documents as soon as it occurs.

It should be noted that Collector times are **independent** from the Query times. They are calculated, combined and normalized independently! Due to the nature of Lucene’s execution, it is impossible to "merge" the times from the Collectors into the Query div, so they are displayed in separate portions.

For reference, the various collector reason’s are:

`search_sorted`| A collector that scores and sorts documents. This is the most common collector and will be seen in most simple searches     
---|---    
`search_count`| A collector that only counts the number of documents that match the query, but does not fetch the source. This is seen when `size: 0` is specified     
`search_terminate_after_count`| A collector that terminates search execution after `n` matching documents have been found. This is seen when the `terminate_after_count` query parameter has been specified     
`search_min_score`| A collector that only returns matching documents that have a score greater than `n`. This is seen when the top-level parameter `min_score` has been specified.     
`search_multi`| A collector that wraps several other collectors. This is seen when combinations of search, aggregations, global aggs and post_filters are combined in a single search.     
`search_timeout`| A collector that halts execution after a specified period of time. This is seen when a `timeout` top-level parameter has been specified.     
`aggregation`| A collector that Elasticsearch uses to run aggregations against the query scope. A single `aggregation` collector is used to collect documents for **all** aggregations, so you will see a list of aggregations in the name rather.     
`global_aggregation`| A collector that executes an aggregation against the global query scope, rather than the specified query. Because the global scope is necessarily different from the executed query, it must execute it’s own match_all query (which you will see added to the Query div) to collect your entire dataset   
  
### `rewrite` Section

All queries in Lucene undergo a "rewriting" process. A query (and its sub-queries) may be rewritten one or more times, and the process continues until the query stops changing. This process allows Lucene to perform optimizations, such as removing redundant clauses, replacing one query for a more efficient execution path, etc. For example a Boolean → Boolean → TermQuery can be rewritten to a TermQuery, because all the Booleans are unnecessary in this case.

The rewriting process is complex and difficult to display, since queries can change drastically. Rather than showing the intermediate results, the total rewrite time is simply displayed as a value (in nanoseconds). This value is cumulative and contains the total time for all queries being rewritten.

### A more complex example

To demonstrate a slightly more complex query and the associated results, we can profile the following query:
    
    
    GET /test/_search
    {
      "profile": true,
      "query": {
        "term": {
          "message": {
            "value": "search"
          }
        }
      },
      "aggs": {
        "non_global_term": {
          "terms": {
            "field": "agg"
          },
          "aggs": {
            "second_term": {
              "terms": {
                "field": "sub_agg"
              }
            }
          }
        },
        "another_agg": {
          "cardinality": {
            "field": "aggB"
          }
        },
        "global_agg": {
          "global": {},
          "aggs": {
            "my_agg2": {
              "terms": {
                "field": "globalAgg"
              }
            }
          }
        }
      },
      "post_filter": {
        "term": {
          "my_field": "foo"
        }
      }
    }

This example has:

  * A query 
  * A scoped aggregation 
  * A global aggregation 
  * A post_filter 



And the response:
    
    
    {
       "profile": {
             "shards": [
                {
                   "id": "[P6-vulHtQRWuD4YnubWb7A][test][0]",
                   "searches": [
                      {
                         "query": [
                            {
                               "type": "TermQuery",
                               "description": "my_field:foo",
                               "time": "0.4094560000ms",
                               "time_in_nanos": "409456",
                               "breakdown": {
                                  "score": 0,
                                  "score_count": 1,
                                  "next_doc": 0,
                                  "next_doc_count": 2,
                                  "match": 0,
                                  "match_count": 0,
                                  "create_weight": 31584,
                                  "create_weight_count": 1,
                                  "build_scorer": 377872,
                                  "build_scorer_count": 1,
                                  "advance": 0,
                                  "advance_count": 0
                               }
                            },
                            {
                               "type": "TermQuery",
                               "description": "message:search",
                               "time": "0.3037020000ms",
                               "time_in_nanos": "303702",
                               "breakdown": {
                                  "score": 0,
                                  "score_count": 1,
                                  "next_doc": 5936,
                                  "next_doc_count": 2,
                                  "match": 0,
                                  "match_count": 0,
                                  "create_weight": 185215,
                                  "create_weight_count": 1,
                                  "build_scorer": 112551,
                                  "build_scorer_count": 1,
                                  "advance": 0,
                                  "advance_count": 0
                               }
                            }
                         ],
                         "rewrite_time": 7208,
                         "collector": [
                            {
                               "name": "MultiCollector",
                               "reason": "search_multi",
                               "time": "1.378943000ms",
                               "time_in_nanos": "1378943",
                               "children": [
                                  {
                                     "name": "FilteredCollector",
                                     "reason": "search_post_filter",
                                     "time": "0.4036590000ms",
                                     "time_in_nanos": "403659",
                                     "children": [
                                        {
                                           "name": "SimpleTopScoreDocCollector",
                                           "reason": "search_top_hits",
                                           "time": "0.006391000000ms",
                                           "time_in_nanos": "6391"
                                        }
                                     ]
                                  },
                                  {
                                     "name": "BucketCollector: [[non_global_term, another_agg]]",
                                     "reason": "aggregation",
                                     "time": "0.9546020000ms",
                                     "time_in_nanos": "954602"
                                  }
                               ]
                            }
                         ]
                      },
                      {
                         "query": [
                            {
                               "type": "MatchAllDocsQuery",
                               "description": "*:*",
                               "time": "0.04829300000ms",
                               "time_in_nanos": "48293",
                               "breakdown": {
                                  "score": 0,
                                  "score_count": 1,
                                  "next_doc": 3672,
                                  "next_doc_count": 2,
                                  "match": 0,
                                  "match_count": 0,
                                  "create_weight": 6311,
                                  "create_weight_count": 1,
                                  "build_scorer": 38310,
                                  "build_scorer_count": 1,
                                  "advance": 0,
                                  "advance_count": 0
                               }
                            }
                         ],
                         "rewrite_time": 1067,
                         "collector": [
                            {
                               "name": "GlobalAggregator: [global_agg]",
                               "reason": "aggregation_global",
                               "time": "0.1226310000ms",
                               "time_in_nanos": "122631"
                            }
                         ]
                      }
                   ]
                }
             ]
          }
    }

As you can see, the output is significantly verbose from before. All the major portions of the query are represented:

  1. The first `TermQuery` (message:search) represents the main `term` query 
  2. The second `TermQuery` (my_field:foo) represents the `post_filter` query 
  3. There is a `MatchAllDocsQuery` (*:*) query which is being executed as a second, distinct search. This was not part of the query specified by the user, but is auto-generated by the global aggregation to provide a global query scope 



The Collector tree is fairly straightforward, showing how a single MultiCollector wraps a FilteredCollector to execute the post_filter (and in turn wraps the normal scoring SimpleCollector), a BucketCollector to run all scoped aggregations. In the MatchAll search, there is a single GlobalAggregator to run the global aggregation.

### Understanding MultiTermQuery output

A special note needs to be made about the `MultiTermQuery` class of queries. This includes wildcards, regex and fuzzy queries. These queries emit very verbose responses, and are not overly structured.

Essentially, these queries rewrite themselves on a per-segment basis. If you imagine the wildcard query `b*`, it technically can match any token that begins with the letter "b". It would be impossible to enumerate all possible combinations, so Lucene rewrites the query in context of the segment being evaluated. E.g. one segment may contain the tokens `[bar, baz]`, so the query rewrites to a BooleanQuery combination of "bar" and "baz". Another segment may only have the token `[bakery]`, so query rewrites to a single TermQuery for "bakery".

Due to this dynamic, per-segment rewriting, the clean tree structure becomes distorted and no longer follows a clean "lineage" showing how one query rewrites into the next. At present time, all we can do is apologize, and suggest you collapse the details for that query’s children if it is too confusing. Luckily, all the timing statistics are correct, just not the physical layout in the response, so it is sufficient to just analyze the top-level MultiTermQuery and ignore it’s children if you find the details too tricky to interpret.

Hopefully this will be fixed in future iterations, but it is a tricky problem to solve and still in-progress :)
