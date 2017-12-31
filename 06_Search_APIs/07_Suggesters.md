## 查询建议 Suggesters

建议功能通过使用建议器，根据提供的文本建议类似的外观项。 建议功能的一部分仍在开发中。

建议的请求部分在查询部分的`_search`请求中被定义。

![Note](/images/icons/note.png)

`_suggest`API已被弃用，倾向于通过`_search`API使用建议。 在5.0中，`_search`API已经被优化，仅用于建议搜索请求。
    
    
    POST twitter/_search
    {
      "query" : {
        "match": {
          "message": "tring out Elasticsearch"
        }
      },
      "suggest" : {
        "my-suggestion" : {
          "text" : "trying out Elasticsearch",
          "term" : {
            "field" : "message"
          }
        }
      }
    }

可以为每个请求指定几个建议。 每个建议都以任意名称来标识。 在下面的例子中，需要两个建议。 “my-suggest-1”和“my-suggest-2”这两个建议都使用`term`建议，但是有一个不同的`text`。
    
    
    POST _search
    {
      "suggest": {
        "my-suggest-1" : {
          "text" : "tring out Elasticsearch",
          "term" : {
            "field" : "message"
          }
        },
        "my-suggest-2" : {
          "text" : "kmichy",
          "term" : {
            "field" : "user"
          }
        }
      }
    }

以下建议的响应示例包括对“my-suggest-1”和“my-suggest-2”的建议响应。每个建议部分包含条目。每个条目实际上都是建议文本中的一个标记，并且包含建议条目文本，建议文本中的原始起始偏移量和长度，以及是否存在任意数量的选项。
    
    {
      "_shards": ...
      "hits": ...
      "took": 2,
      "timed_out": false,
      "suggest": {
        "my-suggest-1": [ {
          "text": "tring",
          "offset": 0,
          "length": 5,
          "options": [ {"text": "trying", "score": 0.8, "freq": 1 } ]
        }, {
          "text": "out",
          "offset": 6,
          "length": 3,
          "options": []
        }, {
          "text": "elasticsearch",
          "offset": 10,
          "length": 13,
          "options": []
        } ],
        "my-suggest-2": ...
      }
    }

每个选项数组都包含一个`options`对象，其中包含建议文本，其文档频率和与建议输入文本相比较的得分。 得分的含义取决于使用的建议器（suggester）。 建议器（suggester）分数是基于编辑距离。

### Global suggest text

为了避免重复建议文本，可以定义全局文本。 在下面的示例中，建议文本是全局定义的，适用于“my-suggest-1”和“my-suggest-2”建议。
    
    
    POST _search
    {
      "suggest": {
        "text" : "tring out Elasticsearch",
        "my-suggest-1" : {
          "term" : {
            "field" : "message"
          }
        },
        "my-suggest-2" : {
           "term" : {
            "field" : "user"
           }
        }
      }
    }

建议的文字在上面的例子中也可以被指定为建议特定的选项。 在建议级别上指定的建议文本会覆盖全局级别的建议文本。
