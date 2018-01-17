## 匹配词组前缀查询 Match Phrase Prefix Query

`match_phrase_prefix`和`match_phrase`是一样的，不同的是它允许在文本中最后一个词的前缀匹配。 例如：
    
    GET /_search
    {
        "query": {
            "match_phrase_prefix" : {
                "message" : "quick brown f"
            }
        }
    }

它接受与短语类型相同的参数。 另外，它还接受一个`max_expansions`参数（默认为`50`），可以控制最后一个词将被扩展多少个后缀。 强烈建议将其设置为可接受的值以控制查询的执行时间。 例如：
    
    GET /_search
    {
        "query": {
            "match_phrase_prefix" : {
                "message" : {
                    "query" : "quick brown f",
                    "max_expansions" : 10
                }
            }
        }
    }

![Important](/images/icons/important.png)

`match_phrase_prefix`查询是一个自动完成的语句。 它非常易于使用，它可以让您快速开始使用_查询你输入的内容_，其结果通常足够好，但也有时会令人困惑。

考虑查询字符串“quick brown f”。 这个查询的工作原理是用`quick`和`brown`创建一个短语查询（即术语`quick`必须存在，后面必须跟着`brown`）。 然后，它查看已排序的词条字典，以查找以“f”开头的前50个术语，并将这些术语添加到短语查询中。

问题是，前50项可能不包括词条`fox`，所以短语`quick brown fox`将不会被查询到。 这通常不是一个问题，因为用户将继续键入更多的字母，直到他们正在寻找的单词出现。

为更好地解决输入建议，可以参考 [completion suggester](search-suggesters-completion.html) 和 [Index-Time Search-as-You-Type](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/_index_time_search_as_you_type.html).
