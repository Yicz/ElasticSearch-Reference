## Lowercase Tokenizer

The `lowercase` tokenizer, like the [`letter` tokenizer](analysis-letter-tokenizer.html "Letter Tokenizer") breaks text into terms whenever it encounters a character which is not a letter, but it also lowercases all terms. It is functionally equivalent to the [`letter` tokenizer](analysis-letter-tokenizer.html "Letter Tokenizer") combined with the [`lowercase` token filter](analysis-lowercase-tokenfilter.html "Lowercase Token Filter"), but is more efficient as it performs both steps in a single pass.

### Example output
    
    
    POST _analyze
    {
      "tokenizer": "lowercase",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above sentence would produce the following terms:
    
    
    [ the, quick, brown, foxes, jumped, over, the, lazy, dog, s, bone ]

### Configuration

The `lowercase` tokenizer is not configurable.
