# 索引模块 Index Modules

Index Modules are modules created per index and control all aspects related to an index.

## Index Settings

Index level settings can be set per-index. Settings may be:

_static_
     They can only be set at index creation time or on a [closed index](indices-open-close.html "Open / Close Index API"). 
_dynamic_
     They can be changed on a live index using the [update-index-settings](indices-update-settings.html "Update Indices Settings") API. 

![Warning](images/icons/warning.png)

Changing static or dynamic index settings on a closed index could result in incorrect settings that are impossible to rectify without deleting and recreating the index.

### Static index settings

Below is a list of all _static_ index settings that are not associated with any specific index module:

`index.number_of_shards`
     The number of primary shards that an index should have. Defaults to 5. This setting can only be set at index creation time. It cannot be changed on a closed index. Note: the number of shards are limited to `1024` per index. This limitation is a safety limit to prevent accidental creation of indices that can destabilize a cluster due to resource allocation. The limit can be modified by specifying `export ES_JAVA_OPTS="-Des.index.max_number_of_shards=128"` system property on every node that is part of the cluster. 
`index.shard.check_on_startup`
    

[ experimental] This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features. Whether or not shards should be checked for corruption before opening. When corruption is detected, it will prevent the shard from being opened. Accepts:

`false`
     (default) Don’t check for corruption when opening a shard. 
`checksum`
     Check for physical corruption. 
`true`
     Check for both physical and logical corruption. This is much more expensive in terms of CPU and memory usage. 
`fix`
     Check for both physical and logical corruption. Segments that were reported as corrupted will be automatically removed. This option **may result in data loss**. Use with extreme caution! 

Checking shards may take a lot of time on large indices.

`index.codec`
     The `default` value compresses stored data with LZ4 compression, but this can be set to `best_compression` which uses [DEFLATE](https://en.wikipedia.org/wiki/DEFLATE) for a higher compression ratio, at the expense of slower stored fields performance. 
`index.routing_partition_size`
     The number of shards a custom [routing](mapping-routing-field.html "_routing field") value can go to. Defaults to 1 and can only be set at index creation time. This value must be less than the `index.number_of_shards` unless the `index.number_of_shards` value is also 1. See [Routing to an index partition](mapping-routing-field.html#routing-index-partition "Routing to an index partition") for more details about how this setting is used. 

### Dynamic index settings

Below is a list of all _dynamic_ index settings that are not associated with any specific index module:

`index.number_of_replicas`
     The number of replicas each primary shard has. Defaults to 1. 
`index.auto_expand_replicas`
     Auto-expand the number of replicas based on the number of available nodes. Set to a dash delimited lower and upper bound (e.g. `0-5`) or use `all` for the upper bound (e.g. `0-all`). Defaults to `false` (i.e. disabled). 
`index.refresh_interval`
     How often to perform a refresh operation, which makes recent changes to the index visible to search. Defaults to `1s`. Can be set to `-1` to disable refresh. 
`index.max_result_window`
     The maximum value of `from + size` for searches to this index. Defaults to `10000`. Search requests take heap memory and time proportional to `from + size` and this limits that memory. See [Scroll](search-request-scroll.html "Scroll") or [Search After](search-request-search-after.html "Search After") for a more efficient alternative to raising this. 
`index.max_rescore_window`
     The maximum value of `window_size` for `rescore` requests in searches of this index. Defaults to `index.max_result_window` which defaults to `10000`. Search requests take heap memory and time proportional to `max(window_size, from + size)` and this limits that memory. 
`index.blocks.read_only`
     Set to `true` to make the index and index metadata read only, `false` to allow writes and metadata changes. 
`index.blocks.read`
     Set to `true` to disable read operations against the index. 
`index.blocks.write`
     Set to `true` to disable write operations against the index. 
`index.blocks.metadata`
     Set to `true` to disable index metadata reads and writes. 
`index.max_refresh_listeners`
     Maximum number of refresh listeners available on each shard of the index. These listeners are used to implement [`refresh=wait_for`](docs-refresh.html "?refresh"). 

### Settings in other index modules

Other index settings are available in index modules:

[Analysis](analysis.html "Analysis")
     Settings to define analyzers, tokenizers, token filters and character filters. 
[Index shard allocation](index-modules-allocation.html "Index Shard Allocation")
     Control over where, when, and how shards are allocated to nodes. 
[Mapping](index-modules-mapper.html "Mapper")
     Enable or disable dynamic mapping for an index. 
[Merging](index-modules-merge.html "Merge")
     Control over how shards are merged by the background merge process. 
[Similarities](index-modules-similarity.html "Similarity module")
     Configure custom similarity settings to customize how search results are scored. 
[Slowlog](index-modules-slowlog.html "Slow Log")
     Control over how slow queries and fetch requests are logged. 
[Store](index-modules-store.html "Store")
     Configure the type of filesystem used to access shard data. 
[Translog](index-modules-translog.html "Translog")
     Control over the transaction log and background flush operations. 
