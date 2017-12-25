## Standard Analyzer

The `standard` analyzer is the default analyzer which is used if none is specified. It provides grammar based tokenization (based on the Unicode Text Segmentation algorithm, as specified in [Unicode Standard Annex #29](http://unicode.org/reports/tr29/)) and works well for most languages.

### Definition

It consists of:

Tokenizer 
    

  * [Standard Tokenizer](analysis-standard-tokenizer.html)



Token Filters 
    

  * [Standard Token Filter](analysis-standard-tokenfilter.html)
  * [Lower Case Token Filter](analysis-lowercase-tokenfilter.html)
  * [Stop Token Filter](analysis-stop-tokenfilter.html) (disabled by default) 



### Example output
    
    
    POST _analyze
    {
      "analyzer": "standard",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above sentence would produce the following terms:
    
    
    [ the, 2, quick, brown, foxes, jumped, over, the, lazy, dog's, bone ]

### Configuration

The `standard` analyzer accepts the following parameters:

`max_token_length`

| 

The maximum token length. If a token is seen that exceeds this length then it is split at `max_token_length` intervals. Defaults to `255`.   
  
---|---  
  
`stopwords`

| 

A pre-defined stop words list like `_english_` or an array containing a list of stop words. Defaults to `\_none_`.   
  
`stopwords_path`

| 

The path to a file containing stop words.   
  
See the [Stop Token Filter](analysis-stop-tokenfilter.html) for more information about stop word configuration.

### Example configuration

In this example, we configure the `standard` analyzer to have a `max_token_length` of 5 (for demonstration purposes), and to use the pre-defined list of English stop words:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_english_analyzer": {
              "type": "standard",
              "max_token_length": 5,
              "stopwords": "_english_"
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_english_analyzer",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above example produces the following terms:
    
    
    [ 2, quick, brown, foxes, jumpe, d, over, lazy, dog's, bone ]
