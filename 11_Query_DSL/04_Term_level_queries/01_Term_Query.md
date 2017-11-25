## Term Query

The `term` query finds documents that contain the **exact** term specified in the inverted index. For instance:
    
    
    POST _search
    {
      "query": {
        "term" : { "user" : "Kimchy" } ![](images/icons/callouts/1.png)
      }
    }

![](images/icons/callouts/1.png)

| 

Finds documents which contain the exact term `Kimchy` in the inverted index of the `user` field.   
  
---|---  
  
A `boost` parameter can be specified to give this `term` query a higher relevance score than another query, for instance:
    
    
    GET _search
    {
      "query": {
        "bool": {
          "should": [
            {
              "term": {
                "status": {
                  "value": "urgent",
                  "boost": 2.0 ![](images/icons/callouts/1.png)
                }
              }
            },
            {
              "term": {
                "status": "normal" ![](images/icons/callouts/2.png)
              }
            }
          ]
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The `urgent` query clause has a boost of `2.0`, meaning it is twice as important as the query clause for `normal`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `normal` clause has the default neutral boost of `1.0`.   
  
**Why doesn’t the`term` query match my document?**

String fields can be of type `text` (treated as full text, like the body of an email), or `keyword` (treated as exact values, like an email address or a zip code). Exact values (like numbers, dates, and keywords) have the exact value specified in the field added to the inverted index in order to make them searchable.

However, `text` fields are `analyzed`. This means that their values are first passed through an [analyzer](analysis.html "Analysis") to produce a list of terms, which are then added to the inverted index.

There are many ways to analyze text: the default [`standard` analyzer](analysis-standard-analyzer.html "Standard Analyzer") drops most punctuation, breaks up text into individual words, and lower cases them. For instance, the `standard` analyzer would turn the string “Quick Brown Fox!” into the terms [`quick`, `brown`, `fox`].

This analysis process makes it possible to search for individual words within a big block of full text.

The `term` query looks for the **exact** term in the field’s inverted index — it doesn’t know anything about the field’s analyzer. This makes it useful for looking up values in keyword fields, or in numeric or date fields. When querying full text fields, use the [`match` query](query-dsl-match-query.html "Match Query") instead, which understands how the field has been analyzed.

To demonstrate, try out the example below. First, create an index, specifying the field mappings, and index a document:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "full_text": {
              "type":  "text" ![](images/icons/callouts/1.png)
            },
            "exact_value": {
              "type":  "keyword" ![](images/icons/callouts/2.png)
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "full_text":   "Quick Foxes!", ![](images/icons/callouts/3.png)
      "exact_value": "Quick Foxes!"  ![](images/icons/callouts/4.png)
    }

![](images/icons/callouts/1.png)

| 

The `full_text` field is of type `text` and will be analyzed.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

The `exact_value` field is of type `keyword` and will NOT be analyzed.   
  
![](images/icons/callouts/3.png)

| 

The `full_text` inverted index will contain the terms: [`quick`, `foxes`].   
  
![](images/icons/callouts/4.png)

| 

The `exact_value` inverted index will contain the exact term: [`Quick Foxes!`].   
  
Now, compare the results for the `term` query and the `match` query:
    
    
    GET my_index/my_type/_search
    {
      "query": {
        "term": {
          "exact_value": "Quick Foxes!" ![](images/icons/callouts/1.png)
        }
      }
    }
    
    GET my_index/my_type/_search
    {
      "query": {
        "term": {
          "full_text": "Quick Foxes!" ![](images/icons/callouts/2.png)
        }
      }
    }
    
    GET my_index/my_type/_search
    {
      "query": {
        "term": {
          "full_text": "foxes" ![](images/icons/callouts/3.png)
        }
      }
    }
    
    GET my_index/my_type/_search
    {
      "query": {
        "match": {
          "full_text": "Quick Foxes!" ![](images/icons/callouts/4.png)
        }
      }
    }

![](images/icons/callouts/1.png)

| 

This query matches because the `exact_value` field contains the exact term `Quick Foxes!`.   
  
---|---  
  
![](images/icons/callouts/2.png)

| 

This query does not match, because the `full_text` field only contains the terms `quick` and `foxes`. It does not contain the exact term `Quick Foxes!`.   
  
![](images/icons/callouts/3.png)

| 

A `term` query for the term `foxes` matches the `full_text` field.   
  
![](images/icons/callouts/4.png)

| 

This `match` query on the `full_text` field first analyzes the query string, then looks for documents containing `quick` or `foxes` or both. 
