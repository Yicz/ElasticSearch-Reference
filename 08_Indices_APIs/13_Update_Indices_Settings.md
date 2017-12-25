## Update Indices Settings

Change specific index level settings in real time.

The REST endpoint is `/_settings` (to update all indices) or `{index}/_settings` to update one (or more) indices settings. The body of the request includes the updated settings, for example:
    
    
    PUT /twitter/_settings
    {
        "index" : {
            "number_of_replicas" : 2
        }
    }

The list of per-index settings which can be updated dynamically on live indices can be found in [Index Modules](index-modules.html). To preserve existing settings from being updated, the `preserve_existing` request parameter can be set to `true`.

### Bulk Indexing Usage

For example, the update settings API can be used to dynamically change the index from being more performant for bulk indexing, and then move it to more real time indexing state. Before the bulk indexing is started, use:
    
    
    PUT /twitter/_settings
    {
        "index" : {
            "refresh_interval" : "-1"
        }
    }

(Another optimization option is to start the index without any replicas, and only later adding them, but that really depends on the use case).

Then, once bulk indexing is done, the settings can be updated (back to the defaults for example):
    
    
    PUT /twitter/_settings
    {
        "index" : {
            "refresh_interval" : "1s"
        }
    }

And, a force merge should be called:
    
    
    POST /twitter/_forcemerge?max_num_segments=5

### Updating Index Analysis

It is also possible to define new [analyzers](analysis.html) for the index. But it is required to [close](indices-open-close.html) the index first and [open](indices-open-close.html) it after the changes are made.

For example if `content` analyzer hasn’t been defined on `myindex` yet you can use the following commands to add it:
    
    
    POST /twitter/_close
    
    PUT /twitter/_settings
    {
      "analysis" : {
        "analyzer":{
          "content":{
            "type":"custom",
            "tokenizer":"whitespace"
          }
        }
      }
    }
    
    POST /twitter/_open
