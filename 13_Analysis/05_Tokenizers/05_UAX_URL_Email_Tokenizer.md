## UAX URL Email Tokenizer

The `uax_url_email` tokenizer is like the [`standard` tokenizer](analysis-standard-tokenizer.html "Standard Tokenizer") except that it recognises URLs and email addresses as single tokens.

### Example output
    
    
    POST _analyze
    {
      "tokenizer": "uax_url_email",
      "text": "Email me at john.smith@global-international.com"
    }

The above sentence would produce the following terms:
    
    
    [ Email, me, at, john.smith@global-international.com ]

while the `standard` tokenizer would produce:
    
    
    [ Email, me, at, john.smith, global, international.com ]

### Configuration

The `uax_url_email` tokenizer accepts the following parameters:

`max_token_length`

| 

The maximum token length. If a token is seen that exceeds this length then it is split at `max_token_length` intervals. Defaults to `255`.   
  
---|---  
  
### Example configuration

In this example, we configure the `uax_url_email` tokenizer to have a `max_token_length` of 5 (for demonstration purposes):
    
    
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
              "type": "uax_url_email",
              "max_token_length": 5
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "john.smith@global-international.com"
    }

The above example produces the following terms:
    
    
    [ john, smith, globa, l, inter, natio, nal.c, om ]
