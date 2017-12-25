## `boost`

Individual fields can be _boosted_ automatically — count more towards the relevance score — at query time, with the `boost` parameter as follows:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "title": {
              "type": "text",
              "boost": 2 ![](images/icons/callouts/1.png)
            },
            "content": {
              "type": "text"
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

Matches on the `title` field will have twice the weight as those on the `content` field, which has the default `boost` of `1.0`.   
  
---|---  
  
![Note](images/icons/note.png)

The boost is applied only for term queries (prefix, range and fuzzy queries are not _boosted_ ).

You can achieve the same effect by using the boost parameter directly in the query, for instance the following query (with field time boost):
    
    
    POST _search
    {
        "query": {
            "match" : {
                "title": {
                    "query": "quick brown fox"
                }
            }
        }
    }

is equivalent to:
    
    
    POST _search
    {
        "query": {
            "match" : {
                "title": {
                    "query": "quick brown fox",
                    "boost": 2
                }
            }
        }
    }

The boost is also applied when it is copied with the value in the [`_all`](mapping-all-field.html) field. This means that, when querying the `_all` field, words that originated from the `title` field will have a higher score than words that originated in the `content` field. This functionality comes at a cost: queries on the `_all` field are slower when field boosting is used.

![Warning](images/icons/warning.png)

### Deprecated in 5.0.0. 

index time boost is deprecated. Instead, the field mapping boost is applied at query time. For indices created before 5.0.0 the boost will still be applied at index time. 

![Warning](images/icons/warning.png)

### Why index time boosting is a bad idea

We advise against using index time boosting for the following reasons:

  * You cannot change index-time `boost` values without reindexing all of your documents. 
  * Every query supports query-time boosting which achieves the same effect. The difference is that you can tweak the `boost` value without having to reindex. 
  * Index-time boosts are stored as part of the [`norm`](norms.html), which is only one byte. This reduces the resolution of the field length normalization factor which can lead to lower quality relevance calculations. 

