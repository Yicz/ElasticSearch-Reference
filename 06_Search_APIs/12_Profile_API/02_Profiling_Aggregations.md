## Profiling Aggregations

### `aggregations` Section

The `aggregations` div contains detailed timing of the aggregation tree executed by a particular shard. The overall structure of this aggregation tree will resemble your original Elasticsearch request. Let’s consider the following example aggregations request:
    
    
    GET /house-prices/_search
    {
      "profile": true,
      "size": 0,
      "aggs": {
        "property_type": {
          "terms": {
            "field": "propertyType"
          },
          "aggs": {
            "avg_price": {
              "avg": {
                "field": "price"
              }
            }
          }
        }
      }
    }

Which yields the following aggregation profile output
    
    
    "aggregations": [
      {
        "type": "org.elasticsearch.search.aggregations.bucket.terms.GlobalOrdinalsStringTermsAggregator",
        "description": "property_type",
        "time": "4280.456978ms",
        "time_in_nanos": "4280456978",
        "breakdown": {
          "reduce": 0,
          "reduce_count": 0,
          "build_aggregation": 49765,
          "build_aggregation_count": 300,
          "initialise": 52785,
          "initialize_count": 300,
          "collect": 3155490036,
          "collect_count": 1800
        },
        "children": [
          {
            "type": "org.elasticsearch.search.aggregations.metrics.avg.AvgAggregator",
            "description": "avg_price",
            "time": "1124.864392ms",
            "time_in_nanos": "1124864392",
            "breakdown": {
              "reduce": 0,
              "reduce_count": 0,
              "build_aggregation": 1394,
              "build_aggregation_count": 150,
              "initialise": 2883,
              "initialize_count": 150,
              "collect": 1124860115,
              "collect_count": 900
            }
          }
        ]
      }
    ]

From the profile structure we can see our `property_type` terms aggregation which is internally represented by the `GlobalOrdinalsStringTermsAggregator` class and the sub aggregator `avg_price` which is internally represented by the `AvgAggregator` class. The `type` field displays the class used internally to represent the aggregation. The `description` field displays the name of the aggregation.

The `time` field shows that it took ~4 seconds for the entire aggregation to execute. The recorded time is inclusive of all children.

The `breakdown` field will give detailed stats about how the time was spent, we’ll look at that in a moment. Finally, the `children` array lists any sub-aggregations that may be present. Because we have an `avg_price` aggregation as a sub-aggregation to the `property_type` aggregation we see it listed as a child of the `property_type` aggregation. the two aggregation outputs have identical information (type, time, breakdown, etc). Children are allowed to have their own children.

#### Timing Breakdown

The `breakdown` component lists detailed timing statistics about low-level Lucene execution:
    
    
    "breakdown": {
      "reduce": 0,
      "reduce_count": 0,
      "build_aggregation": 49765,
      "build_aggregation_count": 300,
      "initialise": 52785,
      "initialize_count": 300,
      "collect": 3155490036,
      "collect_count": 1800
    }

Timings are listed in wall-clock nanoseconds and are not normalized at all. All caveats about the overall `time` apply here. The intention of the breakdown is to give you a feel for A) what machinery in Elasticsearch is actually eating time, and B) the magnitude of differences in times between the various components. Like the overall time, the breakdown is inclusive of all children times.

The meaning of the stats are as follows:

#### All parameters:

`initialise`| This times how long it takes to create and initialise the aggregation before starting to collect documents.     
---|---    
`collect`| This represents the cumulative time spent in the collect phase of the aggregation. This is where matching documents are passed to the aggregation and the state of the aggregator is updated based on the information contained in the documents.     
`build_aggregation`| This represents the time spent creating the shard level results of the aggregation ready to pass back to the reducing node after the collection of documents is finished.     
`reduce`| This is not currently used and will always report `0`. Currently aggregation profiling only times the shard level parts of the aggregation execution. Timing of the reduce phase will be added later.     `*_count`| Records the number of invocations of the particular method. For example, `"collect_count": 2,` means the `collect()` method was called on two different documents. 
