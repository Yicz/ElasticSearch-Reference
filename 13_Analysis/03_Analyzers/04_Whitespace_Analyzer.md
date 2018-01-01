##  空格分析器 Whitespace Analyzer

The `whitespace` analyzer breaks text into terms whenever it encounters a whitespace character.

### Definition

It consists of:

Tokenizer 
    

  * [Whitespace Tokenizer](analysis-whitespace-tokenizer.html)



### Example output
    
    
    POST _analyze
    {
      "analyzer": "whitespace",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above sentence would produce the following terms:
    
    
    [ The, 2, QUICK, Brown-Foxes, jumped, over, the, lazy, dog's, bone. ]

### Configuration

The `whitespace` analyzer is not configurable.
