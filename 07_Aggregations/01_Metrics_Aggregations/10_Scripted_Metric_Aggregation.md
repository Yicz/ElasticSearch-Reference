## Scripted Metric Aggregation

![Warning](images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

A metric aggregation that executes using scripts to provide a metric output.

Example:
    
    
    POST ledger/_search?size=0
    {
        "query" : {
            "match_all" : {}
        },
        "aggs": {
            "profit": {
                "scripted_metric": {
                    "init_script" : "params._agg.transactions = []",
                    "map_script" : "params._agg.transactions.add(doc.type.value == 'sale' ? doc.amount.value : -1 * doc.amount.value)", ![](images/icons/callouts/1.png)
                    "combine_script" : "double profit = 0; for (t in params._agg.transactions) { profit += t } return profit",
                    "reduce_script" : "double profit = 0; for (a in params._aggs) { profit += a } return profit"
                }
            }
        }
    }

![](images/icons/callouts/1.png)

| 

`map_script` is the only required parameter   
  
---|---  
  
The above aggregation demonstrates how one would use the script aggregation compute the total profit from sale and cost transactions.

The response for the above aggregation:
    
    
    {
        "took": 218,
        ...
        "aggregations": {
            "profit": {
                "value": 240.0
            }
       }
    }

The above example can also be specified using file scripts as follows:
    
    
    POST ledger/_search?size=0
    {
        "aggs": {
            "profit": {
                "scripted_metric": {
                    "init_script" : {
                        "file": "my_init_script"
                    },
                    "map_script" : {
                        "file": "my_map_script"
                    },
                    "combine_script" : {
                        "file": "my_combine_script"
                    },
                    "params": {
                        "field": "amount", ![](images/icons/callouts/1.png)
                        "_agg": {}        ![](images/icons/callouts/2.png)
                    },
                    "reduce_script" : {
                        "file": "my_reduce_script"
                    }
                }
            }
        }
    }

![](images/icons/callouts/1.png)

| 

script parameters for `init`, `map` and `combine` scripts must be specified in a global `params` object so that it can be share between the scripts.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

if you specify script parameters then you must specify `"_agg": {}`.   
  
For more details on specifying scripts see [script documentation](modules-scripting.html "Scripting").

### Allowed return types

Whilst any valid script object can be used within a single script, the scripts must return or store in the `_agg` object only the following types:

  * primitive types 
  * String 
  * Map (containing only keys and values of the types listed here) 
  * Array (containing elements of only the types listed here) 



### Scope of scripts

The scripted metric aggregation uses scripts at 4 stages of its execution:

init_script 
    

Executed prior to any collection of documents. Allows the aggregation to set up any initial state. 

In the above example, the `init_script` creates an array `transactions` in the `_agg` object.

map_script 
    

Executed once per document collected. This is the only required script. If no combine_script is specified, the resulting state needs to be stored in an object named `_agg`. 

In the above example, the `map_script` checks the value of the type field. If the value is _sale_ the value of the amount field is added to the transactions array. If the value of the type field is not _sale_ the negated value of the amount field is added to transactions.

combine_script 
    

Executed once on each shard after document collection is complete. Allows the aggregation to consolidate the state returned from each shard. If a combine_script is not provided the combine phase will return the aggregation variable. 

In the above example, the `combine_script` iterates through all the stored transactions, summing the values in the `profit` variable and finally returns `profit`.

reduce_script 
    

Executed once on the coordinating node after all shards have returned their results. The script is provided with access to a variable `_aggs` which is an array of the result of the combine_script on each shard. If a reduce_script is not provided the reduce phase will return the `_aggs` variable. 

In the above example, the `reduce_script` iterates through the `profit` returned by each shard summing the values before returning the final combined profit which will be returned in the response of the aggregation.

### Worked Example

Imagine a situation where you index the following documents into an index with 2 shards:
    
    
    PUT /transactions/stock/_bulk?refresh
    {"index":{"_id":1} }
    {"type": "sale","amount": 80}
    {"index":{"_id":2} }
    {"type": "cost","amount": 10}
    {"index":{"_id":3} }
    {"type": "cost","amount": 30}
    {"index":{"_id":4} }
    {"type": "sale","amount": 130}

Lets say that documents 1 and 3 end up on shard A and documents 2 and 4 end up on shard B. The following is a breakdown of what the aggregation result is at each stage of the example above.

#### Before init_script

No params object was specified so the default params object is used:
    
    
    "params" : {
        "_agg" : {}
    }

#### After init_script

This is run once on each shard before any document collection is performed, and so we will have a copy on each shard:

Shard A 
    
    
    
    "params" : {
        "_agg" : {
            "transactions" : []
        }
    }

Shard B 
    
    
    
    "params" : {
        "_agg" : {
            "transactions" : []
        }
    }

#### After map_script

Each shard collects its documents and runs the map_script on each document that is collected:

Shard A 
    
    
    
    "params" : {
        "_agg" : {
            "transactions" : [ 80, -30 ]
        }
    }

Shard B 
    
    
    
    "params" : {
        "_agg" : {
            "transactions" : [ -10, 130 ]
        }
    }

#### After combine_script

The combine_script is executed on each shard after document collection is complete and reduces all the transactions down to a single profit figure for each shard (by summing the values in the transactions array) which is passed back to the coordinating node:

Shard A 
     50 
Shard B 
     120 

#### After reduce_script

The reduce_script receives an `_aggs` array containing the result of the combine script for each shard:
    
    
    "_aggs" : [
        50,
        120
    ]

It reduces the responses for the shards down to a final overall profit figure (by summing the values) and returns this as the result of the aggregation to produce the response:
    
    
    {
        ...
    
        "aggregations": {
            "profit": {
                "value": 170
            }
       }
    }

### Other Parameters

params 

| 

Optional. An object whose contents will be passed as variables to the `init_script`, `map_script` and `combine_script`. This can be useful to allow the user to control the behavior of the aggregation and for storing state between the scripts. If this is not specified, the default is the equivalent of providing: 
    
    
    "params" : {
        "_agg" : {}
    }  
  
---|---  
  
### Empty Buckets

If a parent bucket of the scripted metric aggregation does not collect any documents an empty aggregation response will be returned from the shard with a `null` value. In this case the `reduce_script`'s `_aggs` variable will contain `null` as a response from that shard. `reduce_script`'s should therefore expect and deal with `null` responses from shards.
