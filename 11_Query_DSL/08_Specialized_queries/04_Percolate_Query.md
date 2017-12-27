## Percolate Query

The `percolate` query can be used to match queries stored in an index. The `percolate` query itself contains the document that will be used as query to match with the stored queries.

### Sample Usage

Create an index with two mappings:
    
    
    PUT /my-index
    {
        "mappings": {
            "doctype": {
                "properties": {
                    "message": {
                        "type": "text"
                    }
                }
            },
            "queries": {
                "properties": {
                    "query": {
                        "type": "percolator"
                    }
                }
            }
        }
    }

The `doctype` mapping is the mapping used to preprocess the document defined in the `percolator` query before it gets indexed into a temporary index.

The `queries` mapping is the mapping used for indexing the query documents. The `query` field will hold a json object that represents an actual Elasticsearch query. The `query` field has been configured to use the [percolator field type](percolator.html). This field type understands the query dsl and stored the query in such a way that it can be used later on to match documents defined on the `percolate` query.

Register a query in the percolator:
    
    
    PUT /my-index/queries/1?refresh
    {
        "query" : {
            "match" : {
                "message" : "bonsai tree"
            }
        }
    }

Match a document to the registered percolator queries:
    
    
    GET /my-index/_search
    {
        "query" : {
            "percolate" : {
                "field" : "query",
                "document_type" : "doctype",
                "document" : {
                    "message" : "A new bonsai tree in the office"
                }
            }
        }
    }

The above request will yield the following response:
    
    
    {
      "took": 13,
      "timed_out": false,
      "_shards": {
        "total": 5,
        "successful": 5,
        "failed": 0
      },
      "hits": {
        "total": 1,
        "max_score": 0.5716521,
        "hits": [
          { <1>
            "_index": "my-index",
            "_type": "queries",
            "_id": "1",
            "_score": 0.5716521,
            "_source": {
              "query": {
                "match": {
                  "message": "bonsai tree"
                }
              }
            }
          }
        ]
      }
    }

<1>| The query with id `1` matches our document.     
---|---  
  
#### Parameters

The following parameters are required when percolating a document:

`field`| The field of type `percolator` that holds the indexed queries. This is a required parameter.     
---|---    
`document_type`| The type / mapping of the document being percolated. This is a required parameter.     
`document`| The source of the document being percolated.   
  
Instead of specifying the source of the document being percolated, the source can also be retrieved from an already stored document. The `percolate` query will then internally execute a get request to fetch that document.

In that case the `document` parameter can be substituted with the following parameters:

`index`| The index the document resides in. This is a required parameter.     
---|---    
`type`| The type of the document to fetch. This is a required parameter.     
`id`| The id of the document to fetch. This is a required parameter.     
`routing`| Optionally, routing to be used to fetch document to percolate.     
`preference`| Optionally, preference to be used to fetch document to percolate.     
`version`| Optionally, the expected version of the document to be fetched.   
  
#### Percolating an Existing Document

In order to percolate a newly indexed document, the `percolate` query can be used. Based on the response from an index request, the `_id` and other meta information can be used to immediately percolate the newly added document.

##### Example

Based on the previous example.

Index the document we want to percolate:
    
    
    PUT /my-index/message/1
    {
      "message" : "A new bonsai tree in the office"
    }

Index response:
    
    
    {
      "_index": "my-index",
      "_type": "message",
      "_id": "1",
      "_version": 1,
      "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
      },
      "created": true,
      "result": "created"
    }

Percolating an existing document, using the index response as basis to build to new search request:
    
    
    GET /my-index/_search
    {
        "query" : {
            "percolate" : {
                "field": "query",
                "document_type" : "doctype",
                "index" : "my-index",
                "type" : "message",
                "id" : "1",
                "version" : 1 <1>
            }
        }
    }

<1>| The version is optional, but useful in certain cases. We can ensure that we are trying to percolate the document we just have indexed. A change may be made after we have indexed, and if that is the case the then the search request would fail with a version conflict error.     
---|---  
  
The search response returned is identical as in the previous example.

#### Percolate query and highlighting

The `percolate` query is handled in a special way when it comes to highlighting. The queries hits are used to highlight the document that is provided in the `percolate` query. Whereas with regular highlighting the query in the search request is used to highlight the hits.

##### Example

This example is based on the mapping of the first example.

Save a query:
    
    
    PUT /my-index/queries/1?refresh
    {
        "query" : {
            "match" : {
                "message" : "brown fox"
            }
        }
    }

Save another query:
    
    
    PUT /my-index/queries/2?refresh
    {
        "query" : {
            "match" : {
                "message" : "lazy dog"
            }
        }
    }

Execute a search request with the `percolate` query and highlighting enabled:
    
    
    GET /my-index/_search
    {
        "query" : {
            "percolate" : {
                "field": "query",
                "document_type" : "doctype",
                "document" : {
                    "message" : "The quick brown fox jumps over the lazy dog"
                }
            }
        },
        "highlight": {
          "fields": {
            "message": {}
          }
        }
    }

This will yield the following response.
    
    
    {
      "took": 7,
      "timed_out": false,
      "_shards": {
        "total": 5,
        "successful": 5,
        "failed": 0
      },
      "hits": {
        "total": 2,
        "max_score": 0.5446649,
        "hits": [
          {
            "_index": "my-index",
            "_type": "queries",
            "_id": "2",
            "_score": 0.5446649,
            "_source": {
              "query": {
                "match": {
                  "message": "lazy dog"
                }
              }
            },
            "highlight": {
              "message": [
                "The quick brown fox jumps over the <em>lazy</em> <em>dog</em>" <1>
              ]
            }
          },
          {
            "_index": "my-index",
            "_type": "queries",
            "_id": "1",
            "_score": 0.5446649,
            "_source": {
              "query": {
                "match": {
                  "message": "brown fox"
                }
              }
            },
            "highlight": {
              "message": [
                "The quick <em>brown</em> <em>fox</em> jumps over the lazy dog" <2>
              ]
            }
          }
        ]
      }
    }

<1> <2>| The terms from each query have been highlighted in the document.     
---|---  
  
Instead of the query in the search request highlighting the percolator hits, the percolator queries are highlighting the document defined in the `percolate` query.

#### How it Works Under the Hood

When indexing a document into an index that has the [percolator field type](percolator.html) mapping configured, the query part of the document gets parsed into a Lucene query and is stored into the Lucene index. A binary representation of the query gets stored, but also the query’s terms are analyzed and stored into an indexed field.

At search time, the document specified in the request gets parsed into a Lucene document and is stored in a in-memory temporary Lucene index. This in-memory index can just hold this one document and it is optimized for that. After this a special query is built based on the terms in the in-memory index that select candidate percolator queries based on their indexed query terms. These queries are then evaluated by the in-memory index if they actually match.

The selecting of candidate percolator queries matches is an important performance optimization during the execution of the `percolate` query as it can significantly reduce the number of candidate matches the in-memory index needs to evaluate. The reason the `percolate` query can do this is because during indexing of the percolator queries the query terms are being extracted and indexed with the percolator query. Unfortunately the percolator cannot extract terms from all queries (for example the `wildcard` or `geo_shape` query) and as a result of that in certain cases the percolator can’t do the selecting optimization (for example if an unsupported query is defined in a required clause of a boolean query or the unsupported query is the only query in the percolator document). These queries are marked by the percolator and can be found by running the following search:
    
    
    GET /_search
    {
      "query": {
        "term" : {
          "query.extraction_result" : "failed"
        }
      }
    }

![Note](images/icons/note.png)

The above example assumes that there is a `query` field of type `percolator` in the mappings.
