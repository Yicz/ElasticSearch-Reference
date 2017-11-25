## Returning the type of the aggregation

Sometimes you need to know the exact type of an aggregation in order to parse its results. The `typed_keys` parameter can be used to change the aggregation’s name in the response so that it will be prefixed by its internal type.

Considering the following [`date_histogram` aggregation](search-aggregations-bucket-datehistogram-aggregation.html "Date Histogram Aggregation") named `tweets_over_time` which has a sub ['top_hits` aggregation](search-aggregations-metrics-top-hits-aggregation.html "Top hits Aggregation") named `top_users`:
    
    
    GET /twitter/tweet/_search?typed_keys
    {
      "aggregations": {
        "tweets_over_time": {
          "date_histogram": {
            "field": "date",
            "interval": "year"
          },
          "aggregations": {
            "top_users": {
                "top_hits": {
                    "size": 1
                }
            }
          }
        }
      }
    }

In the response, the aggregations names will be changed to respectively `date_histogram#tweets_over_time` and `top_hits#top_users`, reflecting the internal types of each aggregation:
    
    
    {
        "aggregations": {
            "date_histogram#tweets_over_time": { ![](images/icons/callouts/1.png)
                "buckets" : [
                    {
                        "key_as_string" : "2009-01-01T00:00:00.000Z",
                        "key" : 1230768000000,
                        "doc_count" : 5,
                        "top_hits#top_users" : {  ![](images/icons/callouts/2.png)
                            "hits" : {
                                "total" : 5,
                                "max_score" : 1.0,
                                "hits" : [
                                    {
                                      "_index": "twitter",
                                      "_type": "tweet",
                                      "_id": "0",
                                      "_score": 1.0,
                                      "_source": {
                                        "date": "2009-11-15T14:12:12",
                                        "message": "trying out Elasticsearch",
                                        "user": "kimchy",
                                        "likes": 0
                                      }
                                    }
                                ]
                            }
                        }
                    }
                ]
            }
        },
        ...
    }

![](images/icons/callouts/1.png)

| 

The name `tweets_over_time` now contains the `date_histogram` prefix.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The name `top_users` now contains the `top_hits` prefix.   
  
![Note](images/icons/note.png)

For some aggregations, it is possible that the returned type is not the same as the one provided with the request. This is the case for Terms, Significant Terms and Percentiles aggregations, where the returned type also contains information about the type of the targeted field: `lterms` (for a terms aggregation on a Long field), `sigsterms` (for a significant terms aggregation on a String field), `tdigest_percentiles` (for a percentile aggregation based on the TDigest algorithm).
