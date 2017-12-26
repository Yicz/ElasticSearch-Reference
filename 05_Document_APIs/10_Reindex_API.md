## Reindex API

![Important](images/icons/important.png)

Reindex不试图设置目标索引。它不复制源索引的设置。在运行`_reindex`操作之前，应该设置目标索引，包括设置映射、碎片计数、副本等。

`_reindex`的最基本形式只是将文档从一个索引复制到另一个索引。这将把`twitter`索引中的文档复制到`new_twitter`索引中:
    
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter"
      }
    }

它会返回这样的内容:    
    
    {
      "took" : 147,
      "timed_out": false,
      "created": 120,
      "updated": 0,
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

就像[`_update_by_query`](docs-update-by-query.html)一样，`_reindex`获取源索引的快照，但它的目标必须是一个**不同的**索引，所以不太可能出现版本冲突。`dest`的元素可以配置成索引API来控制乐观并发控制。只留下`version_type`(如上)或将其设置为`internal `将导致ES索盲目地将文档转储到目标中，覆盖任何碰巧具有相同类型和id的文件:
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "version_type": "internal"
      }
    }

将`version_type`设置为`external`将导致ES从源中保存`version`，创建其没有的文档的任何文档，并更新在目标索引中有较老版本的文档，而不是源索引中的文档:
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "version_type": "external"
      }
    }

设置`op_type`为`create`将导致`_reindex`只在目标索引中创建其没有的文档。所有现有文件将导致版本冲突:
    
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "op_type": "create"
      }
    }

默认情况下，冲突中止了`_reindex`进程，但是您可以通过设置`conflicts`来运行它们:
    
    
    POST _reindex
    {
      "conflicts": "proceed",
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "op_type": "create"
      }
    }

您可以通过向`source`添加类型（type）或添加查询(query)来限制文档。下面的例子会将`kimchy`的`tweet`复制到`new_twitter`中:    
    
    POST _reindex
    {
      "source": {
        "index": "twitter",
        "type": "tweet",
        "query": {
          "term": {
            "user": "kimchy"
          }
        }
      },
      "dest": {
        "index": "new_twitter"
      }
    }

`soucre`中的`index`和`type`都可以是列表，允许您在一个请求中复制大量的源。这将从`twitter`和`blog`索引中复制`tweet`和`post`类型的文档。它包括`twitter`索引中的`post`类型，以及`blog`索引中的`tweet`类型。如果想要更具体，就需要使用`query`。它也不费力处理ID冲突。目标索引仍然有效，但是由于迭代顺序没有很好地定义，所以很难预测哪个文档能够存活。
    
    POST _reindex
    {
      "source": {
        "index": ["twitter", "blog"],
        "type": ["tweet", "post"]
      },
      "dest": {
        "index": "all_together"
      }
    }

还可以通过设置`size`来限制已处理文档的数量。这只会将`twitter`的一个文档复制到`new_twitter`:
    
    
    POST _reindex
    {
      "size": 1,
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter"
      }
    }

如果您想要从twitter索引中获得一组特定的文档，您需要进行排序。排序使滚动变得低效，但在某些情况下，它是值得的。如果可能的话，选择`size`和`sort`的更有选择性的查询。这将从`推特`复制10000个文档到`new_twitter`:
    
    
    POST _reindex
    {
      "size": 10000,
      "source": {
        "index": "twitter",
        "sort": { "date": "desc" }
      },
      "dest": {
        "index": "new_twitter"
      }
    }

`source`部分支持[search request](search-request-body.html)中支持的所有元素。例如，只有原始文档中字段的一个子集可以使用源筛选来进行索引，如下所示:
    
    POST _reindex
    {
      "source": {
        "index": "twitter",
        "_source": ["user", "tweet"]
      },
      "dest": {
        "index": "new_twitter"
      }
    }

与`update_by_query`类似，`reindex`支持修改文档的脚本。与`_update_by_query`不同，该脚本可以修改文档的元数据。本例将对源文档的版本进行修改:
    
    POST _reindex
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter",
        "version_type": "external"
      },
      "script": {
        "inline": "if (ctx._source.foo == 'bar') {ctx._version++; ctx._source.remove('foo')}",
        "lang": "painless"
      }
    }

正如在`_update_by_query`中，您可以设置`ctx。op`更改目的地索引处执行的操作:
`noop`
     Set `ctx.op =)`. 
`delete`
     Set `ctx.op =)`. 

Setting `ctx.op` to anything else is an error. Setting any other field in `ctx` is an error.

可以修改的属性!只是小心些而已!你可以改变:

  * `_id`
  * `_type`
  * `_index`
  * `_version`
  * `_routing`
  * `_parent`



Setting `_version` to `null` or clearing it from the `ctx` map is just like not sending the version in an indexing request. It will cause that document to be overwritten in the target index regardless of the version on the target or the version type you use in the `_reindex` request.

By default if `_reindex` sees a document with routing then the routing is preserved unless it’s changed by the script. You can set `routing` on the `dest` request to change this:

`keep`
     Sets the routing on the bulk request sent for each match to the routing on the match. The default. 
`discard`
     Sets the routing on the bulk request sent for each match to null. 
`=<some text>`
     Sets the routing on the bulk request sent for each match to all text after the `=`. 

For example, you can use the following request to copy all documents from the `source` index with the company name `cat` into the `dest` index with routing set to `cat`.
    
    
    POST _reindex
    {
      "source": {
        "index": "source",
        "query": {
          "match": {
            "company": "cat"
          }
        }
      },
      "dest": {
        "index": "dest",
        "routing": "=cat"
      }
    }

By default `_reindex` uses scroll batches of 1000. You can change the batch size with the `size` field in the `source` element:
    
    
    POST _reindex
    {
      "source": {
        "index": "source",
        "size": 100
      },
      "dest": {
        "index": "dest",
        "routing": "=cat"
      }
    }

Reindex can also use the [Ingest Node](ingest.html) feature by specifying a `pipeline` like this:
    
    
    POST _reindex
    {
      "source": {
        "index": "source"
      },
      "dest": {
        "index": "dest",
        "pipeline": "some_ingest_pipeline"
      }
    }

### Reindex from Remote

![Warning](images/icons/warning.png)

Reindex from remote is [broken](https://github.com/elastic/elasticsearch/issues/24520) in 5.4.0 and fixed in 5.4.1.

Reindex supports reindexing from a remote Elasticsearch cluster:
    
    
    POST _reindex
    {
      "source": {
        "remote": {
          "host": "http://otherhost:9200",
          "username": "user",
          "password": "pass"
        },
        "index": "source",
        "query": {
          "match": {
            "test": "data"
          }
        }
      },
      "dest": {
        "index": "dest"
      }
    }

The `host` parameter must contain a scheme, host, and port (e.g. `https://otherhost:9200`). The `username` and `password` parameters are optional and when they are present reindex will connect to the remote Elasticsearch node using basic auth. Be sure to use `https` when using basic auth or the password will be sent in plain text.

Remote hosts have to be explicitly whitelisted in elasticsearch.yaml using the `reindex.remote.whitelist` property. It can be set to a comma delimited list of allowed remote `host` and `port` combinations (e.g. `otherhost:9200, another:9200, 127.0.10.*:9200, localhost:*`). Scheme is ignored by the whitelist - only host and port are used.

This feature should work with remote clusters of any version of Elasticsearch you are likely to find. This should allow you to upgrade from any version of Elasticsearch to the current version by reindexing from a cluster of the old version.

To enable queries sent to older versions of Elasticsearch the `query` parameter is sent directly to the remote host without validation or modification.

Reindexing from a remote server uses an on-heap buffer that defaults to a maximum size of 100mb. If the remote index includes very large documents you’ll need to use a smaller batch size. The example below sets the batch size `10` which is very, very small.
    
    
    POST _reindex
    {
      "source": {
        "remote": {
          "host": "http://otherhost:9200"
        },
        "index": "source",
        "size": 10,
        "query": {
          "match": {
            "test": "data"
          }
        }
      },
      "dest": {
        "index": "dest"
      }
    }

It is also possible to set the socket read timeout on the remote connection with the `socket_timeout` field and the connection timeout with the `connect_timeout` field. Both default to thirty seconds. This example sets the socket read timeout to one minute and the connection timeout to ten seconds:
    
    
    POST _reindex
    {
      "source": {
        "remote": {
          "host": "http://otherhost:9200",
          "socket_timeout": "1m",
          "connect_timeout": "10s"
        },
        "index": "source",
        "query": {
          "match": {
            "test": "data"
          }
        }
      },
      "dest": {
        "index": "dest"
      }
    }

### URL Parameters

In addition to the standard parameters like `pretty`, the Reindex API also supports `refresh`, `wait_for_completion`, `wait_for_active_shards`, `timeout`, and `requests_per_second`.

Sending the `refresh` url parameter will cause all indexes to which the request wrote to be refreshed. This is different than the Index API’s `refresh` parameter which causes just the shard that received the new data to be refreshed.

If the request contains `wait_for_completion=false` then Elasticsearch will perform some preflight checks, launch the request, and then return a `task` which can be used with [Tasks APIs](docs-reindex.html#docs-reindex-task-api) to cancel or get the status of the task. Elasticsearch will also create a record of this task as a document at `.tasks/task/${taskId}`. This is yours to keep or remove as you see fit. When you are done with it, delete it so Elasticsearch can reclaim the space it uses.

`wait_for_active_shards` controls how many copies of a shard must be active before proceeding with the reindexing. See [here](docs-index_.html#index-wait-for-active-shards) for details. `timeout` controls how long each write request waits for unavailable shards to become available. Both work exactly how they work in the [Bulk API](docs-bulk.html).

`requests_per_second` can be set to any positive decimal number (`1.4`, `6`, `1000`, etc) and throttles the number of requests per second that the reindex issues or it can be set to `-1` to disabled throttling. The throttling is done waiting between bulk batches so that it can manipulate the scroll timeout. The wait time is the difference between the time it took the batch to complete and the time `requests_per_second * requests_in_the_batch`. Since the batch isn’t broken into multiple bulk requests large batch sizes will cause Elasticsearch to create many requests and then wait for a while before starting the next set. This is "bursty" instead of "smooth". The default is `-1`.

### Response body

The JSON response looks like this:
    
    
    {
      "took" : 639,
      "updated": 0,
      "created": 123,
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
`created`
     The number of documents that were successfully created. 
`batches`
     The number of scroll responses pulled back by the the reindex. 
`version_conflicts`
     The number of version conflicts that reindex hit. 
`retries`
     The number of retries attempted by reindex. `bulk` is the number of bulk actions retried and `search` is the number of search actions retried. 
`throttled_millis`
     Number of milliseconds the request slept to conform to `requests_per_second`. 
`failures`
     Array of all indexing failures. If this is non-empty then the request aborted because of those failures. See `conflicts` for how to prevent version conflicts from aborting the operation. 

### Works with the Task API

You can fetch the status of all running reindex requests with the [Task API](tasks.html):
    
    
    GET _tasks?detailed=true&actions=*reindex

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
              "action" : "indices:data/write/reindex",
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
                },
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

Any Reindex can be canceled using the [Task Cancel API](tasks.html):
    
    
    POST _tasks/task_id:1/_cancel

The `task_id` can be found using the tasks API above.

Cancelation should happen quickly but might take a few seconds. The task status API above will continue to list the task until it is wakes to cancel itself.

### Rethrottling

The value of `requests_per_second` can be changed on a running reindex using the `_rethrottle` API:
    
    
    POST _reindex/task_id:1/_rethrottle?requests_per_second=-1

The `task_id` can be found using the tasks API above.

Just like when setting it on the `_reindex` API `requests_per_second` can be either `-1` to disable throttling or any decimal number like `1.7` or `12` to throttle to that level. Rethrottling that speeds up the query takes effect immediately but rethrotting that slows down the query will take effect on after completing the current batch. This prevents scroll timeouts.

### Reindex to change the name of a field

`_reindex` can be used to build a copy of an index with renamed fields. Say you create an index containing documents that look like this:
    
    
    POST test/test/1?refresh
    {
      "text": "words words",
      "flag": "foo"
    }

But you don’t like the name `flag` and want to replace it with `tag`. `_reindex` can create the other index for you:
    
    
    POST _reindex
    {
      "source": {
        "index": "test"
      },
      "dest": {
        "index": "test2"
      },
      "script": {
       )"
      }
    }

Now you can get the new document:
    
    
    GET test2/test/1

and it’ll look like:
    
    
    {
      "found": true,
      "_id": "1",
      "_index": "test2",
      "_type": "test",
      "_version": 1,
      "_source": {
        "text": "words words",
        "tag": "foo"
      }
    }

Or you can search by `tag` or whatever you want.

#### Manual slicing

Reindex supports [Sliced Scroll](search-request-scroll.html#sliced-scroll), allowing you to manually parallelize the process relatively easily:
    
    
    POST _reindex
    {
      "source": {
        "index": "twitter",
        "slice": {
          "id": 0,
          "max": 2
        }
      },
      "dest": {
        "index": "new_twitter"
      }
    }
    POST _reindex
    {
      "source": {
        "index": "twitter",
        "slice": {
          "id": 1,
          "max": 2
        }
      },
      "dest": {
        "index": "new_twitter"
      }
    }

Which you can verify works with:
    
    
    GET _refresh
    POST new_twitter/_search?size=0&filter_path=hits.total

Which results in a sensible `total` like this one:
    
    
    {
      "hits": {
        "total": 120
      }
    }

### Automatic slicing

You can also let reindex automatically parallelize using [Sliced Scroll](search-request-scroll.html#sliced-scroll) to slice on `_uid`:
    
    
    POST _reindex?slices=5&refresh
    {
      "source": {
        "index": "twitter"
      },
      "dest": {
        "index": "new_twitter"
      }
    }

Which you also can verify works with:
    
    
    POST new_twitter/_search?size=0&filter_path=hits.total

Which results in a sensible `total` like this one:
    
    
    {
      "hits": {
        "total": 120
      }
    }

Adding `slices` to `_reindex` just automates the manual process used in the div above, creating sub-requests which means it has some quirks:

  * You can see these requests in the [Tasks APIs](docs-reindex.html#docs-reindex-task-api). These sub-requests are "child" tasks of the task for the request with `slices`. 
  * Fetching the status of the task for the request with `slices` only contains the status of completed slices. 
  * These sub-requests are individually addressable for things like cancellation and rethrottling. 
  * Rethrottling the request with `slices` will rethrottle the unfinished sub-request proportionally. 
  * Canceling the request with `slices` will cancel each sub-request. 
  * Due to the nature of `slices` each sub-request won’t get a perfectly even portion of the documents. All documents will be addressed, but some slices may be larger than others. Expect larger slices to have a more even distribution. 
  * Parameters like `requests_per_second` and `size` on a request with `slices` are distributed proportionally to each sub-request. Combine that with the point above about distribution being uneven and you should conclude that the using `size` with `slices` might not result in exactly `size` documents being `_reindex`ed. 
  * Each sub-requests gets a slightly different snapshot of the source index though these are all taken at approximately the same time. 



### Picking the number of slices

At this point we have a few recommendations around the number of `slices` to use (the `max` parameter in the slice API if manually parallelizing):

  * Don’t use large numbers. `500` creates fairly massive CPU thrash. 
  * It is more efficient from a query performance standpoint to use some multiple of the number of shards in the source index. 
  * Using exactly as many shards as are in the source index is the most efficient from a query performance standpoint. 
  * Indexing performance should scale linearly across available resources with the number of `slices`. 
  * Whether indexing or query performance dominates that process depends on lots of factors like the documents being reindexed and the cluster doing the reindexing. 



### Reindex daily indices

You can use `_reindex` in combination with [Painless](modules-scripting-painless.html) to reindex daily indices to apply a new template to the existing documents.

Assuming you have indices consisting of documents as following:
    
    
    PUT metricbeat-2016.05.30/beat/1?refresh
    {"system.cpu.idle.pct": 0.908}
    PUT metricbeat-2016.05.31/beat/1?refresh
    {"system.cpu.idle.pct": 0.105}

The new template for the `metricbeat-*` indices is already loaded into elasticsearch but it applies only to the newly created indices. Painless can be used to reindex the existing documents and apply the new template.

The script below extracts the date from the index name and creates a new index with `-1` appended. All data from `metricbeat-2016.05.31` will be reindex into `metricbeat-2016.05.31-1`.
    
    
    POST _reindex
    {
      "source": {
        "index": "metricbeat-*"
      },
      "dest": {
        "index": "metricbeat"
      },
      "script": {
        "lang": "painless",
        "inline": "ctx._index = 'metricbeat-' + (ctx._index.substring('metricbeat-'.length(), ctx._index.length())) + '-1'"
      }
    }

All documents from the previous metricbeat indices now can be found in the `*-1` indices.
    
    
    GET metricbeat-2016.05.30-1/beat/1
    GET metricbeat-2016.05.31-1/beat/1

The previous method can also be used in combination with [change the name of a field](docs-reindex.html#docs-reindex-change-name) to only load the existing data into the new index, but also rename fields if needed.

###提取一个测试索引的随机子集  Extracting a random subset of an index

Reindex可以用来提取一个测试索引的随机子集:    
    
    POST _reindex
    {
      "size": 10,
      "source": {
        "index": "twitter",
        "query": {
          "function_score" : {
            "query" : { "match_all": {} },
            "random_score" : {}
          }
        },
        "sort": "_score"    ![](images/icons/callouts/1.png)
      },
      "dest": {
        "index": "random_twitter"
      }
    }
#1| Reindex默认为按`_doc`排序，所以`random_score`不会有任何效果，除非你将sort值覆盖到`_score`
---|---
