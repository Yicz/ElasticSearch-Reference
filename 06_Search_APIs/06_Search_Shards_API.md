## Search Shards API

The search shards api returns the indices and shards that a search request would be executed against. This can give useful feedback for working out issues or planning optimizations with routing and shard preferences. When filtered aliases are used, the filter is returned as part of the `indices` div  [5.1.0] Added in 5.1.0. .

The `index` and `type` parameters may be single values, or comma-separated.

The `type` parameter is deprecated  [5.1.0] Deprecated in 5.1.0. was ignored in previous versions .

### Usage

Full example:
    
    
    GET /twitter/_search_shards

This will yield the following result:
    
    
    {
      "nodes": ...,
      "indices" : {
        "twitter": { }
      },
      "shards": [
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 0,
            "state": "STARTED",
            "allocation_id": {"id":"0TvkCyF7TAmM1wHP4a42-A"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 1,
            "state": "STARTED",
            "allocation_id": {"id":"fMju3hd1QHWmWrIgFnI4Ww"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 2,
            "state": "STARTED",
            "allocation_id": {"id":"Nwl0wbMBTHCWjEEbGYGapg"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 3,
            "state": "STARTED",
            "allocation_id": {"id":"bU_KLGJISbW0RejwnwDPKw"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 4,
            "state": "STARTED",
            "allocation_id": {"id":"DMs7_giNSwmdqVukF7UydA"},
            "relocating_node": null
          }
        ]
      ]
    }

And specifying the same request, this time with a routing value:
    
    
    GET /twitter/_search_shards?routing=foo,baz

This will yield the following result:
    
    
    {
      "nodes": ...,
      "indices" : {
          "twitter": { }
      },
      "shards": [
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 0,
            "state": "STARTED",
            "allocation_id": {"id":"0TvkCyF7TAmM1wHP4a42-A"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 1,
            "state": "STARTED",
            "allocation_id": {"id":"fMju3hd1QHWmWrIgFnI4Ww"},
            "relocating_node": null
          }
        ]
      ]
    }

This time the search will only be executed against two of the shards, because routing values have been specified.

### All parameters:

`routing`

| 

A comma-separated list of routing values to take into account when determining which shards a request would be executed against.   
  
---|---  
  
`preference`

| 

Controls a `preference` of which shard replicas to execute the search request on. By default, the operation is randomized between the shard replicas. See the [preference](search-request-preference.html) documentation for a list of all acceptable values.   
  
`local`

| 

A boolean value whether to read the cluster state locally in order to determine where shards are allocated instead of using the Master node’s cluster state. 
