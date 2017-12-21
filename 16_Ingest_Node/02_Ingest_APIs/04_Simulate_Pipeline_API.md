## Simulate Pipeline API

The simulate pipeline API executes a specific pipeline against the set of documents provided in the body of the request.

You can either specify an existing pipeline to execute against the provided documents, or supply a pipeline definition in the body of the request.

Here is the structure of a simulate request with a pipeline definition provided in the body of the request:
    
    
    POST _ingest/pipeline/_simulate
    {
      "pipeline" : {
        // pipeline definition here
      },
      "docs" : [
        { /** first document **/ },
        { /** second document **/ },
        // ...
      ]
    }

Here is the structure of a simulate request against an existing pipeline:
    
    
    POST _ingest/pipeline/my-pipeline-id/_simulate
    {
      "docs" : [
        { /** first document **/ },
        { /** second document **/ },
        // ...
      ]
    }

Here is an example of a simulate request with a pipeline defined in the request and its response:
    
    
    POST _ingest/pipeline/_simulate
    {
      "pipeline" :
      {
        "description": "_description",
        "processors": [
          {
            "set" : {
              "field" : "field2",
              "value" : "_value"
            }
          }
        ]
      },
      "docs": [
        {
          "_index": "index",
          "_type": "type",
          "_id": "id",
          "_source": {
            "foo": "bar"
          }
        },
        {
          "_index": "index",
          "_type": "type",
          "_id": "id",
          "_source": {
            "foo": "rab"
          }
        }
      ]
    }

Response:
    
    
    {
       "docs": [
          {
             "doc": {
                "_id": "id",
                "_ttl": null,
                "_parent": null,
                "_index": "index",
                "_routing": null,
                "_type": "type",
                "_timestamp": null,
                "_source": {
                   "field2": "_value",
                   "foo": "bar"
                },
                "_ingest": {
                   "timestamp": "2016-01-04T23:53:27.186+0000"
                }
             }
          },
          {
             "doc": {
                "_id": "id",
                "_ttl": null,
                "_parent": null,
                "_index": "index",
                "_routing": null,
                "_type": "type",
                "_timestamp": null,
                "_source": {
                   "field2": "_value",
                   "foo": "rab"
                },
                "_ingest": {
                   "timestamp": "2016-01-04T23:53:27.186+0000"
                }
             }
          }
       ]
    }

### Viewing Verbose Results

You can use the simulate pipeline API to see how each processor affects the ingest document as it passes through the pipeline. To see the intermediate results of each processor in the simulate request, you can add the `verbose` parameter to the request.

Here is an example of a verbose request and its response:
    
    
    POST _ingest/pipeline/_simulate?verbose
    {
      "pipeline" :
      {
        "description": "_description",
        "processors": [
          {
            "set" : {
              "field" : "field2",
              "value" : "_value2"
            }
          },
          {
            "set" : {
              "field" : "field3",
              "value" : "_value3"
            }
          }
        ]
      },
      "docs": [
        {
          "_index": "index",
          "_type": "type",
          "_id": "id",
          "_source": {
            "foo": "bar"
          }
        },
        {
          "_index": "index",
          "_type": "type",
          "_id": "id",
          "_source": {
            "foo": "rab"
          }
        }
      ]
    }

Response:
    
    
    {
       "docs": [
          {
             "processor_results": [
                {
                   "tag": "processor[set]-0",
                   "doc": {
                      "_id": "id",
                      "_ttl": null,
                      "_parent": null,
                      "_index": "index",
                      "_routing": null,
                      "_type": "type",
                      "_timestamp": null,
                      "_source": {
                         "field2": "_value2",
                         "foo": "bar"
                      },
                      "_ingest": {
                         "timestamp": "2016-01-05T00:02:51.383+0000"
                      }
                   }
                },
                {
                   "tag": "processor[set]-1",
                   "doc": {
                      "_id": "id",
                      "_ttl": null,
                      "_parent": null,
                      "_index": "index",
                      "_routing": null,
                      "_type": "type",
                      "_timestamp": null,
                      "_source": {
                         "field3": "_value3",
                         "field2": "_value2",
                         "foo": "bar"
                      },
                      "_ingest": {
                         "timestamp": "2016-01-05T00:02:51.383+0000"
                      }
                   }
                }
             ]
          },
          {
             "processor_results": [
                {
                   "tag": "processor[set]-0",
                   "doc": {
                      "_id": "id",
                      "_ttl": null,
                      "_parent": null,
                      "_index": "index",
                      "_routing": null,
                      "_type": "type",
                      "_timestamp": null,
                      "_source": {
                         "field2": "_value2",
                         "foo": "rab"
                      },
                      "_ingest": {
                         "timestamp": "2016-01-05T00:02:51.384+0000"
                      }
                   }
                },
                {
                   "tag": "processor[set]-1",
                   "doc": {
                      "_id": "id",
                      "_ttl": null,
                      "_parent": null,
                      "_index": "index",
                      "_routing": null,
                      "_type": "type",
                      "_timestamp": null,
                      "_source": {
                         "field3": "_value3",
                         "field2": "_value2",
                         "foo": "rab"
                      },
                      "_ingest": {
                         "timestamp": "2016-01-05T00:02:51.384+0000"
                      }
                   }
                }
             ]
          }
       ]
    }
