## Search

The search API allows you to execute a search query and get back search hits that match the query. The query can either be provided using a simple [query string as a parameter](search-uri-request.html "URI Search"), or using a [request body](search-request-body.html "Request Body Search").

### Multi-Index, Multi-Type

All search APIs can be applied across multiple types within an index, and across multiple indices with support for the [multi index syntax](multi-index.html "Multiple Indices"). For example, we can search on all documents across all types within the twitter index:
    
    
    GET /twitter/_search?q=user:kimchy

We can also search within specific types:
    
    
    GET /twitter/tweet,user/_search?q=user:kimchy

We can also search all tweets with a certain tag across several indices (for example, when each user has his own index):
    
    
    GET /kimchy,elasticsearch/tweet/_search?q=tag:wow

Or we can search all tweets across all available indices using `_all` placeholder:
    
    
    GET /_all/tweet/_search?q=tag:wow

Or even search across all indices and all types:
    
    
    GET /_search?q=tag:wow

By default elasticsearch doesn’t reject any search requests based on the number of shards the request hits. While elasticsearch will optimize the search execution on the coordinating node a large number of shards can have a significant impact CPU and memory wise. It is usually a better idea to organize data in such a way that there are fewer larger shards. In case you would like to configure a soft limit, you can update the `action.search.shard_count.limit` cluster setting in order to reject search requests that hit too many shards.
