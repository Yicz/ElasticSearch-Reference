## Returning the type of the suggester

Sometimes you need to know the exact type of a suggester in order to parse its results. The `typed_keys` parameter can be used to change the suggester’s name in the response so that it will be prefixed by its type.

Considering the following example with two suggesters `term` and `phrase`:
    
    
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

In the response, the suggester names will be changed to respectively `term#my-first-suggester` and `phrase#my-second-suggester`, reflecting the types of each suggestion:
    
    
    {
      "suggest": {
        "term#my-first-suggester": [ ![](images/icons/callouts/1.png)
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
        "phrase#my-second-suggester": [ ![](images/icons/callouts/2.png)
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

![](images/icons/callouts/1.png)

| 

The name `my-first-suggester` now contains the `term` prefix.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The name `my-second-suggester` now contains the `phrase` prefix. 
