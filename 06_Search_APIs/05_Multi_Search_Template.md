## Multi Search Template

The multi search template API allows to execute several search template requests within the same API using the `_msearch/template` endpoint.

The format of the request is similar to the [Multi Search API](search-multi-search.html "Multi Search API") format:
    
    
    header\n
    body\n
    header\n
    body\n

The header part supports the same `index`, `types`, `search_type`, `preference`, and `routing` options as the usual Multi Search API.

The body includes a search template body request and supports inline, stored and file templates. Here is an example:
    
    
    $ cat requests
    {"index": "test"}
    {"inline": {"query": {"match":  {"user" : "{ {username} }" } } }, "params": {"username": "john"} } ![](images/icons/callouts/1.png)
    {"index": "_all", "types": "accounts"}
    {"inline": {"query": {"{ {query_type} }": {"name": "{ {name} }" } } }, "params": {"query_type": "match_phrase_prefix", "name": "Smith"} }
    {"index": "_all"}
    {"id": "template_1", "params": {"query_string": "search for these words" } } ![](images/icons/callouts/2.png)
    {"types": "users"}
    {"file": "template_2", "params": {"field_name": "fullname", "field_value": "john smith" } } ![](images/icons/callouts/3.png)
    
    $ curl -H "Content-Type: application/x-ndjson" -XGET localhost:9200/_msearch/template --data-binary "@requests"; echo

![](images/icons/callouts/1.png)

| 

Inline search template request   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

Search template request based on a stored template   
  
![](images/icons/callouts/3.png)

| 

Search template request based on a file template   
  
The response returns a `responses` array, which includes the search template response for each search template request matching its order in the original multi search template request. If there was a complete failure for that specific search template request, an object with `error` message will be returned in place of the actual search response.
