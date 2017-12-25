## Rescoring

Rescoring can help to improve precision by reordering just the top (eg 100 - 500) documents returned by the [`query`](search-request-query.html) and [`post_filter`](search-request-post-filter.html) phases, using a secondary (usually more costly) algorithm, instead of applying the costly algorithm to all documents in the index.

A `rescore` request is executed on each shard before it returns its results to be sorted by the node handling the overall search request.

Currently the rescore API has only one implementation: the query rescorer, which uses a query to tweak the scoring. In the future, alternative rescorers may be made available, for example, a pair-wise rescorer.

![Note](images/icons/note.png)

the `rescore` phase is not executed when [`sort`](search-request-sort.html) is used.

![Note](images/icons/note.png)

when exposing pagination to your users, you should not change `window_size` as you step through each page (by passing different `from` values) since that can alter the top hits causing results to confusingly shift as the user steps through pages.

### Query rescorer

The query rescorer executes a second query only on the Top-K results returned by the [`query`](search-request-query.html) and [`post_filter`](search-request-post-filter.html) phases. The number of docs which will be examined on each shard can be controlled by the `window_size` parameter, which defaults to [`from` and `size`](search-request-from-size.html).

By default the scores from the original query and the rescore query are combined linearly to produce the final `_score` for each document. The relative importance of the original query and of the rescore query can be controlled with the `query_weight` and `rescore_query_weight` respectively. Both default to `1`.

For example:
    
    
    POST /_search
    {
       "query" : {
          "match" : {
             "message" : {
                "operator" : "or",
                "query" : "the quick brown"
             }
          }
       },
       "rescore" : {
          "window_size" : 50,
          "query" : {
             "rescore_query" : {
                "match_phrase" : {
                   "message" : {
                      "query" : "the quick brown",
                      "slop" : 2
                   }
                }
             },
             "query_weight" : 0.7,
             "rescore_query_weight" : 1.2
          }
       }
    }

The way the scores are combined can be controlled with the `score_mode`:

Score Mode | Description  
---|---  
  
`total`

| 

Add the original score and the rescore query score. The default.  
  
`multiply`

| 

Multiply the original score by the rescore query score. Useful for [`function query`](query-dsl-function-score-query.html) rescores.  
  
`avg`

| 

Average the original score and the rescore query score.  
  
`max`

| 

Take the max of original score and the rescore query score.  
  
`min`

| 

Take the min of the original score and the rescore query score.  
  
### Multiple Rescores

It is also possible to execute multiple rescores in sequence:
    
    
    POST /_search
    {
       "query" : {
          "match" : {
             "message" : {
                "operator" : "or",
                "query" : "the quick brown"
             }
          }
       },
       "rescore" : [ {
          "window_size" : 100,
          "query" : {
             "rescore_query" : {
                "match_phrase" : {
                   "message" : {
                      "query" : "the quick brown",
                      "slop" : 2
                   }
                }
             },
             "query_weight" : 0.7,
             "rescore_query_weight" : 1.2
          }
       }, {
          "window_size" : 10,
          "query" : {
             "score_mode": "multiply",
             "rescore_query" : {
                "function_score" : {
                   "script_score": {
                      "script": {
                        "inline": "Math.log10(doc.likes.value + 2)"
                      }
                   }
                }
             }
          }
       } ]
    }

The first one gets the results of the query then the second one gets the results of the first, etc. The second rescore will "see" the sorting done by the first rescore so it is possible to use a large window on the first rescore to pull documents into a smaller window for the second rescore.
