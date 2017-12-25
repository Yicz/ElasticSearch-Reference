## Suggesters

The suggest feature suggests similar looking terms based on a provided text by using a suggester. Parts of the suggest feature are still under development.

The suggest request part is defined alongside the query part in a `_search` request.

![Note](images/icons/note.png)

`_suggest` endpoint has been deprecated in favour of using suggest via `_search` endpoint. In 5.0, the `_search` endpoint has been optimized for suggest only search requests.
    
    
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

Several suggestions can be specified per request. Each suggestion is identified with an arbitrary name. In the example below two suggestions are requested. Both `my-suggest-1` and `my-suggest-2` suggestions use the `term` suggester, but have a different `text`.
    
    
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

The below suggest response example includes the suggestion response for `my-suggest-1` and `my-suggest-2`. Each suggestion part contains entries. Each entry is effectively a token from the suggest text and contains the suggestion entry text, the original start offset and length in the suggest text and if found an arbitrary number of options.
    
    
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

Each options array contains an option object that includes the suggested text, its document frequency and score compared to the suggest entry text. The meaning of the score depends on the used suggester. The term suggester’s score is based on the edit distance.

### Global suggest text

To avoid repetition of the suggest text, it is possible to define a global text. In the example below the suggest text is defined globally and applies to the `my-suggest-1` and `my-suggest-2` suggestions.
    
    
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

The suggest text can in the above example also be specified as suggestion specific option. The suggest text specified on suggestion level override the suggest text on the global level.