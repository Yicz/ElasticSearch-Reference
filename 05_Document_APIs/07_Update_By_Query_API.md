## Update By Query API

The simplest usage of `_update_by_query` just performs an update on every document in the index without changing the source. This is useful to [pick up a new property](docs-update-by-query.html#picking-up-a-new-property) or some other online mapping change. Here is the API:
    
    
    POST twitter/_update_by_query?conflicts=proceed

That will return something like this:
    
    
    {
      "took" : 147,
      "timed_out": false,
      "updated": 120,
      "deleted": 0,
      "batches": 1,
      "version_conflicts": 0,
      "noops": 0,
      "retries": {
        "bulk": 0,
        "search": 0
      },
      "throttled_millis": 0,
      "requests_per_second": -1.0,
      "throttled_until_millis": 0,
      "total": 120,
      "failures" : [ ]
    }

`_update_by_query` gets a snapshot of the index when it starts and indexes what it finds using `internal` versioning. That means that you’ll get a version conflict if the document changes between the time when the snapshot was taken and when the index request is processed. When the versions match the document is updated and the version number is incremented.

![Note](images/icons/note.png)

Since `internal` versioning does not support the value 0 as a valid version number, documents with version equal to zero cannot be updated using `_update_by_query` and will fail the request.

All update and query failures cause the `_update_by_query` to abort and are returned in the `failures` of the response. The updates that have been performed still stick. In other words, the process is not rolled back, only aborted. While the first failure causes the abort, all failures that are returned by the failing bulk request are returned in the `failures` element; therefore it’s possible for there to be quite a few failed entities.

If you want to simply count version conflicts not cause the `_update_by_query` to abort you can set `conflicts=proceed` on the url or `"conflicts": "proceed"` in the request body. The first example does this because it is just trying to pick up an online mapping change and a version conflict simply means that the conflicting document was updated between the start of the `_update_by_query` and the time when it attempted to update the document. This is fine because that update will have picked up the online mapping update.

Back to the API format, you can limit `_update_by_query` to a single type. This will only update `tweet` documents from the `twitter` index:
    
    
    POST twitter/tweet/_update_by_query?conflicts=proceed

You can also limit `_update_by_query` using the [Query DSL](query-dsl.html). This will update all documents from the `twitter` index for the user `kimchy`:
    
    
    POST twitter/_update_by_query?conflicts=proceed
    {
      "query": { ![](images/icons/callouts/1.png)
        "term": {
          "user": "kimchy"
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The query must be passed as a value to the `query` key, in the same way as the [Search API](search-search.html). You can also use the `q` parameter in the same way as the search api.   
  
---|---  
  
So far we’ve only been updating documents without changing their source. That is genuinely useful for things like [picking up new properties](docs-update-by-query.html#picking-up-a-new-property) but it’s only half the fun. `_update_by_query` supports a `script` object to update the document. This will increment the `likes` field on all of kimchy’s tweets:
    
    
    POST twitter/_update_by_query
    {
      "script": {
        "inline": "ctx._source.likes++",
        "lang": "painless"
      },
      "query": {
        "term": {
          "user": "kimchy"
        }
      }
    }

Just as in [Update API](docs-update.html) you can set `ctx.op` to change the operation that is executed:

`noop`
     Set `ctx.op =). 
`delete`
     Set `ctx.op =). 

Setting `ctx.op` to anything else is an error. Setting any other field in `ctx` is an error.

Note that we stopped specifying `conflicts=proceed`. In this case we want a version conflict to abort the process so we can handle the failure.

This API doesn’t allow you to move the documents it touches, just modify their source. This is intentional! We’ve made no provisions for removing the document from its original location.

It’s also possible to do this whole thing on multiple indexes and multiple types at once, just like the search API:
    
    
    POST twitter,blog/tweet,post/_update_by_query

If you provide `routing` then the routing is copied to the scroll query, limiting the process to the shards that match that routing value:
    
    
    POST twitter/_update_by_query?routing=1

By default `_update_by_query` uses scroll batches of 1000. You can change the batch size with the `scroll_size` URL parameter:
    
    
    POST twitter/_update_by_query?scroll_size=100

`_update_by_query` can also use the [Ingest Node](ingest.html) feature by specifying a `pipeline` like this:
    
    
    PUT _ingest/pipeline/set-foo
    {
      "description" : "sets foo",
      "processors" : [ {
          "set" : {
            "field": "foo",
            "value": "bar"
          }
      } ]
    }
    POST twitter/_update_by_query?pipeline=set-foo

### URL Parameters

In addition to the standard parameters like `pretty`, the Update By Query API also supports `refresh`, `wait_for_completion`, `wait_for_active_shards`, and `timeout`.

Sending the `refresh` will update all shards in the index being updated when the request completes. This is different than the Index API’s `refresh` parameter which causes just the shard that received the new data to be indexed.

If the request contains `wait_for_completion=false` then Elasticsearch will perform some preflight checks, launch the request, and then return a `task` which can be used with [Tasks APIs](docs-update-by-query.html#docs-update-by-query-task-api) to cancel or get the status of the task. Elasticsearch will also create a record of this task as a document at `.tasks/task/${taskId}`. This is yours to keep or remove as you see fit. When you are done with it, delete it so Elasticsearch can reclaim the space it uses.

`wait_for_active_shards` controls how many copies of a shard must be active before proceeding with the request. See [here](docs-index_.html#index-wait-for-active-shards) for details. `timeout` controls how long each write request waits for unavailable shards to become available. Both work exactly how they work in the [Bulk API](docs-bulk.html).

`requests_per_second` can be set to any positive decimal number (`1.4`, `6`, `1000`, etc) and throttles the number of requests per second that the update-by-query issues or it can be set to `-1` to disabled throttling. The throttling is done waiting between bulk batches so that it can manipulate the scroll timeout. The wait time is the difference between the time it took the batch to complete and the time `requests_per_second * requests_in_the_batch`. Since the batch isn’t broken into multiple bulk requests large batch sizes will cause Elasticsearch to create many requests and then wait for a while before starting the next set. This is "bursty" instead of "smooth". The default is `-1`.

### Response body

The JSON response looks like this:
    
    
    {
      "took" : 639,
      "updated": 0,
      "batches": 1,
      "version_conflicts": 2,
      "retries": {
        "bulk": 0,
        "search": 0
      }
      "throttled_millis": 0,
      "failures" : [ ]
    }

`took`
     The number of milliseconds from start to end of the whole operation. 
`updated`
     The number of documents that were successfully updated. 
`batches`
     The number of scroll responses pulled back by the the update by query. 
`version_conflicts`
     The number of version conflicts that the update by query hit. 
`retries`
     The number of retries attempted by update-by-query. `bulk` is the number of bulk actions retried and `search` is the number of search actions retried. 
`throttled_millis`
     Number of milliseconds the request slept to conform to `requests_per_second`. 
`failures`
     Array of all indexing failures. If this is non-empty then the request aborted because of those failures. See `conflicts` for how to prevent version conflicts from aborting the operation. 

### Works with the Task API

You can fetch the status of all running update-by-query requests with the [Task API](tasks.html):
    
    
    GET _tasks?detailed=true&actions=*byquery

The responses looks like:
    
    
    {
      "nodes" : {
        "r1A2WoRbTwKZ516z6NEs5A" : {
          "name" : "r1A2WoR",
          "transport_address" : "127.0.0.1:9300",
          "host" : "127.0.0.1",
          "ip" : "127.0.0.1:9300",
          "attributes" : {
            "testattr" : "test",
            "portsfile" : "true"
          },
          "tasks" : {
            "r1A2WoRbTwKZ516z6NEs5A:36619" : {
              "node" : "r1A2WoRbTwKZ516z6NEs5A",
              "id" : 36619,
              "type" : "transport",
              "action" : "indices:data/write/update/byquery",
              "status" : {    ![](images/icons/callouts/1.png)
                "total" : 6154,
                "updated" : 3500,
                "created" : 0,
                "deleted" : 0,
                "batches" : 4,
                "version_conflicts" : 0,
                "noops" : 0,
                "retries": {
                  "bulk": 0,
                  "search": 0
                }
                "throttled_millis": 0
              },
              "description" : ""
            }
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

this object contains the actual status. It is just like the response json with the important addition of the `total` field. `total` is the total number of operations that the reindex expects to perform. You can estimate the progress by adding the `updated`, `created`, and `deleted` fields. The request will finish when their sum is equal to the `total` field.   
  
---|---  
  
With the task id you can look up the task directly:
    
    
    GET /_tasks/taskId:1

The advantage of this API is that it integrates with `wait_for_completion=false` to transparently return the status of completed tasks. If the task is completed and `wait_for_completion=false` was set on it them it’ll come back with a `results` or an `error` field. The cost of this feature is the document that `wait_for_completion=false` creates at `.tasks/task/${taskId}`. It is up to you to delete that document.

### Works with the Cancel Task API

Any Update By Query can be canceled using the [Task Cancel API](tasks.html):
    
    
    POST _tasks/task_id:1/_cancel

The `task_id` can be found using the tasks API above.

Cancellation should happen quickly but might take a few seconds. The task status API above will continue to list the task until it is wakes to cancel itself.

### Rethrottling

The value of `requests_per_second` can be changed on a running update by query using the `_rethrottle` API:
    
    
    POST _update_by_query/task_id:1/_rethrottle?requests_per_second=-1

The `task_id` can be found using the tasks API above.

Just like when setting it on the `_update_by_query` API `requests_per_second` can be either `-1` to disable throttling or any decimal number like `1.7` or `12` to throttle to that level. Rethrottling that speeds up the query takes effect immediately but rethrotting that slows down the query will take effect on after completing the current batch. This prevents scroll timeouts.

#### Manual slicing

Update-by-query supports [Sliced Scroll](search-request-scroll.html#sliced-scroll) allowing you to manually parallelize the process relatively easily:
    
    
    POST twitter/_update_by_query
    {
      "slice": {
        "id": 0,
        "max": 2
      },
      "script": {
        "inline": "ctx._source['extra'] = 'test'"
      }
    }
    POST twitter/_update_by_query
    {
      "slice": {
        "id": 1,
        "max": 2
      },
      "script": {
        "inline": "ctx._source['extra'] = 'test'"
      }
    }

Which you can verify works with:
    
    
    GET _refresh
    POST twitter/_search?size=0&q=extra:test&filter_path=hits.total

Which results in a sensible `total` like this one:
    
    
    {
      "hits": {
        "total": 120
      }
    }

### Automatic slicing

You can also let update-by-query automatically parallelize using [Sliced Scroll](search-request-scroll.html#sliced-scroll) to slice on `_uid`:
    
    
    POST twitter/_update_by_query?refresh&slices=5
    {
      "script": {
        "inline": "ctx._source['extra'] = 'test'"
      }
    }

Which you also can verify works with:
    
    
    POST twitter/_search?size=0&q=extra:test&filter_path=hits.total

Which results in a sensible `total` like this one:
    
    
    {
      "hits": {
        "total": 120
      }
    }

Adding `slices` to `_update_by_query` just automates the manual process used in the div above, creating sub-requests which means it has some quirks:

  * You can see these requests in the [Tasks APIs](docs-update-by-query.html#docs-update-by-query-task-api). These sub-requests are "child" tasks of the task for the request with `slices`. 
  * Fetching the status of the task for the request with `slices` only contains the status of completed slices. 
  * These sub-requests are individually addressable for things like cancellation and rethrottling. 
  * Rethrottling the request with `slices` will rethrottle the unfinished sub-request proportionally. 
  * Canceling the request with `slices` will cancel each sub-request. 
  * Due to the nature of `slices` each sub-request won’t get a perfectly even portion of the documents. All documents will be addressed, but some slices may be larger than others. Expect larger slices to have a more even distribution. 
  * Parameters like `requests_per_second` and `size` on a request with `slices` are distributed proportionally to each sub-request. Combine that with the point above about distribution being uneven and you should conclude that the using `size` with `slices` might not result in exactly `size` documents being `_update_by_query`ed. 
  * Each sub-requests gets a slightly different snapshot of the source index though these are all taken at approximately the same time. 



### Picking the number of slices

At this point we have a few recommendations around the number of `slices` to use (the `max` parameter in the slice API if manually parallelizing):

  * Don’t use large numbers. `500` creates fairly massive CPU thrash. 
  * It is more efficient from a query performance standpoint to use some multiple of the number of shards in the source index. 
  * Using exactly as many shards as are in the source index is the most efficient from a query performance standpoint. 
  * Indexing performance should scale linearly across available resources with the number of `slices`. 
  * Whether indexing or query performance dominates that process depends on lots of factors like the documents being reindexed and the cluster doing the reindexing. 



### Pick up a new property

Say you created an index without dynamic mapping, filled it with data, and then added a mapping value to pick up more fields from the data:
    
    
    PUT test
    {
      "mappings": {
        "test": {
          "dynamic": false,   ![](images/icons/callouts/1.png)
          "properties": {
            "text": {"type": "text"}
          }
        }
      }
    }
    
    POST test/test?refresh
    {
      "text": "words words",
      "flag": "bar"
    }
    POST test/test?refresh
    {
      "text": "words words",
      "flag": "foo"
    }
    PUT test/_mapping/test   ![](images/icons/callouts/2.png)
    {
      "properties": {
        "text": {"type": "text"},
        "flag": {"type": "text", "analyzer": "keyword"}
      }
    }

![](images/icons/callouts/1.png)

| 

This means that new fields won’t be indexed, just stored in `_source`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This updates the mapping to add the new `flag` field. To pick up the new field you have to reindex all documents with it.   
  
Searching for the data won’t find anything:
    
    
    POST test/_search?filter_path=hits.total
    {
      "query": {
        "match": {
          "flag": "foo"
        }
      }
    }
    
    
    {
      "hits" : {
        "total" : 0
      }
    }

But you can issue an `_update_by_query` request to pick up the new mapping:
    
    
    POST test/_update_by_query?refresh&conflicts=proceed
    POST test/_search?filter_path=hits.total
    {
      "query": {
        "match": {
          "flag": "foo"
        }
      }
    }
    
    
    {
      "hits" : {
        "total" : 1
      }
    }

You can do the exact same thing when adding a field to a multifield.