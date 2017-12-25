## From / Size

Pagination of results can be done by using the `from` and `size` parameters. The `from` parameter defines the offset from the first result you want to fetch. The `size` parameter allows you to configure the maximum amount of hits to be returned.

Though `from` and `size` can be set as request parameters, they can also be set within the search body. `from` defaults to `0`, and `size` defaults to `10`.
    
    
    GET /_search
    {
        "from" : 0, "size" : 10,
        "query" : {
            "term" : { "user" : "kimchy" }
        }
    }

Note that `from` \+ `size` can not be more than the `index.max_result_window` index setting which defaults to 10,000. See the [Scroll](search-request-scroll.html) or [Search After](search-request-search-after.html) API for more efficient ways to do deep scrolling.