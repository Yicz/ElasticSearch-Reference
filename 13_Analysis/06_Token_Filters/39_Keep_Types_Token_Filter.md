## Keep Types Token Filter

A token filter of type `keep_types` that only keeps tokens with a token type contained in a predefined set.

### Options

types | a list of types to keep     
---|---  
  
### Settings example

You can set it up like:
    
    
    PUT /keep_types_example
    {
        "settings" : {
            "analysis" : {
                "analyzer" : {
                    "my_analyzer" : {
                        "tokenizer" : "standard",
                        "filter" : ["standard", "lowercase", "extract_numbers"]
                    }
                },
                "filter" : {
                    "extract_numbers" : {
                        "type" : "keep_types",
                        "types" : [ "<NUM>" ]
                    }
                }
            }
        }
    }

And test it like:
    
    
    POST /keep_types_example/_analyze
    {
      "analyzer" : "my_analyzer",
      "text" : "this is just 1 a test"
    }

And it’d respond:
    
    
    {
      "tokens": [
        {
          "token": "1",
          "start_offset": 13,
          "end_offset": 14,
          "type": "<NUM>",
          "position": 3
        }
      ]
    }

Note how only the `<NUM>` token is in the output.
