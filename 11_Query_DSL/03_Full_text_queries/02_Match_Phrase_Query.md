## 匹配词组查询 Match Phrase Query

 `match_phrase` 分析文本并创建`phrase` ，例如:
    
    
    GET /_search
    {
        "query": {
            "match_phrase" : {
                "message" : "this is a test"
            }
        }
    }

短语查询以任意顺序匹配到可配置的“slop”（默认为0）。 换位术语的斜率为2。

可以设置`analyzer`来控制哪个分析器将对文本执行分析过程。 它默认为字段显式映射定义或默认搜索分析器，例如：

A phrase query matches terms up to a configurable `slop` (which defaults to 0) in any order. Transposed terms have a slop of 2.

    
    
    GET /_search
    {
        "query": {
            "match_phrase" : {
                "message" : {
                    "query" : "this is a test",
                    "analyzer" : "my_analyzer"
                }
            }
        }
    }
