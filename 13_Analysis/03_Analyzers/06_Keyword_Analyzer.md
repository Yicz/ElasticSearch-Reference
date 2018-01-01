## 关键字分析器 Keyword Analyzer

The `keyword` analyzer is a “noop” analyzer which returns the entire input string as a single token.

### Definition

It consists of:

Tokenizer 
    

  * [Keyword Tokenizer](analysis-keyword-tokenizer.html)



### Example output
    
    
    POST _analyze
    {
      "analyzer": "keyword",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above sentence would produce the following single term:
    
    
    [ The 2 QUICK Brown-Foxes jumped over the lazy dog's bone. ]

### Configuration

The `keyword` analyzer is not configurable.
