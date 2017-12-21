## `position_increment_gap`

[Analyzed](mapping-index.html "index") text fields take term [positions](index-options.html "index_options") into account, in order to be able to support [proximity or phrase queries](query-dsl-match-query-phrase.html "Match Phrase Query"). When indexing text fields with multiple values a "fake" gap is added between the values to prevent most phrase queries from matching across the values. The size of this gap is configured using `position_increment_gap` and defaults to `100`.

For example:
    
    
    PUT my_index/groups/1
    {
        "names": [ "John Abraham", "Lincoln Smith"]
    }
    
    GET my_index/groups/_search
    {
        "query": {
            "match_phrase": {
                "names": {
                    "query": "Abraham Lincoln" ![](images/icons/callouts/1.png)
                }
            }
        }
    }
    
    GET my_index/groups/_search
    {
        "query": {
            "match_phrase": {
                "names": {
                    "query": "Abraham Lincoln",
                    "slop": 101 ![](images/icons/callouts/2.png)
                }
            }
        }
    }

![](images/icons/callouts/1.png)

| 

This phrase query doesn’t match our document which is totally expected.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This phrase query matches our document, even though `Abraham` and `Lincoln` are in separate strings, because `slop` > `position_increment_gap`.   
  
The `position_increment_gap` can be specified in the mapping. For instance:
    
    
    PUT my_index
    {
      "mappings": {
        "groups": {
          "properties": {
            "names": {
              "type": "text",
              "position_increment_gap": 0 ![](images/icons/callouts/1.png)
            }
          }
        }
      }
    }
    
    PUT my_index/groups/1
    {
        "names": [ "John Abraham", "Lincoln Smith"]
    }
    
    GET my_index/groups/_search
    {
        "query": {
            "match_phrase": {
                "names": "Abraham Lincoln" ![](images/icons/callouts/2.png)
            }
        }
    }

![](images/icons/callouts/1.png)

| 

The first term in the next array element will be 0 terms apart from the last term in the previous array element.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The phrase query matches our document which is weird, but its what we asked for in the mapping.   
  
![Tip](images/icons/tip.png)

The `position_increment_gap` setting is allowed to have different settings for fields of the same name in the same index. Its value can be updated on existing fields using the [PUT mapping API](indices-put-mapping.html "Put Mapping").
