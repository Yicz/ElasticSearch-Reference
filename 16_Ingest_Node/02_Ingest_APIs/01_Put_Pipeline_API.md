## Put Pipeline API

The put pipeline API adds pipelines and updates existing pipelines in the cluster.
    
    
    PUT _ingest/pipeline/my-pipeline-id
    {
      "description" : "describe pipeline",
      "processors" : [
        {
          "set" : {
            "field": "foo",
            "value": "bar"
          }
        }
      ]
    }

![Note](/images/icons/note.png)

The put pipeline API also instructs all ingest nodes to reload their in-memory representation of pipelines, so that pipeline changes take effect immediately.
