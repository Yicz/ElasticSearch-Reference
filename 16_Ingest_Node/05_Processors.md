## Processors

All processors are defined in the following way within a pipeline definition:
    
    
    {
      "PROCESSOR_NAME" : {
        ... processor configuration options ...
      }
    }

Each processor defines its own configuration parameters, but all processors have the ability to declare `tag` and `on_failure` fields. These fields are optional.

A `tag` is simply a string identifier of the specific instantiation of a certain processor in a pipeline. The `tag` field does not affect the processor’s behavior, but is very useful for bookkeeping and tracing errors to specific processors.

See [_Handling Failures in Pipelines_](handling-failure-in-pipelines.html) to learn more about the `on_failure` field and error handling in pipelines.

The [node info API](cluster-nodes-info.html#ingest-info) can be used to figure out what processors are available in a cluster. The [node info API](cluster-nodes-info.html#ingest-info) will provide a per node list of what processors are available.

Custom processors must be installed on all nodes. The put pipeline API will fail if a processor specified in a pipeline doesn’t exist on all nodes. If you rely on custom processor plugins make sure to mark these plugins as mandatory by adding `plugin.mandatory` setting to the `config/elasticsearch.yml` file, for example:
    
    
    plugin.mandatory: ingest-attachment,ingest-geoip

A node will not start if either of these plugins are not available.

The [node stats API](cluster-nodes-stats.html#ingest-stats) can be used to fetch ingest usage statistics, globally and on a per pipeline basis. Useful to find out which pipelines are used the most or spent the most time on preprocessing.
