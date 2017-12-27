## 多词条向量API Multi termvectors API

多个词条向量API允许一次获取多个词条向量。 从中检索词条向量的文档由索引，类型和ID指定。 但是文档也可以在请求体中人为地提供。


响应内容包括一个带有所有提取的词条向量的docs数组，每个数据元素都有由[termvectors](docs-termvectors.html)API提供的结构。 这里是一个例子： 
    
    POST /_mtermvectors
    {
       "docs": [
          {
             "_index": "twitter",
             "_type": "tweet",
             "_id": "2",
             "term_statistics": true
          },
          {
             "_index": "twitter",
             "_type": "tweet",
             "_id": "1",
             "fields": [
                "message"
             ]
          }
       ]
    }

请参阅[termvectors](docs-termvectors.html)API以获取可用参数的说明。
`_mtermvectors`API也可以用于索引（在这种情况下，它不是必需的）：    
    
    POST /twitter/_mtermvectors
    {
       "docs": [
          {
             "_type": "tweet",
             "_id": "2",
             "fields": [
                "message"
             ],
             "term_statistics": true
          },
          {
             "_type": "tweet",
             "_id": "1"
          }
       ]
    }

还有文档类型:
    
    
    POST /twitter/tweet/_mtermvectors
    {
       "docs": [
          {
             "_id": "2",
             "fields": [
                "message"
             ],
             "term_statistics": true
          },
          {
             "_id": "1"
          }
       ]
    }

如果所有请求的文档都是相同的索引并且具有相同的类型，并且参数相同，则可以简化请求：
    
    POST /twitter/tweet/_mtermvectors
    {
        "ids" : ["1", "2"],
        "parameters": {
            "fields": [
                    "message"
            ],
            "term_statistics": true
        }
    }

此外，就像[termvectors](docs-termvectors.html)API一样，可以为用户提供的文档即时生成词条向量。 使用的映射是由`_index`和`_type`决定的。    
    
    POST /_mtermvectors
    {
       "docs": [
          {
             "_index": "twitter",
             "_type": "tweet",
             "doc" : {
                "user" : "John Doe",
                "message" : "twitter test test test"
             }
          },
          {
             "_index": "twitter",
             "_type": "test",
             "doc" : {
               "user" : "Jane Doe",
               "message" : "Another twitter test ..."
             }
          }
       ]
    }
