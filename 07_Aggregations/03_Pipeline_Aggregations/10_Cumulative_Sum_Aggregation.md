## Cumulative Sum Aggregation

![Warning](/images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

A parent pipeline aggregation which calculates the cumulative sum of a specified metric in a parent histogram (or date_histogram) aggregation. The specified metric must be numeric and the enclosing histogram must have `min_doc_count` set to `0` (default for `histogram` aggregations).

### Syntax

A `cumulative_sum` aggregation looks like this in isolation:
    
    
    {
        "cumulative_sum": {
            "buckets_path": "the_sum"
        }
    }

 **Table 10. `cumulative_sum` Parameters**

 参数名|描述|是否必需|默认值   
---|---|---|---    
`buckets_path`| The path to the buckets we wish to find the cumulative sum for (see [`buckets_path` Syntax| Required|  `format`| format to apply to the output value of this aggregation| Optional| `null`  
  
  


The following snippet calculates the cumulative sum of the total monthly `sales`:
    
    
    POST /sales/_search
    {
        "size": 0,
        "aggs" : {
            "sales_per_month" : {
                "date_histogram" : {
                    "field" : "date",
                    "interval" : "month"
                },
                "aggs": {
                    "sales": {
                        "sum": {
                            "field": "price"
                        }
                    },
                    "cumulative_sales": {
                        "cumulative_sum": {
                            "buckets_path": "sales" <1>
                        }
                    }
                }
            }
        }
    }

<1>| `buckets_path` instructs this cumulative sum aggregation to use the output of the `sales` aggregation for the cumulative sum     
---|---  
  
And the following may be the response:
    
    
    {
       "took": 11,
       "timed_out": false,
       "_shards": ...,
       "hits": ...,
       "aggregations": {
          "sales_per_month": {
             "buckets": [
                {
                   "key_as_string": "2015/01/01 00:00:00",
                   "key": 1420070400000,
                   "doc_count": 3,
                   "sales": {
                      "value": 550.0
                   },
                   "cumulative_sales": {
                      "value": 550.0
                   }
                },
                {
                   "key_as_string": "2015/02/01 00:00:00",
                   "key": 1422748800000,
                   "doc_count": 2,
                   "sales": {
                      "value": 60.0
                   },
                   "cumulative_sales": {
                      "value": 610.0
                   }
                },
                {
                   "key_as_string": "2015/03/01 00:00:00",
                   "key": 1425168000000,
                   "doc_count": 2,
                   "sales": {
                      "value": 375.0
                   },
                   "cumulative_sales": {
                      "value": 985.0
                   }
                }
             ]
          }
       }
    }
