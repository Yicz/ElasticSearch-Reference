## 匹配查询 Match Query

`match`接受text/numerics/dates类型的参数, 进行分析和构造一个查询，例如：
    
    GET /_search
    {
        "query": {
            "match" : {
                "message" : "this is a test"
            }
        }
    }

提示, `message` 字段的名字,你可以使用`_all`对文档的全部字段进行查询

### 匹配 match

`match` 查询是一个真假值类型。意味着它对提供文本进行分析并进行构造一个真假值类型的查询。`operator`可以设置为`or`或者`and`进行控制`boolean`类型的语句进行连接操作(默认为`or`)。可以使用[`minimum_should_match`](query-dsl-minimum-should-match.html)参数来设置匹配的最少数量的可选`should`子句。

`analyzer`参数可以设置处理全文要分析的分析器。默认使用`mapping`中的定义或默认的查询分析器。

`lenient`参数可以设置成`true`来忽略类所类型不匹配的异常。例如在一个数值类型的字段使用字符串的参数，默认是`false`

#### 模糊查询 Fuzziness

`fuzziness` 参数可以 _模糊匹配_ 被查询的字段的类型。请参阅[模糊设置允许的设置]。

The `prefix_length` and `max_expansions` can be set in this case to control the fuzzy process. If the fuzzy option is set the query will use `top_terms_blended_freqs_${max_expansions}` as its [rewrite method](query-dsl-multi-term-rewrite.html) the `fuzzy_rewrite` parameter allows to control how the query will get rewritten.

Fuzzy transpositions (`ab` → `ba`) are allowed by default but can be disabled by setting `fuzzy_transpositions` to `false`.

以下是提供附加参数的示例（注意结构略有变化，message是字段名称）：
    
    
    GET /_search
    {
        "query": {
            "match" : {
                "message" : {
                    "query" : "this is a test",
                    "operator" : "and"
                }
            }
        }
    }

#### Zero terms query

分析器如果在`stop`过滤阶段把查询的字符进行了全部过滤，则默认不再匹配任何文档。除非启用了`zero_terms_query`选项。参数是`none`(默认)或`all`匹配所有文档（跟`match_all`效果一致）。
    
    GET /_search
    {
        "query": {
            "match" : {
                "message" : {
                    "query" : "to be or not to be",
                    "operator" : "and",
                    "zero_terms_query": "all"
                }
            }
        }
    }

#### 截止频率 Cutoff frequency

匹配查询支持`cutoff_frequency`，它允许指定绝对或相对的文档频率，其中高频词条被移入可选的子查询中，并且仅在`or`的情况下低频（低于截止频率）操作符或所有的低频项在`and`操作符匹配的情况下。

The match query supports a `cutoff_frequency` that allows specifying an absolute or relative document frequency where high frequency terms are moved into an optional subquery and are only scored if one of the low frequency (below the cutoff) terms in the case of an `or` operator or all of the low frequency terms in the case of an `and` operator match.

这个查询允许在运行时动态地处理`stopwords`，是域独立的，不需要`stopword`文件。 它防止评分/迭代高频项，并且只有在更重要/更低的频率项匹配文档时才考虑这些项。 然而，如果所有查询条件都高于给定的`cutoff_frequency`，则查询会自动转换为纯连接（`and`）查询以确保快速执行。


`cutoff_frequency`可以是相对于文件总数（如果在[0..1]范围内），或者绝对值大于或等于'1.0'。

下面是一个显示仅由停用词组成的查询的示例：    
    
    GET /_search
    {
        "query": {
            "match" : {
                "message" : {
                    "query" : "to be or not to be",
                    "cutoff_frequency" : 0.001
                }
            }
        }
    }

![Important](/images/icons/important.png)

`cutoff_frequency`选项按分片级别运行。 这意味着，当试用低文档数的测试索引时，应该按照[Relevance is broken](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/relevance-is-broken.html)中的建议.

 **query_string vs field**

查询匹配族不通过`查询解析`过程。 它不支持字段名称前缀，通配符或其他“高级”功能。 由于这个原因，失败的几率很小/不存在，并且在分析和运行文本作为查询行为时（这通常是文本搜索框的功能），它提供了一个很好的行为。 另外，`phrase_prefix`类型可以提供很好的"像你输入"行为来自动加载搜索结果。
