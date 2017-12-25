## Custom Analyzer

When the built-in analyzers do not fulfill your needs, you can create a `custom` analyzer which uses the appropriate combination of:

  * zero or more [character filters](analysis-charfilters.html)
  * a [tokenizer](analysis-tokenizers.html)
  * zero or more [token filters](analysis-tokenfilters.html). 



### Configuration

The `custom` analyzer accepts the following parameters:

`tokenizer`

| 

A built-in or customised [tokenizer](analysis-tokenizers.html). (Required)   
  
---|---  
  
`char_filter`

| 

An optional array of built-in or customised [character filters](analysis-charfilters.html).   
  
`filter`

| 

An optional array of built-in or customised [token filters](analysis-tokenfilters.html).   
  
`position_increment_gap`

| 

When indexing an array of text values, Elasticsearch inserts a fake) for more.   
  
### Example configuration

Here is an example that combines the following:

Character Filter 
    

  * [HTML Strip Character Filter](analysis-htmlstrip-charfilter.html)



Tokenizer 
    

  * [Standard Tokenizer](analysis-standard-tokenizer.html)



Token Filters 
    

  * [Lowercase Token Filter](analysis-lowercase-tokenfilter.html)
  * [ASCII-Folding Token Filter](analysis-asciifolding-tokenfilter.html)


    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_custom_analyzer": {
              "type":      "custom",
              "tokenizer": "standard",
              "char_filter": [
                "html_strip"
              ],
              "filter": [
                "lowercase",
                "asciifolding"
              ]
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_custom_analyzer",
      "text": "Is this <b>déjà vu</b>?"
    }

The above example produces the following terms:
    
    
    [ is, this, deja, vu ]

The previous example used tokenizer, token filters, and character filters with their default configurations, but it is possible to create configured versions of each and to use them in a custom analyzer.

Here is a more complicated example that combines the following:

Character Filter 
    

  * [Mapping Character Filter](analysis-mapping-charfilter.html), configured to replace `:)` with `_happy_` and `:(` with `_sad_`



Tokenizer 
    

  * [Pattern Tokenizer](analysis-pattern-tokenizer.html), configured to split on punctuation characters 



Token Filters 
    

  * [Lowercase Token Filter](analysis-lowercase-tokenfilter.html)
  * [Stop Token Filter](analysis-stop-tokenfilter.html), configured to use the pre-defined list of English stop words 



Here is an example:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_custom_analyzer": {
              "type": "custom",
              "char_filter": [
                "emoticons" ![](images/icons/callouts/1.png)
              ],
              "tokenizer": "punctuation", ![](images/icons/callouts/2.png)
              "filter": [
                "lowercase",
                "english_stop" ![](images/icons/callouts/3.png)
              ]
            }
          },
          "tokenizer": {
            "punctuation": { ![](images/icons/callouts/4.png)
              "type": "pattern",
              "pattern": "[ .,!?]"
            }
          },
          "char_filter": {
            "emoticons": { ![](images/icons/callouts/5.png)
              "type": "mapping",
              "mappings": [
                ":) => _happy_",
                ":( => _sad_"
              ]
            }
          },
          "filter": {
            "english_stop": { ![](images/icons/callouts/6.png)
              "type": "stop",
              "stopwords": "_english_"
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_custom_analyzer",
      "text":     "I'm a :) person, and you?"
    }

![](images/icons/callouts/1.png) ![](images/icons/callouts/2.png) ![](images/icons/callouts/3.png) ![](images/icons/callouts/4.png) ![](images/icons/callouts/5.png) ![](images/icons/callouts/6.png)

| 

The `emoticon` character filter, `punctuation` tokenizer and `english_stop` token filter are custom implementations which are defined in the same index settings.   
  
---|---  
  
The above example produces the following terms:
    
    
    [ i'm, _happy_, person, you ]
