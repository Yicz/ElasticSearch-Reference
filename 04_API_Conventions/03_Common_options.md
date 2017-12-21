## Common options

The following options can be applied to all of the REST APIs.

### Pretty Results

When appending `?pretty=true` to any request made, the JSON returned will be pretty formatted (use it for debugging only!). Another option is to set `?format=yaml` which will cause the result to be returned in the (sometimes) more readable yaml format.

### Human readable output

Statistics are returned in a format suitable for humans (eg `"exists_time": "1h"` or `"size": "1kb"`) and for computers (eg `"exists_time_in_millis": 3600000` or `"size_in_bytes": 1024`). The human readable values can be turned off by adding `?human=false` to the query string. This makes sense when the stats results are being consumed by a monitoring tool, rather than intended for human consumption. The default for the `human` flag is `false`.

### Date Math

Most parameters which accept a formatted date value — such as `gt` and `lt` in [range queries](query-dsl-range-query.html "Range Query") `range` queries, or `from` and `to` in [`daterange` aggregations](search-aggregations-bucket-daterange-aggregation.html "Date Range Aggregation") — understand date maths.

The expression starts with an anchor date, which can either be `now`, or a date string ending with `||`. This anchor date can optionally be followed by one or more maths expressions:

  * `+1h` \- add one hour 
  * `-1d` \- subtract one day 
  * `/d` \- round down to the nearest day 



The supported time units differ than those supported by [time units](common-options.html#time-units "Time unitsedit") for durations. The supported units are:

`y`| years     
---|---    
`M`| months     
`w`| weeks     
`d`| days     
`h`| hours     
`H`| hours     
`m`| minutes     
`s`| seconds     

Some examples are:`now+1h`| The current time plus one hour, with ms resolution.   
  
---|---   
`now+1h+1m`| The current time plus one hour plus one minute, with ms resolution.     
`now+1h/d`| The current time plus one hour, rounded down to the nearest day.     
`2015-01-01||+1M/d`| `2015-01-01` plus one month, rounded down to the nearest day.   
  
### Response Filtering

All REST APIs accept a `filter_path` parameter that can be used to reduce the response returned by elasticsearch. This parameter takes a comma separated list of filters expressed with the dot notation:
    
    GET /_search?q=elasticsearch&filter_path=took,hits.hits._id,hits.hits._score

Responds:
    
    {
      "took" : 3,
      "hits" : {
        "hits" : [
          {
            "_id" : "0",
            "_score" : 1.6375021
          }
        ]
      }
    }

It also supports the `*` wildcard character to match any field or part of a field’s name:
    
    GET /_cluster/state?filter_path=metadata.indices.*.stat*

Responds:
    
    {
      "metadata" : {
        "indices" : {
          "twitter": {"state": "open"}
        }
      }
    }

And the `**` wildcard can be used to include fields without knowing the exact path of the field. For example, we can return the Lucene version of every segment with this request:
    
    
    GET /_cluster/state?filter_path=routing_table.indices.**.state

Responds:
    
    
    {
      "routing_table": {
        "indices": {
          "twitter": {
            "shards": {
              "0": [{"state": "STARTED"}, {"state": "UNASSIGNED"}],
              "1": [{"state": "STARTED"}, {"state": "UNASSIGNED"}],
              "2": [{"state": "STARTED"}, {"state": "UNASSIGNED"}],
              "3": [{"state": "STARTED"}, {"state": "UNASSIGNED"}],
              "4": [{"state": "STARTED"}, {"state": "UNASSIGNED"}]
            }
          }
        }
      }
    }

It is also possible to exclude one or more fields by prefixing the filter with the char `-`:
    
    
    GET /_count?filter_path=-_shards

Responds:
    
    
    {
      "count" : 5
    }

And for more control, both inclusive and exclusive filters can be combined in the same expression. In this case, the exclusive filters will be applied first and the result will be filtered again using the inclusive filters:
    
    
    GET /_cluster/state?filter_path=metadata.indices.*.state,-metadata.indices.logstash-*

Responds:
    
    
    {
      "metadata" : {
        "indices" : {
          "index-1" : {"state" : "open"},
          "index-2" : {"state" : "open"},
          "index-3" : {"state" : "open"}
        }
      }
    }

Note that elasticsearch sometimes returns directly the raw value of a field, like the `_source` field. If you want to filter `_source` fields, you should consider combining the already existing `_source` parameter (see [Get API](docs-get.html#get-source-filtering "Source filteringedit") for more details) with the `filter_path` parameter like this:
    
    
    POST /library/book?refresh
    {"title": "Book #1", "rating": 200.1}
    POST /library/book?refresh
    {"title": "Book #2", "rating": 1.7}
    POST /library/book?refresh
    {"title": "Book #3", "rating": 0.1}
    GET /_search?filter_path=hits.hits._source&_source=title&sort=rating:desc
    
    
    {
      "hits" : {
        "hits" : [ {
          "_source":{"title":"Book #1"}
        }, {
          "_source":{"title":"Book #2"}
        }, {
          "_source":{"title":"Book #3"}
        } ]
      }
    }

### Flat Settings

The `flat_settings` flag affects rendering of the lists of settings. When `flat_settings` flag is `true` settings are returned in a flat format:
    
    
    GET twitter/_settings?flat_settings=true

Returns:
    
    
    {
      "twitter" : {
        "settings": {
          "index.number_of_replicas": "1",
          "index.number_of_shards": "1",
          "index.creation_date": "1474389951325",
          "index.uuid": "n6gzFZTgS664GUfx0Xrpjw",
          "index.version.created": ...,
          "index.provided_name" : "twitter"
        }
      }
    }

When the `flat_settings` flag is `false` settings are returned in a more human readable structured format:
    
    
    GET twitter/_settings?flat_settings=false

Returns:
    
    
    {
      "twitter" : {
        "settings" : {
          "index" : {
            "number_of_replicas": "1",
            "number_of_shards": "1",
            "creation_date": "1474389951325",
            "uuid": "n6gzFZTgS664GUfx0Xrpjw",
            "version": {
              "created": ...
            },
            "provided_name" : "twitter"
          }
        }
      }
    }

By default the `flat_settings` is set to `false`.

### Parameters

Rest parameters (when using HTTP, map to HTTP URL parameters) follow the convention of using underscore casing.

### Boolean Values

All REST APIs parameters (both request parameters and JSON body) support providing boolean "false" as the values: `false`, `0`, `no` and `off`. All other values are considered "true".

![Warning](images/icons/warning.png)

### Deprecated in 5.3.0. 

Usage of any value other than "false" and "true" is deprecated. 

### Number Values

All REST APIs support providing numbered parameters as `string` on top of supporting the native JSON number types.

### Time units

Whenever durations need to be specified, e.g. for a `timeout` parameter, the duration must specify the unit, like `2d` for 2 days. The supported units are:

`d`| days     
---|---    
`h`| hours     
`m`| minutes     
`s`| seconds     
`ms`| milliseconds     
`micros`| microseconds     `
nanos`| nanoseconds   
  
### Byte size units

Whenever the byte size of data needs to be specified, eg when setting a buffer size parameter, the value must specify the unit, like `10kb` for 10 kilobytes. Note that these units use powers of 1024, so `1kb` means 1024 bytes. The supported units are:

`b`| Bytes     
---|---    
`kb`| Kilobytes     
`mb`| Megabytes     
`gb`| Gigabytes     
`tb`| Terabytes     
`pb`| Petabytes   
  
### Unit-less quantities

Unit-less quantities means that they don’t have a "unit" like "bytes" or "Hertz" or "meter" or "long tonne".

If one of these quantities is large we’ll print it out like 10m for 10,000,000 or 7k for 7,000. We’ll still print 87 when we mean 87 though. These are the supported multipliers:

`` | Single     
---|---    
`k`| Kilo     
`m`| Mega     
`g`| Giga     
`t`| Tera     
`p`| Peta   
  
### Distance Units

Wherever distances need to be specified, such as the `distance` parameter in the [Geo Distance Query](query-dsl-geo-distance-query.html "Geo Distance Query")), the default unit if none is specified is the meter. Distances can be specified in other units, such as `"1km"` or `"2mi"` (2 miles).

The full list of units is listed below:

Mile | `mi` or `miles`    
---|---    
Yard | `yd` or `yards`    
Feet | `ft` or `feet`    
Inch | `in` or `inch`    
Kilometer | `km` or `kilometers`    
Meter | `m` or `meters`    
entimeter | `cm` or `centimeters`   
Millimeter | `mm` or `millimeters`    
Nautical mile | `NM`, `nmi` or `nauticalmiles`  
  
### Fuzziness

Some queries and APIs support parameters to allow inexact _fuzzy_ matching, using the `fuzziness` parameter.

When querying `text` or `keyword` fields, `fuzziness` is interpreted as a [Levenshtein Edit Distance](http://en.wikipedia.org/wiki/Levenshtein_distance) — the number of one character changes that need to be made to one string to make it the same as another string.

The `fuzziness` parameter can be specified as:

`0`, `1`, `2`
     the maximum allowed Levenshtein Edit Distance (or number of edits) 
`AUTO`
    

generates an edit distance based on the length of the term. For lengths:

`0..2`
     must match exactly 
`3..5`
     one edit allowed 
`>5`
     two edits allowed 

`AUTO` should generally be the preferred value for `fuzziness`.

### Enabling stack traces

By default when a request returns an error Elasticsearch doesn’t include the stack trace of the error. You can enable that behavior by setting the `error_trace` url parameter to `true`. For example, by default when you send an invalid `size` parameter to the `_search` API:
    
    
    POST /twitter/_search?size=surprise_me

The response looks like:
    
    
    {
      "error" : {
        "root_cause" : [
          {
            "type" : "illegal_argument_exception",
            "reason" : "Failed to parse int parameter [size] with value [surprise_me]"
          }
        ],
        "type" : "illegal_argument_exception",
        "reason" : "Failed to parse int parameter [size] with value [surprise_me]",
        "caused_by" : {
          "type" : "number_format_exception",
          "reason" : "For input string: \"surprise_me\""
        }
      },
      "status" : 400
    }

But if you set `error_trace=true`:
    
    
    POST /twitter/_search?size=surprise_me&error_trace=true

The response looks like:
    
    
    {
      "error": {
        "root_cause": [
          {
            "type": "illegal_argument_exception",
            "reason": "Failed to parse int parameter [size] with value [surprise_me]",
            "stack_trace": "Failed to parse int parameter [size] with value [surprise_me]]; nested: IllegalArgumentException..."
          }
        ],
        "type": "illegal_argument_exception",
        "reason": "Failed to parse int parameter [size] with value [surprise_me]",
        "stack_trace": "java.lang.IllegalArgumentException: Failed to parse int parameter [size] with value [surprise_me]\n    at org.elasticsearch.rest.RestRequest.paramAsInt(RestRequest.java:175)...",
        "caused_by": {
          "type": "number_format_exception",
          "reason": "For input string: \"surprise_me\"",
          "stack_trace": "java.lang.NumberFormatException: For input string: \"surprise_me\"\n    at java.lang.NumberFormatException.forInputString(NumberFormatException.java:65)..."
        }
      },
      "status": 400
    }

### Request body in query string

For libraries that don’t accept a request body for non-POST requests, you can pass the request body as the `source` query string parameter instead. When using this method, the `source_content_type` parameter should also be passed with a media type value that indicates the format of the source, such as `application/json`.

### Content-Type auto-detection

![Warning](images/icons/warning.png)

### Deprecated in 5.3.0. 

Provide the proper Content-Type header 

The content sent in a request body or using the `source` query string parameter is inspected to automatically determine the content type (JSON, YAML, SMILE, or CBOR).

A strict mode can be enabled which disables auto-detection and requires that all requests with a body have a Content-Type header that maps to a supported format. To enabled this strict mode, add the following setting to the `elasticsearch.yml` file:
    
    
    http.content_type.required: true

The default value is `false`.
