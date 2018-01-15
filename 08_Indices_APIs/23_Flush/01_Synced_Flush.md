##  同步刷新 Synced Flush

Elasticsearch跟踪每个分片的索引活动。 5分钟示收到索引操作的分片会自动标记为非活动状态。 这为Elasticsearch提供了一个减少分片资源的机会，并且执行了一种特殊的flush，称为`synced flush`。 同步刷新执行正常刷新，然后将生成的唯一标记（sync_id）添加到所有碎片。

由于在没有正在进行索引操作时添加了同步标识符，因此可以用它作为快速检查两个分片的lucene索引是否相同的方法。 此快速同步ID比较（如果存在）在恢复过程中使用或重新启动以跳过过程的第一个也是最昂贵的阶段。 在这种情况下，不需要复制段文件，恢复的事务日志重放阶段可以立即开始。 请注意，由于同步ID标记与flush一起使用，事务日志很可能是空的，加快了恢复的速度。


This is particularly useful for use cases having lots of indices which are never or very rarely updated, such as time based data. This use case typically generates lots of indices whose recovery without the synced flush marker would take a long time.

To check whether a shard has a marker or not, look for the `commit` div of shard stats returned by the [indices stats](indices-stats.html) API:
    
    
    GET twitter/_stats?level=shards

响应如下:
    
    
    {
       ...
       "indices": {
          "twitter": {
             "primaries": {},
             "total": {},
             "shards": {
                "0": [
                   {
                      "routing": {
                         ...
                      },
                      "commit": {
                         "id": "te7zF7C4UsirqvL6jp/vUg==",
                         "generation": 2,
                         "user_data": {
                            "sync_id": "AU2VU0meX-VX2aNbEUsD" <1>,
                            ...
                         },
                         "num_docs": 0
                      }
                   }
                   ...
                ],
                ...
             }
          }
       }
    }

<1>|  `sync id` 标识     
---|---  
  
### Synced Flush API

The Synced Flush API allows an administrator to initiate a synced flush manually. This can be particularly useful for a planned (rolling) cluster restart where you can stop indexing and don’t want to wait the default 5 minutes for idle indices to be sync-flushed automatically.

While handy, there are a couple of caveats for this API:

  1. Synced flush is a best effort operation. Any ongoing indexing operations will cause the synced flush to fail on that shard. This means that some shards may be synced flushed while others aren’t. See below for more. 
  2. The `sync_id` marker is removed as soon as the shard is flushed again. That is because a flush replaces the low level lucene commit point where the marker is stored. Uncommitted operations in the transaction log do not remove the marker. In practice, one should consider any indexing operation on an index as removing the marker as a flush can be triggered by Elasticsearch at any time. 



![Note](/images/icons/note.png)

It is harmless to request a synced flush while there is ongoing indexing. Shards that are idle will succeed and shards that are not will fail. Any shards that succeeded will have faster recovery times.
    
    
    POST twitter/_flush/synced

The response contains details about how many shards were successfully sync-flushed and information about any failure.

Here is what it looks like when all shards of a two shards and one replica index successfully sync-flushed:
    
    
    {
       "_shards": {
          "total": 2,
          "successful": 2,
          "failed": 0
       },
       "twitter": {
          "total": 2,
          "successful": 2,
          "failed": 0
       }
    }

Here is what it looks like when one shard group failed due to pending operations:
    
    
    {
       "_shards": {
          "total": 4,
          "successful": 2,
          "failed": 2
       },
       "twitter": {
          "total": 4,
          "successful": 2,
          "failed": 2,
          "failures": [
             {
                "shard": 1,
                "reason": "[2] ongoing operations on primary"
             }
          ]
       }
    }

![Note](/images/icons/note.png)

The above error is shown when the synced flush fails due to concurrent indexing operations. The HTTP status code in that case will be `409 CONFLICT`.

Sometimes the failures are specific to a shard copy. The copies that failed will not be eligible for fast recovery but those that succeeded still will be. This case is reported as follows:
    
    
    {
       "_shards": {
          "total": 4,
          "successful": 1,
          "failed": 1
       },
       "twitter": {
          "total": 4,
          "successful": 3,
          "failed": 1,
          "failures": [
             {
                "shard": 1,
                "reason": "unexpected error",
                "routing": {
                   "state": "STARTED",
                   "primary": false,
                   "node": "SZNr2J_ORxKTLUCydGX4zA",
                   "relocating_node": null,
                   "shard": 1,
                   "index": "twitter"
                }
             }
          ]
       }
    }

![Note](/images/icons/note.png)

When a shard copy fails to sync-flush, the HTTP status code returned will be `409 CONFLICT`.

The synced flush API can be applied to more than one index with a single call, or even on `_all` the indices.
    
    
    POST kimchy,elasticsearch/_flush/synced
    
    POST _flush/synced
