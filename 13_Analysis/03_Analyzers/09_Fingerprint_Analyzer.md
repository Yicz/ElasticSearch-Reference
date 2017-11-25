## Fingerprint Analyzer

The `fingerprint` analyzer implements a [fingerprinting algorithm](https://github.com/OpenRefine/OpenRefine/wiki/Clustering-In-Depth#fingerprint) which is used by the OpenRefine project to assist in clustering.

Input text is lowercased, normalized to remove extended characters, sorted, deduplicated and concatenated into a single token. If a stopword list is configured, stop words will also be removed.

### Definition

It consists of:

Tokenizer 
    

  * [Standard Tokenizer](analysis-standard-tokenizer.html "Standard Tokenizer")



Token Filters (in order) 
    

  1. [Lower Case Token Filter](analysis-lowercase-tokenfilter.html "Lowercase Token Filter")
  2. [ASCII Folding Token Filter](analysis-asciifolding-tokenfilter.html "ASCII Folding Token Filter")
  3. [Stop Token Filter](analysis-stop-tokenfilter.html "Stop Token Filter") (disabled by default) 
  4. [Fingerprint Token Filter](analysis-fingerprint-tokenfilter.html "Fingerprint Token Filter")



### Example output
    
    
    POST _analyze
    {
      "analyzer": "fingerprint",
      "text": "Yes yes, Gödel said this sentence is consistent and."
    }

The above sentence would produce the following single term:
    
    
    [ and consistent godel is said sentence this yes ]

### Configuration

The `fingerprint` analyzer accepts the following parameters:

`separator`

| 

The character to use to concate the terms. Defaults to a space.   
  
---|---  
  
`max_output_size`

| 

The maximum token size to emit. Defaults to `255`. Tokens larger than this size will be discarded.   
  
`stopwords`

| 

A pre-defined stop words list like `_english_` or an array containing a list of stop words. Defaults to `\_none_`.   
  
`stopwords_path`

| 

The path to a file containing stop words.   
  
See the [Stop Token Filter](analysis-stop-tokenfilter.html "Stop Token Filter") for more information about stop word configuration.

### Example configuration

In this example, we configure the `fingerprint` analyzer to use the pre-defined list of English stop words:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_fingerprint_analyzer": {
              "type": "fingerprint",
              "stopwords": "_english_"
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_fingerprint_analyzer",
      "text": "Yes yes, Gödel said this sentence is consistent and."
    }

The above example produces the following term:
    
    
    [ consistent godel said sentence yes ]
