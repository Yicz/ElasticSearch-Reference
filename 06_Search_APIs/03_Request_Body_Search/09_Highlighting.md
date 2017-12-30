## 高亮 Highlighting

允许高亮显示一个或多个字段的搜索结果。 这个实现使用了lucene的普通高亮器，快速向量高亮器（`fvh`）或者`postings`高亮器。 以下是搜索请求主体的示例：
    
    GET /_search
    {
        "query" : {
            "match": { "content": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {}
            }
        }
    }

在上面的例子中，对于每个搜索命文档中，`content`字段将被高亮显示（每个搜索命中文档将有另一个元素，称为`高亮`，其中包括高亮显示的字段和高亮显示的片段）。

![Note](/images/icons/note.png)

为了执行高亮显示，该字段的实际内容是必需的。 如果有问题的字段被存储（在映射中`store`设置为`true`），将被使用，否则，实际的`_source`将被加载，相关字段将被提取。

`_all`字段不能从`_source`中提取，所以只能用来高亮显示它是否被映射为`store`设置为`true`。


该字段名称支持通配符表示法。 例如，使用`comment_*`将导致匹配表达式的所有[text](text.html)和[keyword](keyword.html)字段（和[string](string.html)高亮显示。 请注意，所有其他字段将不会高亮显示。 如果使用自定义映射器，并且想要在字段上高亮显示，则必须明确提供字段名称。

### 普通高亮器 Plain highlighter高亮器的默认选择是“普通"类型，并使用Lucene高亮器。 在词组查询中，从理解单词重要性和词义定位的角度出发，努力体现查询匹配逻辑。
![Warning](/images/icons/warning.png)

如果你想在许多复杂查询的文档中高亮显示很多字段，这个高亮器不会很快。为了准确地反映查询逻辑，它创建了一个微小的内存中索引，并通过Lucene的查询执行计划器重新运行原始查询条件，以访问当前文档上的低级匹配信息。每个字段和每个需要高亮显示的文档都会重复此操作。如果在系统中出现性能问题，请考虑使用替换高亮器。


### Postings highlighter

如果在映射中将`index_options`设置为偏移量`offsets`，则将使用`postings`高亮显示而不是`plain`的高亮显示。 `postings`高亮器：

* 更快，因为它不需要重新分析要高亮显示的文本：文档越大性能增益越好
* 需要比`term_vectors`更少的磁盘空间，这是快速向量高亮器所需要的
* 将文本分解为句子并高亮显示。 和自然语言一起处理真的很好，而不是像包含html标记的字段
* 将文档视为整个语料库，并使用`BM25`算法对单个语句进行评分，就好像它们是该语料库中的文档一样

以下是在索引映射中设置`content`字段的示例，以允许使用其上的高亮标记进行高亮显示：    
    
    PUT /example
    {
      "mappings": {
        "doc" : {
          "properties": {
            "comment" : {
              "type": "text",
              "index_options" : "offsets"
            }
          }
        }
      }
    }

![Note](/images/icons/note.png)

请注意，`postings`高亮器旨在执行简单的查询条件高亮显示，无论其位置。这意味着，当与例如短语查询结合使用时，它将高亮显示查询所组成的所有项，而不管它们是否实际上是查询匹配的一部分，从而有效地忽略它们的位置。

![Warning](/images/icons/warning.png)

`postings`高亮显示不支持高亮显示一些复杂的查询，比如`type`设置为`match_phrase_prefix`的`match`查询。 在这种情况下，将不会返回高亮显示的片段。

### 快速向量高亮 Fast vector highlighter

如果通过在映射中将`term_vector`设置为`with_positions_offsets`来提供`term_vector`信息，则将使用快速向量高亮器而不是普通(`plain`)高亮器。 快速向量高亮器：

   * 特别是对于大字段更快（> 1MB）
   * 可以使用`boundary_scanner`进行定制（参见[below](search-request-highlighting.html#boundary-scanners)）
   * 需要将`term_vector`设置为'with_positions_offsets`，这会增加索引的大小
   * 可以将来自多个字段的匹配合并成一个结果。 参见`matched_fields`
   * 可以分配不同的权重匹配不同的位置，允许像词组匹配高于词条匹配时，高亮显示一个Boosting查询，提高词条匹配相对词条匹配



下面是一个设置'content'字段的例子，它允许使用快速向量高亮显示来高亮显示（这会导致索引变大）：
    
    PUT /example
    {
      "mappings": {
        "doc" : {
          "properties": {
            "comment" : {
              "type": "text",
              "term_vector" : "with_positions_offsets"
            }
          }
        }
      }
    }

### Unified Highlighter

![Warning](/images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

The `unified` highlighter can extract offsets from either postings, term vectors, or via re-analyzing text. Under the hood it uses Lucene UnifiedHighlighter which picks its strategy depending on the field and the query to highlight. Independently of the strategy this highlighter breaks the text into sentences and scores individual sentences as if they were documents in this corpus, using the BM25 algorithm. It supports accurate phrase and multi-term (fuzzy, prefix, regex) highlighting and can be used with the following options:

  * `force_source`
  * `encoder`
  * `highlight_query`
  * `pre_tags and `post_tags`
  * `require_field_match`
  * `boundary_scanner` (`sentence` ( **default** ) or `word`) 
  * `max_fragment_length` (only for `sentence` scanner) 
  * `no_match_size`



### Force highlighter type


`type`字段允许强制使用特定的高亮器类型。 这对于需要在启用了`term_vectors`的字段上使用普通高亮器时非常有用。 允许的值是：`plain`，`postings`和`fvh`。 以下是强制使用普通高亮器的例子：
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {"type" : "plain"}
            }
        }
    }

### Force highlighting on source

即使字段单独存储，也会强制高亮显示基于`source`的字段。 默认为`false`。
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {"force_source" : true}
            }
        }
    }

### Highlighting Tags

默认情况下，高亮显示将在`<em>`和`</ em>`中包装高亮显示的文本。 这可以通过设置`pre_tags`和`post_tags`来控制，例如：
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "pre_tags" : ["<tag1>"],
            "post_tags" : ["</tag1>"],
            "fields" : {
                "_all" : {}
            }
        }
    }

使用快速向量高亮器可以有更多的标签，并且重要是有序的。
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "pre_tags" : ["<tag1>", "<tag2>"],
            "post_tags" : ["</tag1>", "</tag2>"],
            "fields" : {
                "_all" : {}
            }
        }
    }

还有一些内置的`标签 tags`模式，目前有一个叫`样式 styled`的模式，带有以下`pre_tags`：
    
    
    <em class="hlt1">, <em class="hlt2">, <em class="hlt3">,
    <em class="hlt4">, <em class="hlt5">, <em class="hlt6">,
    <em class="hlt7">, <em class="hlt8">, <em class="hlt9">,
    <em class="hlt10">

和`</ em>`作为`post_tags`。 如果您认为使用标签架构更好，只需将电子邮件发送到邮件列表或打开一个issue。 这是一个切换标签模式的例子：
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "tags_schema" : "styled",
            "fields" : {
                "content" : {}
            }
        }
    }

### 编码器 Encoder

`encoder`参数可以用来定义高亮显示的文本将被编码的方式。 它可以是`default`（无编码）或`html`（如果使用html高亮标签，将会转义html）。

### Highlighted Fragments

高亮显示的每个字段都可以控制高亮显示的片段大小（以字符为单位）（默认值为“100"），并返回片段的最大数量（默认为“5"）。 例如：
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {"fragment_size" : 150, "number_of_fragments" : 3}
            }
        }
    }

使用过`postings`高亮显示时，`fragment_size`被忽略，因为它会输出句子，而不管它们的长度。

除此之外，还可以指定高亮显示的片段需要按分数排序：
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "order" : "score",
            "fields" : {
                "content" : {"fragment_size" : 150, "number_of_fragments" : 3}
            }
        }
    }

如果`number_of_fragments`值被设置为'0'，则不产生片段，而是返回该字段的全部内容，当然它被高亮显示。如果短文本（如文档标题或地址）需要高亮显示，但不需要分片，这可以非常方便。 请注意，在这种情况下，`fragment_size`被忽略。
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "_all" : {},
                "bio.title" : {"number_of_fragments" : 0}
            }
        }
    }

当使用`fvh`时，可以使用`fragment_offset`参数来控制边距从高亮开始。

在没有匹配的片段高亮的情况下，默认是不返回任何东西。 相反，我们可以通过将`no_match_size`（默认为`0`）设置为您希望返回的文本的长度来从字段开头返回一段文本。 实际的长度可能比指定的更短或更长，因为它试图打破一个字边界。 当使用张贴高亮显示器时，无法控制片段的实际大小，因此，只要`no_match_size`大于'0'，就会返回第一个句子。

    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {
                    "fragment_size" : 150,
                    "number_of_fragments" : 3,
                    "no_match_size": 150
                }
            }
        }
    }

### Fragmenter

段处理器可以控制如何在高亮片段中分解文本。 但是，此选项仅适用于普通高亮器。 有两个选项：

`simple`| 将文本分解成相同大小的片段。     
---|---    
`span`| 和简单的段处理器一样，但是尽量不要在高亮显示的词语之间分解文本（这适用于使用类似查询的短语时）。 这是默认。
    
    GET twitter/tweet/_search
    {
        "query" : {
            "match_phrase": { "message": "number 1" }
        },
        "highlight" : {
            "fields" : {
                "message" : {
                    "fragment_size" : 15,
                    "number_of_fragments" : 3,
                    "fragmenter": "simple"
                }
            }
        }
    }

响应:
    
    
    {
        ...
        "hits": {
            "total": 1,
            "max_score": 1.4818809,
            "hits": [
                {
                    "_index": "twitter",
                    "_type": "tweet",
                    "_id": "1",
                    "_score": 1.4818809,
                    "_source": {
                        "user": "test",
                        "message": "some message with the number 1",
                        "date": "2009-11-15T14:12:12",
                        "likes": 1
                    },
                    "highlight": {
                        "message": [
                            " with the <em>number</em>",
                            " <em>1</em>"
                        ]
                    }
                }
            ]
        }
    }
    
    
    GET twitter/tweet/_search
    {
        "query" : {
            "match_phrase": { "message": "number 1" }
        },
        "highlight" : {
            "fields" : {
                "message" : {
                    "fragment_size" : 15,
                    "number_of_fragments" : 3,
                    "fragmenter": "span"
                }
            }
        }
    }

响应:
    
    
    {
        ...
        "hits": {
            "total": 1,
            "max_score": 1.4818809,
            "hits": [
                {
                    "_index": "twitter",
                    "_type": "tweet",
                    "_id": "1",
                    "_score": 1.4818809,
                    "_source": {
                        "user": "test",
                        "message": "some message with the number 1",
                        "date": "2009-11-15T14:12:12",
                        "likes": 1
                    },
                    "highlight": {
                        "message": [
                            "some message with the <em>number</em> <em>1</em>"
                        ]
                    }
                }
            ]
        }
    }

如果`number_of_fragments`选项设置为“0"，则使用`NullFragmenter`，它根本不分片文本。 这对于高亮显示文档或字段的全部内容非常有用。

### Highlight query

也可以通过设置`highlight_query`来高亮显示与搜索查询不同的查询。 如果您使用重新查询，这是特别有用的，因为默认情况下不会考虑这些查询。 Elasticsearch不会验证`highlight_query`包含任何方式的搜索查询，所以可以定义它，因此合法的查询结果根本不被高亮显示。 通常，将搜索查询包含在`highlight_query`中会更好。 这是一个在`highlight_query`中包含搜索查询和rescore查询的例子。
    
    GET /_search
    {
        "stored_fields": [ "_id" ],
        "query" : {
            "match": {
                "content": {
                    "query": "foo bar"
                }
            }
        },
        "rescore": {
            "window_size": 50,
            "query": {
                "rescore_query" : {
                    "match_phrase": {
                        "content": {
                            "query": "foo bar",
                            "slop": 1
                        }
                    }
                },
                "rescore_query_weight" : 10
            }
        },
        "highlight" : {
            "order" : "score",
            "fields" : {
                "content" : {
                    "fragment_size" : 150,
                    "number_of_fragments" : 3,
                    "highlight_query": {
                        "bool": {
                            "must": {
                                "match": {
                                    "content": {
                                        "query": "foo bar"
                                    }
                                }
                            },
                            "should": {
                                "match_phrase": {
                                    "content": {
                                        "query": "foo bar",
                                        "slop": 1,
                                        "boost": 10.0
                                    }
                                }
                            },
                            "minimum_should_match": 0
                        }
                    }
                }
            }
        }
    }

请注意，在这种情况下，文本片段的分数是由Lucene高亮显示框架计算的。 有关实现细节，您可以检查`ScoreOrderFragmentsBuilder`类。 另一方面，当使用`postings`高亮标记时，如上所述，使用BM25算法对片段进行评分。

### Global Settings

高亮显示设置可以在全局级别上进行设置，然后在字段级别进行覆盖。    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "number_of_fragments" : 3,
            "fragment_size" : 150,
            "fields" : {
                "_all" : { "pre_tags" : ["<em>"], "post_tags" : ["</em>"] },
                "bio.title" : { "number_of_fragments" : 0 },
                "bio.author" : { "number_of_fragments" : 0 },
                "bio.content" : { "number_of_fragments" : 5, "order" : "score" }
            }
        }
    }

### Require Field Match

可以将`require_field_match`设置为`false`，这将导致任何字段高亮显示，而不管查询是否与它们特别匹配。 默认行为是“true"，这意味着只有持有查询匹配的字段才会被高亮显示。
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "require_field_match": false,
            "fields": {
                    "_all" : { "pre_tags" : ["<em>"], "post_tags" : ["</em>"] }
            }
        }
    }

### Boundary Scanners

当使用统一的高亮器或快速向量高亮器高亮显示一个字段时，您可以指定如何使用“boundary_scanner"来分割高亮显示的片段，该接受以下值：


  * `chars` （FVH的默认模式）：允许配置哪些字符（`boundary_chars`）构成高亮显示的边界。 它是一个单一的字符串，其中定义了每个边界字符（默认为`。，！？\ t \ n`）。 它还允许配置`boundary_max_scan`来控制边界字符的多少（默认为`20`）。 只适用于快速向量高亮器。
  * `sentence` and `word`:使用Java的[BreakIterator](https://docs.oracle.com/javase/8/docs/api/java/text/BreakIterator.html)在下一个_sentence_或_word_边界处高亮显示的片段。 您可以进一步指定`boundary_scanner_locale`来控制使用哪个Locale搜索这些边界的文本。



![Note](/images/icons/note.png)

当与"统一"高亮器一起使用时，"句子"扫描器在"fragment_size"旁边的第一个单词边界处分割大于"fragment_size"的句子。 您可以将`fragment_size`设置为0，永不拆分任何句子。

### 匹配字段 Matched Fields

快速向量高亮器可以结合多个字段的匹配，使用`matched_fields`高亮显示单个字段。 对于以不同方式分析相同字符串的多字段，这是最直观的。 所有`matched_fields`都必须将term_vector设置为`with_positions_offsets`，但是只有加入匹配的字段才会被加载，所以只有这个字段才能从`store`设置为`yes`而受益。

在下面的例子中，`content`由`english`分析器分析，`content.plain`由`standard`分析器分析。
    
    
    GET /_search
    {
        "query": {
            "query_string": {
                "query": "content.plain:running scissors",
                "fields": ["content"]
            }
        },
        "highlight": {
            "order": "score",
            "fields": {
                "content": {
                    "matched_fields": ["content", "content.plain"],
                    "type" : "fvh"
                }
            }
        }
    }

上面的比赛都是"run with scissors"和"running with scissors"，突出"running"和"scissors"而不是"run"。如果两个短语都出现在一个大文档中，那么"run with scissors"会在片段列表中的"un with scissors"之上进行排序，因为该片段中有更多的匹配。
    
    
    GET /_search
    {
        "query": {
            "query_string": {
                "query": "running scissors",
                "fields": ["content", "content.plain^10"]
            }
        },
        "highlight": {
            "order": "score",
            "fields": {
                "content": {
                    "matched_fields": ["content", "content.plain"],
                    "type" : "fvh"
                }
            }
        }
    }

上述亮点会根据评分排序。    
    
    GET /_search
    {
        "query": {
            "query_string": {
                "query": "running scissors",
                "fields": ["content", "content.plain^10"]
            }
        },
        "highlight": {
            "order": "score",
            "fields": {
                "content": {
                    "matched_fields": ["content.plain"],
                    "type" : "fvh"
                }
            }
        }
    }

上面的查询不会高亮显示“run"或“scissor"，但是显示只要在匹配的字段中列出匹配组合的字段（`content`）就好了。

![Note](/images/icons/note.png)

从技术角度来说，将字段添加到`matched_fields`中是不错的，因为这些字段与组合匹配的字段不共享相同的基础字符串。 结果可能没有多大意义，如果其中一个匹配结束的文本末尾，那么整个查询将失败。

![Note](/images/icons/note.png)

将`matched_fields`设置为一个非空的数组涉及少量开销，所以总是优先考虑的：
    
    
        "highlight": {
            "fields": {
                "content": {}
            }
        }

变成：
    
    
        "highlight": {
            "fields": {
                "content": {
                    "matched_fields": ["content"],
                    "type" : "fvh"
                }
            }
        }

### 短语限制 Phrase Limit

快速向量高亮器有一个`phrase_limit`参数，防止它分析太多的短语和消耗成吨的内存。 它默认为`256`，所以只考虑文档中前256个匹配的短语。 你可以用`phrase_limit`参数来提高限制，但是记住更多的短语会消耗更多的时间和内存。

如果使用`matched_fields`，请记住每个匹配字段的“phrase_limit"短语被考虑。

### 字段高亮顺序 Field Highlight Order

Elasticsearch按照发送顺序高亮显示这些字段。 按照JSON规范，对象是无序的，但是如果你需要明确地指出字段被高亮显示的顺序，那么你可以像下面这样为`fields`使用一个数组：
    
    
    GET /_search
    {
        "highlight": {
            "fields": [
                { "title": {} },
                { "text": {} }
            ]
        }
    }

Elasticsearch内置的高亮器没有一个关注字段高亮显示的顺序，而一个插件可以会关注。
