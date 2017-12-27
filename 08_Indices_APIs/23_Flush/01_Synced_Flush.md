## Synced Flush

Elasticsearch tracks the indexing activity of each shard. Shards that have not received any indexing operations for 5 minutes are automatically marked as inactive. This presents an opportunity for Elasticsearch to reduce shard resources and also perform a special kind of flush, called `synced flush`. A synced flush performs a normal flush, then adds a generated unique marker (sync_id) to all shards.

Since the sync id marker was added when there were no ongoing indexing operations, it can be used as a quick way to check if the two shards' lucene indices are identical. This quick sync id comparison (if present) is used during recovery or restarts to skip the first and most costly phase of the process. In that case, no segment files need to be copied and the transaction log replay phase of the recovery can start immediately. Note that since the sync id marker was applied together with a flush, it is very likely that the transaction log will be empty, speeding up recoveries even more.

This is particularly useful for use cases having lots of indices which are never or very rarely updated, such as time based data. This use case typically generates lots of indices whose recovery without the synced flush marker would take a long time.

To check whether a shard has a marker or not, look for the `commit` div of shard stats returned by the [indices stats](indices-stats.html) API:
    
    
    GET twitter/_stats?level=shards

which returns something similar to:
    
    
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

<1>| the `sync id` marker     
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
