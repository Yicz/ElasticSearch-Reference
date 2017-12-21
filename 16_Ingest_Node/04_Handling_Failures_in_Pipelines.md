## Handling Failures in Pipelines

In its simplest use case, a pipeline defines a list of processors that are executed sequentially, and processing halts at the first exception. This behavior may not be desirable when failures are expected. For example, you may have logs that don’t match the specified grok expression. Instead of halting execution, you may want to index such documents into a separate index.

To enable this behavior, you can use the `on_failure` parameter. The `on_failure` parameter defines a list of processors to be executed immediately following the failed processor. You can specify this parameter at the pipeline level, as well as at the processor level. If a processor specifies an `on_failure` configuration, whether it is empty or not, any exceptions that are thrown by the processor are caught, and the pipeline continues executing the remaining processors. Because you can define further processors within the scope of an `on_failure` statement, you can nest failure handling.

The following example defines a pipeline that renames the `foo` field in the processed document to `bar`. If the document does not contain the `foo` field, the processor attaches an error message to the document for later analysis within Elasticsearch.
    
    
    {
      "description" : "my first pipeline with handled exceptions",
      "processors" : [
        {
          "rename" : {
            "field" : "foo",
            "target_field" : "bar",
            "on_failure" : [
              {
                "set" : {
                  "field" : "error",
                  "value" : "field \"foo\" does not exist, cannot rename to \"bar\""
                }
              }
            ]
          }
        }
      ]
    }

The following example defines an `on_failure` block on a whole pipeline to change the index to which failed documents get sent.
    
    
    {
      "description" : "my first pipeline with handled exceptions",
      "processors" : [ ... ],
      "on_failure" : [
        {
          "set" : {
            "field" : "_index",
            "value" : "failed-{ { _index } }"
          }
        }
      ]
    }

Alternatively instead of defining behaviour in case of processor failure, it is also possible to ignore a failure and continue with the next processor by specifying the `ignore_failure` setting.

In case in the example below the field `foo` doesn’t exist the failure will be caught and the pipeline continues to execute, which in this case means that the pipeline does nothing.
    
    
    {
      "description" : "my first pipeline with handled exceptions",
      "processors" : [
        {
          "rename" : {
            "field" : "foo",
            "target_field" : "bar",
            "ignore_failure" : true
          }
        }
      ]
    }

The `ignore_failure` can be set on any processor and defaults to `false`.

### Accessing Error Metadata From Processors Handling Exceptions

You may want to retrieve the actual error message that was thrown by a failed processor. To do so you can access metadata fields called `on_failure_message`, `on_failure_processor_type`, and `on_failure_processor_tag`. These fields are only accessible from within the context of an `on_failure` block.

Here is an updated version of the example that you saw earlier. But instead of setting the error message manually, the example leverages the `on_failure_message` metadata field to provide the error message.
    
    
    {
      "description" : "my first pipeline with handled exceptions",
      "processors" : [
        {
          "rename" : {
            "field" : "foo",
            "to" : "bar",
            "on_failure" : [
              {
                "set" : {
                  "field" : "error",
                  "value" : "{ { _ingest.on_failure_message } }"
                }
              }
            ]
          }
        }
      ]
    }
