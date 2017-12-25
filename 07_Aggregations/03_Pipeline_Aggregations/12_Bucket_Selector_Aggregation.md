## Bucket Selector Aggregation

![Warning](images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

A parent pipeline aggregation which executes a script which determines whether the current bucket will be retained in the parent multi-bucket aggregation. The specified metric must be numeric and the script must return a boolean value. If the script language is `expression` then a numeric return value is permitted. In this case 0.0 will be evaluated as `false` and all other values will evaluate to true.

Note: The bucket_selector aggregation, like all pipeline aggregations, executions after all other sibling aggregations. This means that using the bucket_selector aggregation to filter the returned buckets in the response does not save on execution time running the aggregations.

### Syntax

A `bucket_selector` aggregation looks like this in isolation:
    
    
    {
        "bucket_selector": {
            "buckets_path": {
                "my_var1": "the_sum", ![](images/icons/callouts/1.png)
                "my_var2": "the_value_count"
            },
            "script": "params.my_var1 > params.my_var2"
        }
    }

![](images/icons/callouts/1.png)

| 

Here, `my_var1` is the name of the variable for this buckets path to use in the script, `the_sum` is the path to the metrics to use for that variable.   
  
---|---  
  
**Table 12. `bucket_selector` Parameters**

Parameter Name

| 

Description

| 

Required

| 

Default Value  
  
---|---|---|---  
  
`script`

| 

The script to run for this aggregation. The script can be inline, file or indexed. (see [_Scripting_](modules-scripting.html) for more details)

| 

Required

|   
  
`buckets_path`

| 

A map of script variables and their associated path to the buckets we wish to use for the variable (see [`buckets_path` Syntax

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
  
  


The following snippet only retains buckets where the total sales for the month is more than 400:
    
    
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
                    "total_sales": {
                        "sum": {
                            "field": "price"
                        }
                    },
                    "sales_bucket_filter": {
                        "bucket_selector": {
                            "buckets_path": {
                              "totalSales": "total_sales"
                            },
                            "script": "params.totalSales > 200"
                        }
                    }
                }
            }
        }
    }

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
                   "total_sales": {
                       "value": 550.0
                   }
                },![](images/icons/callouts/1.png)
                {
                   "key_as_string": "2015/03/01 00:00:00",
                   "key": 1425168000000,
                   "doc_count": 2,
                   "total_sales": {
                       "value": 375.0
                   },
                }
             ]
          }
       }
    }

![](images/icons/callouts/1.png)

| 

Bucket for `2015/02/01 00:00:00` has been removed as its total sales was less than 200   
  
---|---