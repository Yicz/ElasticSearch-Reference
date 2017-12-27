## Testing analyzers

The [`analyze` API](indices-analyze.html) is an invaluable tool for viewing the terms produced by an analyzer. A built-in analyzer (or combination of built-in tokenizer, token filters, and character filters) can be specified inline in the request:
    
    
    POST _analyze
    {
      "analyzer": "whitespace",
      "text":     "The quick brown fox."
    }
    
    POST _analyze
    {
      "tokenizer": "standard",
      "filter":  [ "lowercase", "asciifolding" ],
      "text":      "Is this déja vu?"
    }

 **Positions and character offsets**

As can be seen from the output of the `analyze` API, analyzers not only convert words into terms, they also record the order or relative _positions_ of each term (used for phrase queries or word proximity queries), and the start and end _character offsets_ of each term in the original text (used for highlighting search snippets).

Alternatively, a [`custom` analyzer](analysis-custom-analyzer.html) can be referred to when running the `analyze` API on a specific index:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "std_folded": { <1>
              "type": "custom",
              "tokenizer": "standard",
              "filter": [
                "lowercase",
                "asciifolding"
              ]
            }
          }
        }
      },
      "mappings": {
        "my_type": {
          "properties": {
            "my_text": {
              "type": "text",
              "analyzer": "std_folded" <2>
            }
          }
        }
      }
    }
    
    GET my_index/_analyze <3>
    {
      "analyzer": "std_folded", <4>
      "text":     "Is this déjà vu?"
    }
    
    GET my_index/_analyze <5>
    {
      "field": "my_text", <6>
      "text":  "Is this déjà vu?"
    }

<1>| Define a `custom` analyzer called `std_folded`.     
---|---    
<2>| The field `my_text` uses the `std_folded` analyzer.     <3> 
<5>| To refer to this analyzer, the `analyze` API must specify the index name.     
<4>| Refer to the analyzer by name.     
<6>| Refer to the analyzer used by field `my_text`. 