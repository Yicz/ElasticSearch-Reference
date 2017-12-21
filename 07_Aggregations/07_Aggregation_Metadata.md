## Aggregation Metadata

You can associate a piece of metadata with individual aggregations at request time that will be returned in place at response time.

Consider this example where we want to associate the color blue with our `terms` aggregation.
    
    
    GET /twitter/tweet/_search
    {
      "size": 0,
      "aggs": {
        "titles": {
          "terms": {
            "field": "title"
          },
          "meta": {
            "color": "blue"
          }
        }
      }
    }

Then that piece of metadata will be returned in place for our `titles` terms aggregation
    
    
    {
        "aggregations": {
            "titles": {
                "meta": {
                    "color" : "blue"
                },
                "doc_count_error_upper_bound" : 0,
                "sum_other_doc_count" : 0,
                "buckets": [
                ]
            }
        },
        ...
    }
