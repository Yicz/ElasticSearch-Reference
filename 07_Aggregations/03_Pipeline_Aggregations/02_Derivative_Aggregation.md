## Derivative Aggregation

![Warning](images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

A parent pipeline aggregation which calculates the derivative of a specified metric in a parent histogram (or date_histogram) aggregation. The specified metric must be numeric and the enclosing histogram must have `min_doc_count` set to `0` (default for `histogram` aggregations).

### Syntax

A `derivative` aggregation looks like this in isolation:
    
    
    "derivative": {
      "buckets_path": "the_sum"
    }

 **Table 2. `derivative` Parameters**

Parameter Name

| 

Description

| 

Required

| 

Default Value  
  
---|---|---|---  
  
`buckets_path`

| 

The path to the buckets we wish to find the derivative for (see [`buckets_path` Syntax

| 

Required

|   
  
`gap_policy`

| 

The policy to apply when gaps are found in the data (see [Dealing with gaps in the data

| 

Optional

| 

`skip`  
  
`format`

| 

format to apply to the output value of this aggregation

| 

Optional

| 

`null`  
  
  


### First Order Derivative

The following snippet calculates the derivative of the total monthly `sales`:
    
    
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
                    "sales_deriv": {
                        "derivative": {
                            "buckets_path": "sales" ![](images/icons/callouts/1.png)
                        }
                    }
                }
            }
        }
    }

![](images/icons/callouts/1.png)

| 

`buckets_path` instructs this derivative aggregation to use the output of the `sales` aggregation for the derivative   
  
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
                   } ![](images/icons/callouts/1.png)
                },
                {
                   "key_as_string": "2015/02/01 00:00:00",
                   "key": 1422748800000,
                   "doc_count": 2,
                   "sales": {
                      "value": 60.0
                   },
                   "sales_deriv": {
                      "value": -490.0 ![](images/icons/callouts/2.png)
                   }
                },
                {
                   "key_as_string": "2015/03/01 00:00:00",
                   "key": 1425168000000,
                   "doc_count": 2, ![](images/icons/callouts/3.png)
                   "sales": {
                      "value": 375.0
                   },
                   "sales_deriv": {
                      "value": 315.0
                   }
                }
             ]
          }
       }
    }

![](images/icons/callouts/1.png)

| 

No derivative for the first bucket since we need at least 2 data points to calculate the derivative   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Derivative value units are implicitly defined by the `sales` aggregation and the parent histogram so in this case the units would be $/month assuming the `price` field has units of $.   
  
![](images/icons/callouts/3.png)

| 

The number of documents in the bucket are represented by the `doc_count`  
  
### Second Order Derivative

A second order derivative can be calculated by chaining the derivative pipeline aggregation onto the result of another derivative pipeline aggregation as in the following example which will calculate both the first and the second order derivative of the total monthly sales:
    
    
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
                    "sales_deriv": {
                        "derivative": {
                            "buckets_path": "sales"
                        }
                    },
                    "sales_2nd_deriv": {
                        "derivative": {
                            "buckets_path": "sales_deriv" ![](images/icons/callouts/1.png)
                        }
                    }
                }
            }
        }
    }

![](images/icons/callouts/1.png)

| 

`buckets_path` for the second derivative points to the name of the first derivative   
  
---|---  
  
And the following may be the response:
    
    
    {
       "took": 50,
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
                   } ![](images/icons/callouts/1.png)
                },
                {
                   "key_as_string": "2015/02/01 00:00:00",
                   "key": 1422748800000,
                   "doc_count": 2,
                   "sales": {
                      "value": 60.0
                   },
                   "sales_deriv": {
                      "value": -490.0
                   } ![](images/icons/callouts/2.png)
                },
                {
                   "key_as_string": "2015/03/01 00:00:00",
                   "key": 1425168000000,
                   "doc_count": 2,
                   "sales": {
                      "value": 375.0
                   },
                   "sales_deriv": {
                      "value": 315.0
                   },
                   "sales_2nd_deriv": {
                      "value": 805.0
                   }
                }
             ]
          }
       }
    }

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png)

| 

No second derivative for the first two buckets since we need at least 2 data points from the first derivative to calculate the second derivative   
  
---|---  
  
### Units

The derivative aggregation allows the units of the derivative values to be specified. This returns an extra field in the response `normalized_value` which reports the derivative value in the desired x-axis units. In the below example we calculate the derivative of the total sales per month but ask for the derivative of the sales as in the units of sales per day:
    
    
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
                    "sales_deriv": {
                        "derivative": {
                            "buckets_path": "sales",
                            "unit": "day" ![](images/icons/callouts/1.png)
                        }
                    }
                }
            }
        }
    }

![](images/icons/callouts/1.png)

| 

`unit` specifies what unit to use for the x-axis of the derivative calculation   
  
---|---  
  
And the following may be the response:
    
    
    {
       "took": 50,
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
                   } ![](images/icons/callouts/1.png)
                },
                {
                   "key_as_string": "2015/02/01 00:00:00",
                   "key": 1422748800000,
                   "doc_count": 2,
                   "sales": {
                      "value": 60.0
                   },
                   "sales_deriv": {
                      "value": -490.0, ![](images/icons/callouts/2.png)
                      "normalized_value": -15.806451612903226 ![](images/icons/callouts/3.png)
                   }
                },
                {
                   "key_as_string": "2015/03/01 00:00:00",
                   "key": 1425168000000,
                   "doc_count": 2,
                   "sales": {
                      "value": 375.0
                   },
                   "sales_deriv": {
                      "value": 315.0,
                      "normalized_value": 11.25
                   }
                }
             ]
          }
       }
    }

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png)

| 

`value` is reported in the original units of _per month_  
  
---|---  
  
![](images/icons/callouts/3.png)

| 

`normalized_value` is reported in the desired units of _per day_
