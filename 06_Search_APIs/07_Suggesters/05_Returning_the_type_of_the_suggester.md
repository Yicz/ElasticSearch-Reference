## Returning the type of the suggester

有时您需要知道建议器的确切类型才能解析其结果。 `typed_keys`参数可以用来改变响应中的建议者的名字，这样它的前缀就是它的类型。

考虑以下两个建议词“term”和“phrase”的例子：
    
    
    POST _search?typed_keys
    {
      "suggest": {
        "text" : "some test mssage",
        "my-first-suggester" : {
          "term" : {
            "field" : "message"
          }
        },
        "my-second-suggester" : {
          "phrase" : {
            "field" : "message"
          }
        }
      }
    }

在响应中，建议者的名字将分别变成`term＃my-first-suggester`和`phrase＃my-second-suggester`，反映了每个建议的类型：
    
    
    {
      "suggest": {
        "term#my-first-suggester": [ <1>
          {
            "text": "some",
            "offset": 0,
            "length": 4,
            "options": []
          },
          {
            "text": "test",
            "offset": 5,
            "length": 4,
            "options": []
          },
          {
            "text": "mssage",
            "offset": 10,
            "length": 6,
            "options": [
              {
                "text": "message",
                "score": 0.8333333,
                "freq": 4
              }
            ]
          }
        ],
        "phrase#my-second-suggester": [ <2>
          {
            "text": "some test mssage",
            "offset": 0,
            "length": 16,
            "options": [
              {
                "text": "some test message",
                "score": 0.030227963
              }
            ]
          }
        ]
      },
      ...
    }

<1>| `my-first-suggester`这个名字现在包含了`term`前缀。     
---|---    
<2>| `my-second-suggester`这个名字现在包含了`phrase`前缀。
