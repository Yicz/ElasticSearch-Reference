## HTML Strip Char Filter

The `html_strip` character filter strips HTML elements from the text and replaces HTML entities with their decoded value (e.g. replacing `&amp;` with `&`).

### Example output
    
    
    POST _analyze
    {
      "tokenizer":      "keyword", ![](images/icons/callouts/1.png)
      "char_filter":  [ "html_strip" ],
      "text": "<p>I&apos;m so <b>happy</b>!</p>"
    }

![](images/icons/callouts/1.png)

| 

The [`keyword` tokenizer](analysis-keyword-tokenizer.html) returns a single term.   
  
---|---  
  
The above example returns the term:
    
    
    [ \nI'm so happy!\n ]

The same example with the `standard` tokenizer would return the following terms:
    
    
    [ I'm, so, happy ]

### Configuration

The `html_strip` character filter accepts the following parameter:

`escaped_tags`

| 

An array of HTML tags which should not be stripped from the original text.   
  
---|---  
  
### Example configuration

In this example, we configure the `html_strip` character filter to leave `<b>` tags in place:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_analyzer": {
              "tokenizer": "keyword",
              "char_filter": ["my_char_filter"]
            }
          },
          "char_filter": {
            "my_char_filter": {
              "type": "html_strip",
              "escaped_tags": ["b"]
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "<p>I&apos;m so <b>happy</b>!</p>"
    }

The above example produces the following term:
    
    
    [ \nI'm so <b>happy</b>!\n ]
