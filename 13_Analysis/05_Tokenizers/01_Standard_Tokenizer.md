## Standard Tokenizer

The `standard` tokenizer provides grammar based tokenization (based on the Unicode Text Segmentation algorithm, as specified in [Unicode Standard Annex <2>9](http://unicode.org/reports/tr29/)) and works well for most languages.

### Example output
    
    
    POST _analyze
    {
      "tokenizer": "standard",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above sentence would produce the following terms:
    
    
    [ The, 2, QUICK, Brown, Foxes, jumped, over, the, lazy, dog's, bone ]

### Configuration

The `standard` tokenizer accepts the following parameters:

`max_token_length`| The maximum token length. If a token is seen that exceeds this length then it is split at `max_token_length` intervals. Defaults to `255`.     
---|---  
  
### Example configuration

In this example, we configure the `standard` tokenizer to have a `max_token_length` of 5 (for demonstration purposes):
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_analyzer": {
              "tokenizer": "my_tokenizer"
            }
          },
          "tokenizer": {
            "my_tokenizer": {
              "type": "standard",
              "max_token_length": 5
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above example produces the following terms:
    
    
    [ The, 2, QUICK, Brown, Foxes, jumpe, d, over, the, lazy, dog's, bone ]
