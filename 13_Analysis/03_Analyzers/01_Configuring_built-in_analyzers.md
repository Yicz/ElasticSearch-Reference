## Configuring built-in analyzers

The built-in analyzers can be used directly without any configuration. Some of them, however, support configuration options to alter their behaviour. For instance, the [`standard` analyzer](analysis-standard-analyzer.html) can be configured to support a list of stop words:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "std_english": { ![](images/icons/callouts/1.png)
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
              "analyzer": "standard", ![](images/icons/callouts/2.png)
              "fields": {
                "english": {
                  "type":     "text",
                  "analyzer": "std_english" ![](images/icons/callouts/3.png)
                }
              }
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "field": "my_text", ![](images/icons/callouts/4.png)
      "text": "The old brown cow"
    }
    
    POST my_index/_analyze
    {
      "field": "my_text.english", ![](images/icons/callouts/5.png)
      "text": "The old brown cow"
    }

![](images/icons/callouts/1.png)

| 

We define the `std_english` analyzer to be based on the `standard` analyzer, but configured to remove the pre-defined list of English stopwords.   
  
---|---  
  
![](images/icons/callouts/2.png) ![](images/icons/callouts/4.png)

| 

The `my_text` field uses the `standard` analyzer directly, without any configuration. No stop words will be removed from this field. The resulting terms are: `[ the, old, brown, cow ]`  
  
![](images/icons/callouts/3.png) ![](images/icons/callouts/5.png)

| 

The `my_text.english` field uses the `std_english` analyzer, so English stop words will be removed. The resulting terms are: `[ old, brown, cow ]`
