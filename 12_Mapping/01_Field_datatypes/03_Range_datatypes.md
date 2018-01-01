## 范围类型 Range datatypes

The following range types are supported:

`integer_range`| A range of signed 32-bit integers with a minimum value of `-231` and maximum of `231-1`.     
---|---    
`float_range`| A range of single-precision 32-bit IEEE 754 floating point values.     
`long_range`| A range of signed 64-bit integers with a minimum value of `-263` and maximum of `263-1`.     
`double_range`| A range of double-precision 64-bit IEEE 754 floating point values.     
`date_range`| A range of date values represented as unsigned 64-bit integer milliseconds elapsed since system epoch.   
  
Below is an example of configuring a mapping with various range fields followed by an example that indexes several range types.
    
    
    PUT range_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "expected_attendees": {
              "type": "integer_range"
            },
            "time_frame": {
              "type": "date_range", <1>
              "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
            }
          }
        }
      }
    }
    
    PUT range_index/my_type/1
    {
      "expected_attendees" : { <2>
        "gte" : 10,
        "lte" : 20
      },
      "time_frame" : { <3>
        "gte" : "2015-10-31 12:00:00", <4>
        "lte" : "2015-11-01"
      }
    }

The following is an example of a `date_range` query over the `date_range` field named "time_frame".
    
    
    POST range_index/_search
    {
      "query" : {
        "range" : {
          "time_frame" : { <1>
            "gte" : "2015-10-31",
            "lte" : "2015-11-01",
            "relation" : "within" <2>
          }
        }
      }
    }

The result produced by the above query.
    
    
    {
      "took": 13,
      "timed_out": false,
      "_shards" : {
        "total": 2,
        "successful": 2,
        "failed": 0
      },
      "hits" : {
        "total" : 1,
        "max_score" : 1.0,
        "hits" : [
          {
            "_index" : "range_index",
            "_type" : "my_type",
            "_id" : "1",
            "_score" : 1.0,
            "_source" : {
              "expected_attendees" : {
                "gte" : 10, "lte" : 20
              },
              "time_frame" : {
                "gte" : "2015-10-31 12:00:00", "lte" : "2015-11-01"
              }
            }
          }
        ]
      }
    }

<1>| `date_range` types accept the same field parameters defined by the [`date`](date.html) type.     
---|---  
<2>| Example indexing a meeting with 10 to 20 attendees.     
<3>| Date ranges accept the same format as described in [date range queries](query-dsl-range-query.html#ranges-on-dates).     
<4>| Example date range using date time stamp. This also accepts [date math](common-options.html#date-math) formatting, or"now" for system time.     
<1>| Range queries work the same as described in [range query](query-dsl-range-query.html).     
<2>| Range queries over range [fields](mapping-types.html) support a `relation` parameter which can be one of `WITHIN`, CONTAINS`, `INTERSECTS` (default).   
  
### Parameters for range fields

The following parameters are accepted by range types:

[`coerce`](coerce.html)| Try to convert strings to numbers and truncate fractions for integers. Accepts `true` (default) and `false`.     ---|---    
[`boost`](mapping-boost.html)| Mapping field-level query time boosting. Accepts a floating point number, defaults to `1.0`.     
[`include_in_all`](include-in-all.html)| Whether or not the field value should be included in the 
[`_all`](mapping-all-field.html) field? Accepts `true` or false`. Defaults to `false` if [`index`](mapping-index.html) is set to `false`, or if a parent [`object`](object.html)field sets `include_in_all` to `false`. Otherwise defaults to `true`.     
[`index`](mapping-index.html)| Should the field be searchable? Accepts `true` (default) and `false`.     
[`store`](mapping-store.html)| Whether the field value should be stored and retrievable separately from the [`_source`](mapping-source-field.html) field. Accepts `true` or `false` (default). 
