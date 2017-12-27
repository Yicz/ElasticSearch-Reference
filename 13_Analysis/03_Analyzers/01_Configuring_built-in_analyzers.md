## Configuring built-in analyzers

The built-in analyzers can be used directly without any configuration. Some of them, however, support configuration options to alter their behaviour. For instance, the [`standard` analyzer](analysis-standard-analyzer.html) can be configured to support a list of stop words:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "std_english": { #1
              "type":      "standard",
              "stopwords": "_english_"
            }
          }
        }
      },
      "mappings": {
        "my_type": {
          "properties": {
            "my_text": {
              "type":     "text",
              "analyzer": "standard", #2
              "fields": {
                "english": {
                  "type":     "text",
                  "analyzer": "std_english" #3
                }
              }
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "field": "my_text", #4
      "text": "The old brown cow"
    }
    
    POST my_index/_analyze
    {
      "field": "my_text.english", #5
      "text": "The old brown cow"
    }

#1| We define the `std_english` analyzer to be based on the `standard` analyzer, but configured to remove the pre-defined list of English stopwords. 
---|---    
#2 #4| The `my_text` field uses the `standard` analyzer directly, without any configuration. No stop words will be removed from this field. The resulting terms are: `[ the, old, brown, cow ]`    \
#3 #5| The `my_text.english` field uses the `std_english` analyzer, so English stop words will be removed. The resulting terms are: `[ old, brown, cow ]`
