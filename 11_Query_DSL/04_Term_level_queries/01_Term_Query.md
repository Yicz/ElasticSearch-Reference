## 词条（项）查询 Term Query

`term`查询查找包含在倒排索引中指定的**确切**项的文档。 例如：    
    
    POST _search
    {
      "query": {
        "term" : { "user" : "Kimchy" } <1>
      }
    }

<1>| 在`user`字段的倒排索引中查找包含确切名词`Kimchy`的文档。     
---|---  
  
可以指定`boost`参数来给这个`term`查询一个比另一个查询更高的相关性分数，例如：    
    
    GET _search
    {
      "query": {
        "bool": {
          "should": [
            {
              "term": {
                "status": {
                  "value": "urgent",
                  "boost": 2.0 <1>
                }
              }
            },
            {
              "term": {
                "status": "normal" <2>
              }
            }
          ]
        }
      }
    }

<1>| `urgent`查询子句有`2.0`的提升，这意味着它是`normal`的查询子句的两倍。    
---|---    
<2>| `normal`字段默认提升了`1.0`。   
  
**为什么`term`查询不到文档**

String fields can be of type `text` (treated as full text, like the body of an email), or `keyword` (treated as exact values, like an email address or a zip code). Exact values (like numbers, dates, and keywords) have the exact value specified in the field added to the inverted index in order to make them searchable.

However, `text` fields are `analyzed`. This means that their values are first passed through an [analyzer](analysis.html) to produce a list of terms, which are then added to the inverted index.

There are many ways to analyze text: the default [`standard` analyzer](analysis-standard-analyzer.html) drops most punctuation, breaks up text into individual words, and lower cases them. For instance, the `standard` analyzer would turn the string “Quick Brown Fox!” into the terms [`quick`, `brown`, `fox`].

This analysis process makes it possible to search for individual words within a big block of full text.

The `term` query looks for the **exact** term in the field’s inverted index — it doesn’t know anything about the field’s analyzer. This makes it useful for looking up values in keyword fields, or in numeric or date fields. When querying full text fields, use the [`match` query](query-dsl-match-query.html) instead, which understands how the field has been analyzed.

To demonstrate, try out the example below. First, create an index, specifying the field mappings, and index a document:
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "full_text": {
              "type":  "text" <1>
            },
            "exact_value": {
              "type":  "keyword" <2>
            }
          }
        }
      }
    }
    
    PUT my_index/my_type/1
    {
      "full_text":   "Quick Foxes!", <3>
      "exact_value": "Quick Foxes!"  <4>
    }

<1>| The `full_text` field is of type `text` and will be analyzed.     
---|---    
<2>| The `exact_value` field is of type `keyword` and will NOT be analyzed.    
<3>| The `full_text` inverted index will contain the terms: [`quick`, `foxes`].     
<4>| The `exact_value` inverted index will contain the exact term: [`Quick Foxes!`].   
  
Now, compare the results for the `term` query and the `match` query:
    
    
    GET my_index/my_type/_search
    {
      "query": {
        "term": {
          "exact_value": "Quick Foxes!" <1>
        }
      }
    }
    
    GET my_index/my_type/_search
    {
      "query": {
        "term": {
          "full_text": "Quick Foxes!" <2>
        }
      }
    }
    
    GET my_index/my_type/_search
    {
      "query": {
        "term": {
          "full_text": "foxes" <3>
        }
      }
    }
    
    GET my_index/my_type/_search
    {
      "query": {
        "match": {
          "full_text": "Quick Foxes!" <4>
        }
      }
    }

<1>| This query matches because the `exact_value` field contains the exact term `Quick Foxes!`.     
---|---   
<2>| This query does not match, because the `full_text` field only contains the terms `quick` and `foxes`. It does not contain the exact term `Quick Foxes!`.     
<3>| A `term` query for the term `foxes` matches the `full_text` field.     
<4>| This `match` query on the `full_text` field first analyzes the query string, then looks for documents containing `quick` or `foxes` or both. 
