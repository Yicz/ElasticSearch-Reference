## Stop Analyzer

The `stop` analyzer is the same as the [`simple` analyzer](analysis-simple-analyzer.html) but adds support for removing stop words. It defaults to using the `_english_` stop words.

### Definition

It consists of:

Tokenizer 
    

  * [Lower Case Tokenizer](analysis-lowercase-tokenizer.html)



Token filters 
    

  * [Stop Token Filter](analysis-stop-tokenfilter.html)



### Example output
    
    
    POST _analyze
    {
      "analyzer": "stop",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above sentence would produce the following terms:
    
    
    [ quick, brown, foxes, jumped, over, lazy, dog, s, bone ]

### Configuration

The `stop` analyzer accepts the following parameters:

`stopwords`

| 

A pre-defined stop words list like `_english_` or an array containing a list of stop words. Defaults to `_english_`.   
  
---|---  
  
`stopwords_path`

| 

The path to a file containing stop words. This path is relative to the Elasticsearch `config` directory.   
  
See the [Stop Token Filter](analysis-stop-tokenfilter.html) for more information about stop word configuration.

### Example configuration

In this example, we configure the `stop` analyzer to use a specified list of words as stop words:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_stop_analyzer": {
              "type": "stop",
              "stopwords": ["the", "over"]
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_stop_analyzer",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above example produces the following terms:
    
    
    [ quick, brown, foxes, jumped, lazy, dog, s, bone ]
