## 常用词条查询 Common Terms Query

`common`词条查询是停用词的现代替代方法，它可以在不牺牲性能的情况下提高搜索结果的准确度和召回率（通过使用停用词）。

#### 问题 The problem

查询中的每个词条都有消耗。 搜索`"The brown fox"`需要三个查询，分别针对`"the"`, `"brown"` 和 `"fox"`，这些查询全部针对索引中的所有文档执行。 对于`“the”`的查询很可能与许多文档相匹配，因此对相关性的影响要比其他两个条款小得多。

以前，解决这个问题的办法是忽略高频词汇。 通过将`the`作为_stopword(停用词)_来对待`，我们减少了索引的大小，减少了需要执行的词条查询的数量。

这种方法的问题在于，尽管停用词对相关性影响不大，但仍然很重要。 如果我们删除了停用词，我们就失去了精确度（例如，我们无法区分“快乐”和“不快乐”），并且我们失去了数据（例如像`"The The"`或`"To be or not to be"`会不存储在索引中）。

#### 解决办法 The solution

`common`词条查询将查询术语分成两组：更重要的（即_低频_项）和不太重要的（即_高频术语，其以前是停用词）。

首先搜索与更重要的词条匹配的文档。 这些词条出现在更少的文件中，对相关性有更大的影响。

然后，对不太重要的术语执行第二个查询 - 术语频繁出现，对相关性影响小。 但不是计算**所有**匹配文档的相关性分数，只计算已经与第一个查询匹配的文档的“_score”。 这样，高频项可以改善相关性计算，而不需要消耗性能。

如果一个查询只包含高频项，那么一个查询就是一个“AND”（联合）查询，换句话说，所有的项都是必需的。 即使每个单词与许多文档相匹配，术语的组合也将结果集缩小到最相关的范围。 单个查询也可以作为具有特定[`minimum_should_match`](query-dsl-minimum-should-match.html)的`OR`执行，在这种情况下可能应该使用足够高的值。

词条根据`cutoff_frequency`分配给高频率或低频率组，频率可以被指定为绝对频率（`> = 1`）或相对频率（`0.0..1.0`）。 （请记住，文档频率是根据博客文章[相关性被破坏](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/relevance-is-broken.html)中所解释的每个分片级别来计算的）

也许这个查询最有趣的属性是它自动适应域特定的停用词。 例如，在视频托管网站上，像“`"clip"` 或`"video"`这样的常用词条将自动表现为停用词，而不需要维护手册列表。

#### 案例 Examples

在这个例子中，文档频率大于0.1％（例如`"this"` 和 `"is"`）的单词将被视为常用词条（common terms）。

    GET /_search
    {
        "query": {
            "common": {
                "body": {
                    "query": "this is bonsai cool",
                        "cutoff_frequency": 0.001
                }
            }
        }
    }


 [`minimum_should_match`](query-dsl-minimum-should-match.html) (`high_freq`, `low_freq`), `low_freq_operator` (默认 `"or"`) and `high_freq_operator` (默认 `"or"`) 参数控制词条匹配的数量.

如下低频词条，设置`low_freq_operator: "and"`全部分词条都要匹配
    
    GET /_search
    {
        "query": {
            "common": {
                "body": {
                    "query": "nelly the elephant as a cartoon",
                        "cutoff_frequency": 0.001,
                        "low_freq_operator": "and"
                }
            }
        }
    }

等价于如下的请求:
    
    GET /_search
    {
        "query": {
            "bool": {
                "must": [
                { "term": { "body": "nelly"} },
                { "term": { "body": "elephant"} },
                { "term": { "body": "cartoon"} }
                ],
                "should": [
                { "term": { "body": "the"} },
                { "term": { "body": "as"} },
                { "term": { "body": "a"} }
                ]
            }
        }
    }

或者使用[`minimum_should_match`](query-dsl-minimum-should-match.html) 来指定必须存在的低频词的最小数量或百分比，例如：
    
    GET /_search
    {
        "query": {
            "common": {
                "body": {
                    "query": "nelly the elephant as a cartoon",
                    "cutoff_frequency": 0.001,
                    "minimum_should_match": 2
                }
            }
        }
    }

等价于如下的请求:
    
    
    GET /_search
    {
        "query": {
            "bool": {
                "must": {
                    "bool": {
                        "should": [
                        { "term": { "body": "nelly"} },
                        { "term": { "body": "elephant"} },
                        { "term": { "body": "cartoon"} }
                        ],
                        "minimum_should_match": 2
                    }
                },
                "should": [
                    { "term": { "body": "the"} },
                    { "term": { "body": "as"} },
                    { "term": { "body": "a"} }
                    ]
            }
        }
    }

最小匹配值 minimum_should_match

一个不同的[`minimum_should_match`](query-dsl-minimum-should-match.html)可以应用于低频和高频项，并增加`low_freq`和`high_freq`参数。 以下是提供附加参数的示例（请注意结构的变化）：
    
    GET /_search
    {
        "query": {
            "common": {
                "body": {
                    "query": "nelly the elephant not as a cartoon",
                        "cutoff_frequency": 0.001,
                        "minimum_should_match": {
                            "low_freq" : 2,
                            "high_freq" : 3
                        }
                }
            }
        }
    }

等价于如下的请求:
    
    GET /_search
    {
        "query": {
            "bool": {
                "must": {
                    "bool": {
                        "should": [
                        { "term": { "body": "nelly"} },
                        { "term": { "body": "elephant"} },
                        { "term": { "body": "cartoon"} }
                        ],
                        "minimum_should_match": 2
                    }
                },
                "should": {
                    "bool": {
                        "should": [
                        { "term": { "body": "the"} },
                        { "term": { "body": "not"} },
                        { "term": { "body": "as"} },
                        { "term": { "body": "a"} }
                        ],
                        "minimum_should_match": 3
                    }
                }
            }
        }
    }

在这种情况下，这意味着高频词至少有三个词只对相关性有影响。 但是，对于高频项而言，[`minimum_should_match`](query-dsl-minimum-should-match.html) 最有趣的是只有高频项有效：

    GET /_search
    {
        "query": {
            "common": {
                "body": {
                    "query": "how not to be",
                        "cutoff_frequency": 0.001,
                        "minimum_should_match": {
                            "low_freq" : 2,
                            "high_freq" : 3
                        }
                }
            }
        }
    }


等价于如下的请求:
    
    
    GET /_search
    {
        "query": {
            "bool": {
                "should": [
                { "term": { "body": "how"} },
                { "term": { "body": "not"} },
                { "term": { "body": "to"} },
                { "term": { "body": "be"} }
                ],
                "minimum_should_match": "3<50%"
            }
        }
    }

与“AND”相比，高频生成的查询限制性稍少。

通用词条查询也支持`boost`，`analyzer`和`disable_coord`作为参数。