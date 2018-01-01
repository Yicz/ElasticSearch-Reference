## 简单分析器 Simple Analyzer

The `simple` analyzer breaks text into terms whenever it encounters a character which is not a letter. All terms are lower cased.

### Definition

It consists of:

Tokenizer 
    

  * [Lower Case Tokenizer](analysis-lowercase-tokenizer.html)



### Example output
    
    
    POST _analyze
    {
      "analyzer": "simple",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above sentence would produce the following terms:
    
    
    [ the, quick, brown, foxes, jumped, over, the, lazy, dog, s, bone ]

### Configuration

The `simple` analyzer is not configurable.
