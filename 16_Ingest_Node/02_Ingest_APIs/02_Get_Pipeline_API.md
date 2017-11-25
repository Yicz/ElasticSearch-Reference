## Get Pipeline API

The get pipeline API returns pipelines based on ID. This API always returns a local reference of the pipeline.
    
    
    GET _ingest/pipeline/my-pipeline-id

Example response:
    
    
    {
      "my-pipeline-id" : {
        "description" : "describe pipeline",
        "processors" : [
          {
            "set" : {
              "field" : "foo",
              "value" : "bar"
            }
          }
        ]
      }
    }

For each returned pipeline, the source and the version are returned. The version is useful for knowing which version of the pipeline the node has. You can specify multiple IDs to return more than one pipeline. Wildcards are also supported.

#### Pipeline Versioning

Pipelines can optionally add a `version` number, which can be any integer value, in order to simplify pipeline management by external systems. The `version` field is completely optional and it is meant solely for external management of pipelines. To unset a `version`, simply replace the pipeline without specifying one.
    
    
    PUT _ingest/pipeline/my-pipeline-id
    {
      "description" : "describe pipeline",
      "version" : 123,
      "processors" : [
        {
          "set" : {
            "field": "foo",
            "value": "bar"
          }
        }
      ]
    }

To check for the `version`, you can [filter responses](common-options.html#common-options-response-filtering "Response Filteringedit") using `filter_path` to limit the response to just the `version`:
    
    
    GET /_ingest/pipeline/my-pipeline-id?filter_path=*.version

This should give a small response that makes it both easy and inexpensive to parse:
    
    
    {
      "my-pipeline-id" : {
        "version" : 123
      }
    }
