## Multi termvectors API

Multi termvectors API allows to get multiple termvectors at once. The documents from which to retrieve the term vectors are specified by an index, type and id. But the documents could also be artificially provided in the request itself.

The response includes a `docs` array with all the fetched termvectors, each element having the structure provided by the [termvectors](docs-termvectors.html "Term Vectors") API. Here is an example:
    
    
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

See the [termvectors](docs-termvectors.html "Term Vectors") API for a description of possible parameters.

The `_mtermvectors` endpoint can also be used against an index (in which case it is not required in the body):
    
    
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

And type:
    
    
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

If all requested documents are on same index and have same type and also the parameters are the same, the request can be simplified:
    
    
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

Additionally, just like for the [termvectors](docs-termvectors.html "Term Vectors") API, term vectors could be generated for user provided documents. The mapping used is determined by `_index` and `_type`.
    
    
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
