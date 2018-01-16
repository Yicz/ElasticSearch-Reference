##  同步刷新 Synced Flush

Elasticsearch跟踪每个分片的索引活动。 5分钟示收到索引操作的分片会自动标记为非活动状态。 这为Elasticsearch提供了一个减少分片资源的机会，并且执行了一种特殊的flush，称为`synced flush`。 同步刷新执行正常刷新，然后将生成的唯一标记（sync_id）添加到所有碎片。

由于在没有正在进行索引操作时添加了同步标识符，因此可以用它作为快速检查两个分片的lucene索引是否相同的方法。 此快速同步ID比较（如果存在）在恢复过程中使用或重新启动以跳过过程的第一个也是最昂贵的阶段。 在这种情况下，不需要复制段文件，恢复的事务日志重放阶段可以立即开始。 请注意，由于同步ID标记与flush一起使用，事务日志很可能是空的，加快了恢复的速度。

这对于具有很多从未或很少更新的索引（如基于时间的数据）的用例特别有用。 这个用例通常会产生很多索引，如果没有同步刷新标记，恢复将需要很长时间。


要检查一个分片是否有标记，查找由[indices stats](indices-stats.html)返回的分片统计信息的`commit`部分内容:
    
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

Synced Flush API允许管理员手动启动同步刷新。这对于计划（滚动）的群集重新启动非常有用，您可以在其中停止建立索引，并且不希望等待缺省索引的默认5分钟自动同步刷新。

虽然方便，这个API有几个警告：

  1. 同步刷新是尽力而为的操作。 任何正在进行的索引操作都将导致同步刷新在该分片上失败。 这意味着一些分片可能会被同步刷新，而另一些分片则不会被刷新。 请参阅下面的更多的信息。 
  2. 只要再次刷新分片，`sync_id`标记就会被删除。 这是因为flush会替换存储标记的低级lucene提交点。 事务日志中未提交的操作不会删除标记。 在实践中，我们应该考虑索引上的任何索引操作，因为Elasticsearch可以随时触发清除标记。



![Note](/images/icons/note.png)

正在进行索引时请求同步刷新是无害的。 闲置的分片将会成功，分片不会失败。 任何成功的分片将有更快的恢复时间。
    
    POST twitter/_flush/synced

该响应包含有关成功刷新了多少个分片的详细信息以及有关任何故障的信息。

以下是当两个分片和一个副本索引的所有分片成功同步刷新时的样子：

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

下面是一个分片组由于未决操作而失败的情况：    
    
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

由于并发索引操作，同步刷新失败时，会显示以上错误。 这种情况下的HTTP状态码将是`409 CONFLICT`。

有时故障是特定于分片副本的。 失败的副本将不具备快速恢复的资格，但成功的副本仍然会执行。 这个案例报道如下：
    
    
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

当分片复制无法同步刷新时，返回的HTTP状态代码将是“409 CONFLICT”。

同步的flush API可以通过一次调用应用于多个索引，甚至可以在_all这些索引上应用。
    
    
    POST kimchy,elasticsearch/_flush/synced
    
    POST _flush/synced
