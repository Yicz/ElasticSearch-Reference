## Filters Aggregation

Defines a multi bucket aggregation where each bucket is associated with a filter. Each bucket will collect all documents that match its associated filter.

Example:
    
    
    PUT /logs/message/_bulk?refresh
    { "index" : { "_id" : 1 } }
    { "body" : "warning: page could not be rendered" }
    { "index" : { "_id" : 2 } }
    { "body" : "authentication error" }
    { "index" : { "_id" : 3 } }
    { "body" : "warning: connection timed out" }
    
    GET logs/_search
    {
      "size": 0,
      "aggs" : {
        "messages" : {
          "filters" : {
            "filters" : {
              "errors" :   { "match" : { "body" : "error"   } },
              "warnings" : { "match" : { "body" : "warning" } }
            }
          }
        }
      }
    }

In the above example, we analyze log messages. The aggregation will build two collection (buckets) of log messages - one for all those containing an error, and another for all those containing a warning.

Response:
    
    
    {
      "took": 9,
      "timed_out": false,
      "_shards": ...,
      "hits": ...,
      "aggregations": {
        "messages": {
          "buckets": {
            "errors": {
              "doc_count": 1
            },
            "warnings": {
              "doc_count": 2
            }
          }
        }
      }
    }

### Anonymous filters

The filters field can also be provided as an array of filters, as in the following request:
    
    
    GET logs/_search
    {
      "size": 0,
      "aggs" : {
        "messages" : {
          "filters" : {
            "filters" : [
              { "match" : { "body" : "error"   } },
              { "match" : { "body" : "warning" } }
            ]
          }
        }
      }
    }

The filtered buckets are returned in the same order as provided in the request. The response for this example would be:
    
    
    {
      "took": 4,
      "timed_out": false,
      "_shards": ...,
      "hits": ...,
      "aggregations": {
        "messages": {
          "buckets": [
            {
              "doc_count": 1
            },
            {
              "doc_count": 2
            }
          ]
        }
      }
    }

### `Other` Bucket

The `other_bucket` parameter can be set to add a bucket to the response which will contain all documents that do not match any of the given filters. The value of this parameter can be as follows:

`false`
     Does not compute the `other` bucket 
`true`
     Returns the `other` bucket bucket either in a bucket (named `_other_` by default) if named filters are being used, or as the last bucket if anonymous filters are being used 

The `other_bucket_key` parameter can be used to set the key for the `other` bucket to a value other than the default `_other_`. Setting this parameter will implicitly set the `other_bucket` parameter to `true`.

The following snippet shows a response where the `other` bucket is requested to be named `other_messages`.
    
    
    PUT logs/message/4?refresh
    {
      "body": "info: user Bob logged out"
    }
    
    GET logs/_search
    {
      "size": 0,
      "aggs" : {
        "messages" : {
          "filters" : {
            "other_bucket_key": "other_messages",
            "filters" : {
              "errors" :   { "match" : { "body" : "error"   } },
              "warnings" : { "match" : { "body" : "warning" } }
            }
          }
        }
      }
    }

The response would be something like the following:
    
    
    {
      "took": 3,
      "timed_out": false,
      "_shards": ...,
      "hits": ...,
      "aggregations": {
        "messages": {
          "buckets": {
            "errors": {
              "doc_count": 1
            },
            "warnings": {
              "doc_count": 2
            },
            "other_messages": {
              "doc_count": 1
            }
          }
        }
      }
    }
