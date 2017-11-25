## `fields`

It is often useful to index the same field in different ways for different purposes. This is the purpose of _multi-fields_. For instance, a `string` field could be mapped as a `text` field for full-text search, and as a `keyword` field for sorting or aggregations:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "city": {
              "type": "text",
              "fields": {
                "raw": { ![](images/icons/callouts/1.png)
                  "type":  "keyword"
                }
              }
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "city": "New York"
    }
    
    PUT my_index/my_type/2
    {
      "city": "York"
    }
    
    GET my_index/_search
    {
      "query": {
        "match": {
          "city": "york" ![](images/icons/callouts/2.png)
        }
      },
      "sort": {
        "city.raw": "asc" ![](images/icons/callouts/3.png)
      },
      "aggs": {
        "Cities": {
          "terms": {
            "field": "city.raw" ![](images/icons/callouts/4.png)
          }
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The `city.raw` field is a `keyword` version of the `city` field.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `city` field can be used for full text search.   
  
![](images/icons/callouts/3.png) ![](images/icons/callouts/4.png)

| 

The `city.raw` field can be used for sorting and aggregations   
  
![Note](images/icons/note.png)

Multi-fields do not change the original `_source` field.

![Tip](images/icons/tip.png)

The `fields` setting is allowed to have different settings for fields of the same name in the same index. New multi-fields can be added to existing fields using the [PUT mapping API](indices-put-mapping.html "Put Mapping").

### Multi-fields with multiple analyzers

Another use case of multi-fields is to analyze the same field in different ways for better relevance. For instance we could index a field with the [`standard` analyzer](analysis-standard-analyzer.html "Standard Analyzer") which breaks text up into words, and again with the [`english` analyzer](analysis-lang-analyzer.html#english-analyzer "english analyzer") which stems words into their root form:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "text": { ![](images/icons/callouts/1.png)
              "type": "text",
              "fields": {
                "english": { ![](images/icons/callouts/2.png)
                  "type":     "text",
                  "analyzer": "english"
                }
              }
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    { "text": "quick brown fox" } ![](images/icons/callouts/3.png)
    
    PUT my_index/my_type/2
    { "text": "quick brown foxes" } ![](images/icons/callouts/4.png)
    
    GET my_index/_search
    {
      "query": {
        "multi_match": {
          "query": "quick brown foxes",
          "fields": [ ![](images/icons/callouts/5.png)
            "text",
            "text.english"
          ],
          "type": "most_fields" ![](images/icons/callouts/6.png)
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The `text` field uses the `standard` analyzer.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `text.english` field uses the `english` analyzer.   
  
![](images/icons/callouts/3.png) ![](images/icons/callouts/4.png)

| 

Index two documents, one with `fox` and the other with `foxes`.   
  
![](images/icons/callouts/5.png) ![](images/icons/callouts/6.png)

| 

Query both the `text` and `text.english` fields and combine the scores.   
  
The `text` field contains the term `fox` in the first document and `foxes` in the second document. The `text.english` field contains `fox` for both documents, because `foxes` is stemmed to `fox`.

The query string is also analyzed by the `standard` analyzer for the `text` field, and by the `english` analyzer` for the `text.english` field. The stemmed field allows a query for `foxes` to also match the document containing just `fox`. This allows us to match as many documents as possible. By also querying the unstemmed `text` field, we improve the relevance score of the document which matches `foxes` exactly.
