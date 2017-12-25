## Field Collapsing

Allows to collapse search results based on field values. The collapsing is done by selecting only the top sorted document per collapse key. For instance the query below retrieves the best tweet for each user and sorts them by number of likes.
    
    
    GET /twitter/tweet/_search
    {
        "query": {
            "match": {
                "message": "elasticsearch"
            }
        },
        "collapse" : {
            "field" : "user" ![](images/icons/callouts/1.png)
        },
        "sort": ["likes"], ![](images/icons/callouts/2.png)
        "from": 10 ![](images/icons/callouts/3.png)
    }

![](images/icons/callouts/1.png)

| 

collapse the result set using the "user" field   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

sort the top docs by number of likes   
  
![](images/icons/callouts/3.png)

| 

define the offset of the first collapsed result   
  
![Warning](images/icons/warning.png)

The total number of hits in the response indicates the number of matching documents without collapsing. The total number of distinct group is unknown.

The field used for collapsing must be a single valued [`keyword`](keyword.html) or [`numeric`](number.html) field with [`doc_values`](doc-values.html) activated

![Note](images/icons/note.png)

The collapsing is applied to the top hits only and does not affect aggregations.

### Expand collapse results

It is also possible to expand each collapsed top hits with the `inner_hits` option.
    
    
    GET /twitter/tweet/_search
    {
        "query": {
            "match": {
                "message": "elasticsearch"
            }
        },
        "collapse" : {
            "field" : "user", ![](images/icons/callouts/1.png)
            "inner_hits": {
                "name": "last_tweets", ![](images/icons/callouts/2.png)
                "size": 5, ![](images/icons/callouts/3.png)
                "sort": [{ "date": "asc" }] ![](images/icons/callouts/4.png)
            },
            "max_concurrent_group_searches": 4 ![](images/icons/callouts/5.png)
        },
        "sort": ["likes"]
    }

![](images/icons/callouts/1.png)

| 

collapse the result set using the "user" field   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

the name used for the inner hit div in the response   
  
![](images/icons/callouts/3.png)

| 

the number of inner_hits to retrieve per collapse key   
  
![](images/icons/callouts/4.png)

| 

how to sort the document inside each group   
  
![](images/icons/callouts/5.png)

| 

the number of concurrent requests allowed to retrieve the inner_hits` per group   
  
See [inner hits](search-request-inner-hits.html) for the complete list of supported options and the format of the response.

The expansion of the group is done by sending an additional query for each collapsed hit returned in the response. The `max_concurrent_group_searches` request parameter can be used to control the maximum number of concurrent searches allowed in this phase. The default is based on the number of data nodes and the default search thread pool size.

![Warning](images/icons/warning.png)

`collapse` cannot be used in conjunction with [scroll](search-request-scroll.html), [rescore](search-request-rescore.html) or [search after](search-request-search-after.html).
