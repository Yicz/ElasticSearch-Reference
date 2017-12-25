## Scroll

While a `search` request returns a single “page” of results, the `scroll` API can be used to retrieve large numbers of results (or even all results) from a single search request, in much the same way as you would use a cursor on a traditional database.

Scrolling is not intended for real time user requests, but rather for processing large amounts of data, e.g. in order to reindex the contents of one index into a new index with a different configuration.

 **Client support for scrolling and reindexing**

Some of the officially supported clients provide helpers to assist with scrolled searches and reindexing of documents from one index to another:

Perl 
     See [Search::Elasticsearch::Client::5_0::Bulk](https://metacpan.org/pod/Search::Elasticsearch::Client::5_0::Bulk) and [Search::Elasticsearch::Client::5_0::Scroll](https://metacpan.org/pod/Search::Elasticsearch::Client::5_0::Scroll)
Python 
     See [elasticsearch.helpers.*](http://elasticsearch-py.readthedocs.org/en/master/helpers.html)

![Note](images/icons/note.png)

The results that are returned from a scroll request reflect the state of the index at the time that the initial `search` request was made, like a snapshot in time. Subsequent changes to documents (index, update or delete) will only affect later search requests.

In order to use scrolling, the initial search request should specify the `scroll` parameter in the query string, which tells Elasticsearch how long it should keep the “search context” alive (see [Keeping the search context alive](search-request-scroll.html#scroll-search-context)), eg `?scroll=1m`.
    
    
    POST /twitter/tweet/_search?scroll=1m
    {
        "size": 100,
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        }
    }

The result from the above request includes a `_scroll_id`, which should be passed to the `scroll` API in order to retrieve the next batch of results.
    
    
    POST ![](images/icons/callouts/1.png) /_search/scroll ![](images/icons/callouts/2.png)
    {
        "scroll" : "1m", ![](images/icons/callouts/3.png)
        "scroll_id" : "DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ==" ![](images/icons/callouts/4.png)
    }

![](images/icons/callouts/1.png)

| 

`GET` or `POST` can be used.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The URL should not include the `index` or `type` name — these are specified in the original `search` request instead.   
  
![](images/icons/callouts/3.png)

| 

The `scroll` parameter tells Elasticsearch to keep the search context open for another `1m`.   
  
![](images/icons/callouts/4.png)

| 

The `scroll_id` parameter   
  
The `size` parameter allows you to configure the maximum number of hits to be returned with each batch of results. Each call to the `scroll` API returns the next batch of results until there are no more results left to return, ie the `hits` array is empty.

![Important](images/icons/important.png)

The initial search request and each subsequent scroll request returns a new `_scroll_id` — only the most recent `_scroll_id` should be used.

![Note](images/icons/note.png)

If the request specifies aggregations, only the initial search response will contain the aggregations results.

![Note](images/icons/note.png)

Scroll requests have optimizations that make them faster when the sort order is `_doc`. If you want to iterate over all documents regardless of the order, this is the most efficient option:
    
    
    GET /_search?scroll=1m
    {
      "sort": [
        "_doc"
      ]
    }

### Keeping the search context alive

The `scroll` parameter (passed to the `search` request and to every `scroll` request) tells Elasticsearch how long it should keep the search context alive. Its value (e.g. `1m`, see [Time units sets a new expiry time.

Normally, the background merge process optimizes the index by merging together smaller segments to create new bigger segments, at which time the smaller segments are deleted. This process continues during scrolling, but an open search context prevents the old segments from being deleted while they are still in use. This is how Elasticsearch is able to return the results of the initial search request, regardless of subsequent changes to documents.

![Tip](images/icons/tip.png)

Keeping older segments alive means that more file handles are needed. Ensure that you have configured your nodes to have ample free file handles. See [File Descriptors](file-descriptors.html).

You can check how many search contexts are open with the [nodes stats API](cluster-nodes-stats.html):
    
    
    GET /_nodes/stats/indices/search

### Clear scroll API

Search context are automatically removed when the `scroll` timeout has been exceeded. However keeping scrolls open has a cost, as discussed in the [previous div](search-request-scroll.html#scroll-search-context) so scrolls should be explicitly cleared as soon as the scroll is not being used anymore using the `clear-scroll` API:
    
    
    DELETE /_search/scroll
    {
        "scroll_id" : ["DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ=="]
    }

Multiple scroll IDs can be passed as array:
    
    
    DELETE /_search/scroll
    {
        "scroll_id" : [
          "DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ==",
          "DnF1ZXJ5VGhlbkZldGNoBQAAAAAAAAABFmtSWWRRWUJrU2o2ZExpSGJCVmQxYUEAAAAAAAAAAxZrUllkUVlCa1NqNmRMaUhiQlZkMWFBAAAAAAAAAAIWa1JZZFFZQmtTajZkTGlIYkJWZDFhQQAAAAAAAAAFFmtSWWRRWUJrU2o2ZExpSGJCVmQxYUEAAAAAAAAABBZrUllkUVlCa1NqNmRMaUhiQlZkMWFB"
        ]
    }

All search contexts can be cleared with the `_all` parameter:
    
    
    DELETE /_search/scroll/_all

The `scroll_id` can also be passed as a query string parameter or in the request body. Multiple scroll IDs can be passed as comma separated values:
    
    
    DELETE /_search/scroll/DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAD4WYm9laVYtZndUQlNsdDcwakFMNjU1QQ==,DnF1ZXJ5VGhlbkZldGNoBQAAAAAAAAABFmtSWWRRWUJrU2o2ZExpSGJCVmQxYUEAAAAAAAAAAxZrUllkUVlCa1NqNmRMaUhiQlZkMWFBAAAAAAAAAAIWa1JZZFFZQmtTajZkTGlIYkJWZDFhQQAAAAAAAAAFFmtSWWRRWUJrU2o2ZExpSGJCVmQxYUEAAAAAAAAABBZrUllkUVlCa1NqNmRMaUhiQlZkMWFB

### Sliced Scroll

For scroll queries that return a lot of documents it is possible to split the scroll in multiple slices which can be consumed independently:
    
    
    GET /twitter/tweet/_search?scroll=1m
    {
        "slice": {
            "id": 0, ![](images/icons/callouts/1.png)
            "max": 2 ![](images/icons/callouts/2.png)
        },
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        }
    }
    GET /twitter/tweet/_search?scroll=1m
    {
        "slice": {
            "id": 1,
            "max": 2
        },
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        }
    }

![](images/icons/callouts/1.png)

| 

The id of the slice   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The maximum number of slices   
  
The result from the first request returned documents that belong to the first slice (id: 0) and the result from the second request returned documents that belong to the second slice. Since the maximum number of slices is set to 2 the union of the results of the two requests is equivalent to the results of a scroll query without slicing. By default the splitting is done on the shards first and then locally on each shard using the _uid field with the following formula: `slice(doc) = floorMod(hashCode(doc._uid), max)` For instance if the number of shards is equal to 2 and the user requested 4 slices then the slices 0 and 2 are assigned to the first shard and the slices 1 and 3 are assigned to the second shard.

Each scroll is independent and can be processed in parallel like any scroll request.

![Note](images/icons/note.png)

If the number of slices is bigger than the number of shards the slice filter is very slow on the first calls, it has a complexity of O(N) and a memory cost equals to N bits per slice where N is the total number of documents in the shard. After few calls the filter should be cached and subsequent calls should be faster but you should limit the number of sliced query you perform in parallel to avoid the memory explosion.

To avoid this cost entirely it is possible to use the `doc_values` of another field to do the slicing but the user must ensure that the field has the following properties:

  * The field is numeric. 
  * `doc_values` are enabled on that field 
  * Every document should contain a single value. If a document has multiple values for the specified field, the first value is used. 
  * The value for each document should be set once when the document is created and never updated. This ensures that each slice gets deterministic results. 
  * The cardinality of the field should be high. This ensures that each slice gets approximately the same amount of documents. 


    
    
    GET /twitter/tweet/_search?scroll=1m
    {
        "slice": {
            "field": "date",
            "id": 0,
            "max": 10
        },
        "query": {
            "match" : {
                "title" : "elasticsearch"
            }
        }
    }

For append only time-based indices, the `timestamp` field can be used safely.

![Note](images/icons/note.png)

By default the maximum number of slices allowed per scroll is limited to 1024. You can update the `index.max_slices_per_scroll` index setting to bypass this limit.