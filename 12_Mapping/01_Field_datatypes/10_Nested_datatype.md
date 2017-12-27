## Nested datatype

The `nested` type is a specialised version of the [`object`](object.html) datatype that allows arrays of objects to be indexed and queried independently of each other.

### How arrays of objects are flattened

Arrays of inner [`object` fields](object.html) do not work the way you may expect. Lucene has no concept of inner objects, so Elasticsearch flattens object hierarchies into a simple list of field names and values. For instance, the following document:
    
    
    PUT my_index/my_type/1
    {
      "group" : "fans",
      "user" : [ <1>
        {
          "first" : "John",
          "last" :  "Smith"
        },
        {
          "first" : "Alice",
          "last" :  "White"
        }
      ]
    }

<1>

| 

The `user` field is dynamically added as a field of type `object`.   
  
---|---  
  
would be transformed internally into a document that looks more like this:
    
    
    {
      "group" :        "fans",
      "user.first" : [ "alice", "john" ],
      "user.last" :  [ "smith", "white" ]
    }

The `user.first` and `user.last` fields are flattened into multi-value fields, and the association between `alice` and `white` is lost. This document would incorrectly match a query for `alice AND smith`:
    
    
    GET my_index/_search
    {
      "query": {
        "bool": {
          "must": [
            { "match": { "user.first": "Alice" } },
            { "match": { "user.last":  "Smith" } }
          ]
        }
      }
    }

### Using `nested` fields for arrays of objects

If you need to index arrays of objects and to maintain the independence of each object in the array, you should use the `nested` datatype instead of the [`object`](object.html) datatype. Internally, nested objects index each object in the array as a separate hidden document, meaning that each nested object can be queried independently of the others, with the [`nested` query](query-dsl-nested-query.html):
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "user": {
              "type": "nested" <1>
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "group" : "fans",
      "user" : [
        {
          "first" : "John",
          "last" :  "Smith"
        },
        {
          "first" : "Alice",
          "last" :  "White"
        }
      ]
    }
    
    GET my_index/_search
    {
      "query": {
        "nested": {
          "path": "user",
          "query": {
            "bool": {
              "must": [
                { "match": { "user.first": "Alice" } },
                { "match": { "user.last":  "Smith" } } <2>
              ]
            }
          }
        }
      }
    }
    
    GET my_index/_search
    {
      "query": {
        "nested": {
          "path": "user",
          "query": {
            "bool": {
              "must": [
                { "match": { "user.first": "Alice" } },
                { "match": { "user.last":  "White" } } <3>
              ]
            }
          },
          "inner_hits": { <4>
            "highlight": {
              "fields": {
                "user.first": {}
              }
            }
          }
        }
      }
    }

<1>

| 

The `user` field is mapped as type `nested` instead of type `object`.   
  
---|---  
  
<2>

| 

This query doesn’t match because `Alice` and `Smith` are not in the same nested object.   
  
<3>

| 

This query matches because `Alice` and `White` are in the same nested object.   
  
<4>

| 

`inner_hits` allow us to highlight the matching nested documents.   
  
Nested documents can be:

  * queried with the [`nested`](query-dsl-nested-query.html) query. 
  * analyzed with the [`nested`](search-aggregations-bucket-nested-aggregation.html) and [`reverse_nested`](search-aggregations-bucket-reverse-nested-aggregation.html) aggregations. 
  * sorted with [nested sorting](search-request-sort.html#nested-sorting). 
  * retrieved and highlighted with [nested inner hits](search-request-inner-hits.html#nested-inner-hits). 



### Parameters for `nested` fields

The following parameters are accepted by `nested` fields:

[`dynamic`](dynamic.html)

| 

Whether or not new `properties` should be added dynamically to an existing nested object. Accepts `true` (default), `false` and `strict`.   
  
---|---  
  
[`include_in_all`](include-in-all.html)

| 

Sets the default `include_in_all` value for all the `properties` within the nested object. Nested documents do not have their own `_all` field. Instead, values are added to the `_all` field of the main “root” document.   
  
[`properties`](properties.html)

| 

The fields within the nested object, which can be of any [datatype](mapping-types.html), including `nested`. New properties may be added to an existing nested object.   
  
![Important](/images/icons/important.png)

Because nested documents are indexed as separate documents, they can only be accessed within the scope of the `nested` query, the `nested`/`reverse_nested`, or [nested inner hits](search-request-inner-hits.html#nested-inner-hits).

For instance, if a string field within a nested document has [`index_options`](index-options.html) set to `offsets` to allow use of the postings highlighter, these offsets will not be available during the main highlighting phase. Instead, highlighting needs to be performed via [nested inner hits](search-request-inner-hits.html#nested-inner-hits).

### Limiting the number of `nested` fields

Indexing a document with 100 nested fields actually indexes 101 documents as each nested document is indexed as a separate document. To safeguard against ill-defined mappings the number of nested fields that can be defined per index has been limited to 50. See [Settings to prevent mappings explosion.
