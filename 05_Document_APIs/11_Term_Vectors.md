## 词条向量 Term Vectors 

返回特定文档字段中的信息和统计数据。文档可以存储在索引中或由用户人为提供。词矢量 默认是[实时 realtime](docs-get.html#realtime)，不是近实时的。 这可以通过将`realtime`参数设置为false来改变。    
    
    GET /twitter/tweet/1/_termvectors

或者，您可以使用url中的参数指定要检索信息的字段    
    
    GET /twitter/tweet/1/_termvectors?fields=message

或者通过在请求正文中添加请求的字段（请参见下面的示例）。 也可以使用与[多重匹配查询 multi match query](query-dsl-multi-match-query.html)类似的方式来指定字段

![Warning](/images/icons/warning.png)

请注意，`/ _termvector`的使用在2.0中被弃用，并被替换为`/ _termvectors`。

### 返回值 Return values

可以请求三种类型的值：_term information_，_term statistics_和_field statistics_。 默认情况下，所有字段的所有词信息和字段统计信息都会返回，但是没有任何术语统计。


#### 词信息 Term information

   * 字段中的词频（总是返回）
   * 词的位置（`positions`：true）
   * 开始和结束偏移量（`offsets`：true）
   * term有效载荷（`payloads`：true），是base64编码的字节

如果所请求的信息没有存储在索引中，则将在可能的情况下即时计算。 另外，对于甚至不存在于索引中但是由用户提供的文档也可以计算词矢量。

![Warning](/images/icons/warning.png)

开始和结束偏移假定正在使用UTF-16编码。 如果要使用这些偏移量来获取产生该令牌的原始文本，则应确保使用UTF-16编码的字符串也是使用子字符串编码的。

#### 词条统计信息 Term statistics

将`term_statistics`设置为`true`（默认是`false`）

   *全部词条频率（所有文档中词条的频率）
   *文档频率（包含当前词条的文档数量）

默认情况下，这些值不会被返回，因为词条统计可能会严重地影响性能。

Setting `term_statistics` to `true` (default is `false`) will return


#### Field statistics 字段统计信息

将`field_statistics`设置为`false`（默认是`true`）会省略：

   *文档数量（多少个文档包含这个字段）
   *文档频率总和（该字段中所有术语的文档频率总和）
   *总学期频率总和（该领域每个学期的总学期频率之和）
 
#### 词条过滤 Terms Filtering
使用filter参数，返回的条件也可以根据它们的`tf-idf`分数进行过滤。 这可能是有用的，以便找出一个文档的一个很好的特征向量。 此功能与[More Like This Query](query-dsl-mlt-query.html)中的 [second phase](query-dsl-mlt-query.html#mlt-query-term-selection)。 有关使用情况，请参阅[示例5](docs-termvectors.html#docs-termvectors-terms-filtering)。

支持以下子参数：

`max_num_terms`| 每个字段必须返回的最大词条数。 默认为`25`。     
---|---    
`min_term_freq`| 在源文档中忽略小于这个频率的单词。 默认为`1`。     
`max_term_freq`| 在源文件中忽略超过这个频率的单词。 默认不设置。     
`min_doc_freq`| 忽略至少在这么多文档中没有出现的术语。 默认为`1`。
`max_doc_freq`| 忽略在这么多文档中出现的单词。 默认为不设置。     
`min_word_length`| 低于该字的最小字长将被忽略。 默认为`0`。     
`max_word_length`| 多于该字的最大字长将被忽略。 默认为`0`即无界。   
  
### 行为 Behaviour

词条和字段的统计并不精确。 原因是删除的文件不被考虑在内。这些信息仅仅是被请求文档所在分片的检索信息。因此，词条和字段统计信息仅作为相对参考值使用，而绝对值在这种情况下没有意义。 默认情况下，当请求人工文档的词条向量时，随机选择一个从中获取统计信息的分片。 使用`routing`只会找特定的分片。

####示例：返回存储的词条向量 Returning stored term vectors

首先，我们创建一个存储词条向量，有效载荷等的索引：
    
    PUT /twitter/
    { "mappings": {
        "tweet": {
          "properties": {
            "text": {
              "type": "text",
              "term_vector": "with_positions_offsets_payloads",
              "store" : true,
              "analyzer" : "fulltext_analyzer"
             },
             "fullname": {
              "type": "text",
              "term_vector": "with_positions_offsets_payloads",
              "analyzer" : "fulltext_analyzer"
            }
          }
        }
      },
      "settings" : {
        "index" : {
          "number_of_shards" : 1,
          "number_of_replicas" : 0
        },
        "analysis": {
          "analyzer": {
            "fulltext_analyzer": {
              "type": "custom",
              "tokenizer": "whitespace",
              "filter": [
                "lowercase",
                "type_as_payload"
              ]
            }
          }
        }
      }
    }

步骤二，我们添加一些文档:
    
    
    PUT /twitter/tweet/1
    {
      "fullname" : "John Doe",
      "text" : "twitter test test test "
    }
    
    PUT /twitter/tweet/2
    {
      "fullname" : "Jane Doe",
      "text" : "Another twitter test ..."
    }

下面的请求返回文档'1'（John Doe）中字段“text”的所有信息和统计信息：    
    
    GET /twitter/tweet/1/_termvectors
    {
      "fields" : ["text"],
      "offsets" : true,
      "payloads" : true,
      "positions" : true,
      "term_statistics" : true,
      "field_statistics" : true
    }

响应:
    
    {
        "_id": "1",
        "_index": "twitter",
        "_type": "tweet",
        "_version": 1,
        "found": true,
        "took": 6,
        "term_vectors": {
            "text": {
                "field_statistics": {
                    "doc_count": 2,
                    "sum_doc_freq": 6,
                    "sum_ttf": 8
                },
                "terms": {
                    "test": {
                        "doc_freq": 2,
                        "term_freq": 3,
                        "tokens": [
                            {
                                "end_offset": 12,
                                "payload": "d29yZA==",
                                "position": 1,
                                "start_offset": 8
                            },
                            {
                                "end_offset": 17,
                                "payload": "d29yZA==",
                                "position": 2,
                                "start_offset": 13
                            },
                            {
                                "end_offset": 22,
                                "payload": "d29yZA==",
                                "position": 3,
                                "start_offset": 18
                            }
                        ],
                        "ttf": 4
                    },
                    "twitter": {
                        "doc_freq": 2,
                        "term_freq": 1,
                        "tokens": [
                            {
                                "end_offset": 7,
                                "payload": "d29yZA==",
                                "position": 0,
                                "start_offset": 0
                            }
                        ],
                        "ttf": 2
                    }
                }
            }
        }
    }

#### 示例：实时计算词条向量 Example: Generating term vectors on the fly

未明确存储在索引中的词条向量将会实时计算。 以下请求将返回文档“1”中所有字段的信息和统计信息，即使这些字词尚未明确存储在索引中。 请注意，对于字段`text`，这些词条不会重新生成。
    
    GET /twitter/tweet/1/_termvectors
    {
      "fields" : ["text", "some_field_without_term_vectors"],
      "offsets" : true,
      "positions" : true,
      "term_statistics" : true,
      "field_statistics" : true
    }

#### 示例: 人工提供文档 Artificial documents

词条向量也可以为人造文档生成，也就是说文档不存在于索引中。 例如，以下请求将返回与示例1相同的结果。使用的映射由`index`和`type`确定。

**如果动态映射处于打开状态（默认），将不会动态创建原始映射中的文档字段。**
    
    GET /twitter/tweet/_termvectors
    {
      "doc" : {
        "fullname" : "John Doe",
        "text" : "twitter test test test"
      }
    }

##### 字段分析器 Per-field analyzer
另外，通过使用`per_field_analyzer`参数可以提供不同的分析器。 这对于以任何方式生成词条向量都很有用，特别是在使用人造文档时。 当为已经存储了词条向量的字段提供分析器时，词条向量将被重新生成。
    
    GET /twitter/tweet/_termvectors
    {
      "doc" : {
        "fullname" : "John Doe",
        "text" : "twitter test test test"
      },
      "fields": ["fullname"],
      "per_field_analyzer" : {
        "fullname": "keyword"
      }
    }

响应:
    
    
    {
      "_index": "twitter",
      "_type": "tweet",
      "_version": 0,
      "found": true,
      "took": 6,
      "term_vectors": {
        "fullname": {
           "field_statistics": {
              "sum_doc_freq": 2,
              "doc_count": 4,
              "sum_ttf": 4
           },
           "terms": {
              "John Doe": {
                 "term_freq": 1,
                 "tokens": [
                    {
                       "position": 0,
                       "start_offset": 0,
                       "end_offset": 8
                    }
                 ]
              }
           }
        }
      }
    }

#### 示例：词条过滤 Terms filtering

最后，返回的条款可以根据他们的`tf-idf`分数进行过滤。 在下面的例子中，我们从具有给定`plot`字段值的人造文档中获得三个最`interesting`的关键字。 请注意，关键字`Tony`或任何停用词不是响应的一部分，因为它们的`tf-idf`太低。
    
    GET /imdb/movies/_termvectors
    {
        "doc": {
          "plot": "When wealthy industrialist Tony Stark is forced to build an armored suit after a life-threatening incident, he ultimately decides to use its technology to fight against evil."
        },
        "term_statistics" : true,
        "field_statistics" : true,
        "positions": false,
        "offsets": false,
        "filter" : {
          "max_num_terms" : 3,
          "min_term_freq" : 1,
          "min_doc_freq" : 1
        }
    }

响应:
    
    
    {
       "_index": "imdb",
       "_type": "movies",
       "_version": 0,
       "found": true,
       "term_vectors": {
          "plot": {
             "field_statistics": {
                "sum_doc_freq": 3384269,
                "doc_count": 176214,
                "sum_ttf": 3753460
             },
             "terms": {
                "armored": {
                   "doc_freq": 27,
                   "ttf": 27,
                   "term_freq": 1,
                   "score": 9.74725
                },
                "industrialist": {
                   "doc_freq": 88,
                   "ttf": 88,
                   "term_freq": 1,
                   "score": 8.590818
                },
                "stark": {
                   "doc_freq": 44,
                   "ttf": 47,
                   "term_freq": 1,
                   "score": 9.272792
                }
             }
          }
       }
    }
