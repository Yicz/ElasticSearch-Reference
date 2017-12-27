## Validate API

The validate API allows a user to validate a potentially expensive query without executing it. We’ll use the following test data to explain _validate:
    
    
    PUT twitter/tweet/_bulk?refresh
    {"index":{"_id":1} }
    {"user" : "kimchy", "post_date" : "2009-11-15T14:12:12", "message" : "trying out Elasticsearch"}
    {"index":{"_id":2} }
    {"user" : "kimchi", "post_date" : "2009-11-15T14:12:13", "message" : "My username is similar to @kimchy!"}

When sent a valid query:
    
    
    GET twitter/_validate/query?q=user:foo

The response contains `valid:true`:
    
    
    {"valid":true,"_shards":{"total":1,"successful":1,"failed":0} }

### Request Parameters

When executing exists using the query parameter `q`, the query passed is a query string using Lucene query parser. There are additional parameters that can be passed:

Name | Description  
---|---  
  
`df`| The default field to use when no field prefix is defined within the query.    
`analyzer`| The analyzer name to be used when analyzing the query string.    
`default_operator`| The default operator to be used, can be `AND` or `OR`. Defaults to `OR`.    
`lenient`| If set to true will cause format based failures (like providing text to a numeric field) to be ignored. Defaults to false.    
`analyze_wildcard`| Should wildcard and prefix queries be analyzed or not. Defaults to `false`.  
  
The query may also be sent in the request body:
    
    
    GET twitter/tweet/_validate/query
    {
      "query" : {
        "bool" : {
          "must" : {
            "query_string" : {
              "query" : "*:*"
            }
          },
          "filter" : {
            "term" : { "user" : "kimchy" }
          }
        }
      }
    }

![Note](/images/icons/note.png)

The query being sent in the body must be nested in a `query` key, same as the [search api](search-search.html) works

If the query is invalid, `valid` will be `false`. Here the query is invalid because Elasticsearch knows the post_date field should be a date due to dynamic mapping, and _foo_ does not correctly parse into a date:
    
    
    GET twitter/tweet/_validate/query?q=post_date:foo
    
    
    {"valid":false,"_shards":{"total":1,"successful":1,"failed":0} }

An `explain` parameter can be specified to get more detailed information about why a query failed:
    
    
    GET twitter/tweet/_validate/query?q=post_date:foo&explain=true

responds with:
    
    
    {
      "valid" : false,
      "_shards" : {
        "total" : 1,
        "successful" : 1,
        "failed" : 0
      },
      "explanations" : [ {
        "index" : "twitter",
        "valid" : false,
        "error" : "twitter/IAEc2nIXSSunQA_suI0MLw] QueryShardException[failed to create query:...failed to parse date field [foo]"
      } ]
    }

When the query is valid, the explanation defaults to the string representation of that query. With `rewrite` set to `true`, the explanation is more detailed showing the actual Lucene query that will be executed.

For More Like This:
    
    
    GET twitter/tweet/_validate/query?rewrite=true
    {
      "query": {
        "more_like_this": {
          "like": {
            "_id": "2"
          },
          "boost_terms": 1
        }
      }
    }

Response:
    
    
    {
       "valid": true,
       "_shards": {
          "total": 1,
          "successful": 1,
          "failed": 0
       },
       "explanations": [
          {
             "index": "twitter",
             "valid": true,
             "explanation": "((user:terminator^3.71334 plot:future^2.763601 plot:human^2.8415773 plot:sarah^3.4193945 plot:kyle^3.8244398 plot:cyborg^3.9177752 plot:connor^4.040236 plot:reese^4.7133346 ... )~6) -ConstantScore(_uid:tweet<2>)) #(ConstantScore(_type:tweet))^0.0"
          }
       ]
    }

By default, the request is executed on a single shard only, which is randomly selected. The detailed explanation of the query may depend on which shard is being hit, and therefore may vary from one request to another. So, in case of query rewrite the `all_shards` parameter should be used to get response from all available shards.

For Fuzzy Queries:
    
    
    GET twitter/tweet/_validate/query?rewrite=true&all_shards=true
    {
      "query": {
        "match": {
          "user": {
            "query": "kimchy",
            "fuzziness": "auto"
          }
        }
      }
    }

Response:
    
    
    {
      "valid": true,
      "_shards": {
        "total": 5,
        "successful": 5,
        "failed": 0
      },
      "explanations": [
        {
          "index": "twitter",
          "shard": 0,
          "valid": true,
         ) #ConstantScore(MatchNoDocsQuery(\"empty BooleanQuery\"))"
        },
        {
          "index": "twitter",
          "shard": 1,
          "valid": true,
         ) #ConstantScore(MatchNoDocsQuery(\"empty BooleanQuery\"))"
        },
        {
          "index": "twitter",
          "shard": 2,
          "valid": true,
          "explanation": "(user:kimchi)^0.8333333"
        },
        {
          "index": "twitter",
          "shard": 3,
          "valid": true,
          "explanation": "user:kimchy"
        },
        {
          "index": "twitter",
          "shard": 4,
          "valid": true,
         ) #ConstantScore(MatchNoDocsQuery(\"empty BooleanQuery\"))"
        }
      ]
    }
