## Whitespace Tokenizer

The `whitespace` tokenizer breaks text into terms whenever it encounters a whitespace character.

### Example output
    
    
    POST _analyze
    {
      "tokenizer": "whitespace",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above sentence would produce the following terms:
    
    
    [ The, 2, QUICK, Brown-Foxes, jumped, over, the, lazy, dog's, bone. ]

### Configuration

The `whitespace` tokenizer is not configurable.
