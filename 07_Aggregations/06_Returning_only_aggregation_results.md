## Returning only aggregation results

There are many occasions when aggregations are required but search hits are not. For these cases the hits can be ignored by setting `size=0`. For example:
    
    
    GET /twitter/tweet/_search
    {
      "size": 0,
      "aggregations": {
        "my_agg": {
          "terms": {
            "field": "text"
          }
        }
      }
    }

Setting `size` to `0` avoids executing the fetch phase of the search making the request more efficient.
