## Shard request cache

When a search request is run against an index or against many indices, each involved shard executes the search locally and returns its local results to the _coordinating node_ , which combines these shard-level results into a “global” result set.

The shard-level request cache module caches the local results on each shard. This allows frequently used (and potentially heavy) search requests to return results almost instantly. The requests cache is a very good fit for the logging use case, where only the most recent index is being actively updated — results from older indices will be served directly from the cache.

![Important](images/icons/important.png)

By default, the requests cache will only cache the results of search requests where `size=0`, so it will not cache `hits`, but it will cache `hits.total`, [aggregations](search-aggregations.html), and [suggestions](search-suggesters.html).

Most queries that use `now` (see [Date Math cannot be cached.

#### Cache invalidation

The cache is smart — it keeps the same _near real-time_ promise as uncached search.

Cached results are invalidated automatically whenever the shard refreshes, but only if the data in the shard has actually changed. In other words, you will always get the same results from the cache as you would for an uncached search request.

The longer the refresh interval, the longer that cached entries will remain valid. If the cache is full, the least recently used cache keys will be evicted.

The cache can be expired manually with the [`clear-cache` API](indices-clearcache.html):
    
    
    POST /kimchy,elasticsearch/_cache/clear?request=true

#### Enabling and disabling caching

The cache is enabled by default, but can be disabled when creating a new index as follows:
    
    
    PUT /my_index
    {
      "settings": {
        "index.requests.cache.enable": false
      }
    }

It can also be enabled or disabled dynamically on an existing index with the [`update-settings`](indices-update-settings.html) API:
    
    
    PUT /my_index/_settings
    { "index.requests.cache.enable": true }

#### Enabling and disabling caching per request

The `request_cache` query-string parameter can be used to enable or disable caching on a **per-request** basis. If set, it overrides the index-level setting:
    
    
    GET /my_index/_search?request_cache=true
    {
      "size": 0,
      "aggs": {
        "popular_colors": {
          "terms": {
            "field": "colors"
          }
        }
      }
    }

![Important](images/icons/important.png)

If your query uses a script whose result is not deterministic (e.g. it uses a random function or references the current time) you should set the `request_cache` flag to `false` to disable caching for that request.

Requests `size` is greater than 0 will not be cached even if the request cache is enabled in the index settings. To cache these requests you will need to use the query-string parameter detailed here.

#### Cache key

The whole JSON body is used as the cache key. This means that if the JSON changes — for instance if keys are output in a different order — then the cache key will not be recognised.

![Tip](images/icons/tip.png)

Most JSON libraries support a _canonical_ mode which ensures that JSON keys are always emitted in the same order. This canonical mode can be used in the application to ensure that a request is always serialized in the same way.

#### Cache settings

The cache is managed at the node level, and has a default maximum size of `1%` of the heap. This can be changed in the `config/elasticsearch.yml` file with:
    
    
    indices.requests.cache.size: 2%

Also, you can use the `indices.requests.cache.expire` setting to specify a TTL for cached results, but there should be no reason to do so. Remember that stale results are automatically invalidated when the index is refreshed. This setting is provided for completeness' sake only.

#### Monitoring cache usage

The size of the cache (in bytes) and the number of evictions can be viewed by index, with the [`indices-stats`](indices-stats.html) API:
    
    
    GET /_stats/request_cache?human

or by node with the [`nodes-stats`](cluster-nodes-stats.html) API:
    
    
    GET /_nodes/stats/indices/request_cache?human