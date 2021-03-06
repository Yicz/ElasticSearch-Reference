## Path Hierarchy Tokenizer

The `path_hierarchy` tokenizer takes a hierarchical value like a filesystem path, splits on the path separator, and emits a term for each component in the tree.

### Example output
    
    
    POST _analyze
    {
      "tokenizer": "path_hierarchy",
      "text": "/one/two/three"
    }

The above text would produce the following terms:
    
    
    [ /one, /one/two, /one/two/three ]

### Configuration

The `path_hierarchy` tokenizer accepts the following parameters:

`delimiter`| The character to use as the path separator. Defaults to `/`.     
---|---    
`replacement`| An optional replacement character to use for the delimiter. Defaults to the `delimiter`.     
`buffer_size`| The number of characters read into the term buffer in a single pass. Defaults to `1024`. The term buffer will grow by this size until all the text has been consumed. It is advisable not to change this setting.     
`reverse`| If set to `true`, emits the tokens in reverse order. Defaults to `false`.     
`skip`| The number of initial tokens to skip. Defaults to `0`.   
  
### Example configuration

In this example, we configure the `path_hierarchy` tokenizer to split on `-` characters, and to replace them with `/`. The first two tokens are skipped:
    
    
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
              "type": "path_hierarchy",
              "delimiter": "-",
              "replacement": "/",
              "skip": 2
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "one-two-three-four-five"
    }

The above example produces the following terms:
    
    
    [ /three, /three/four, /three/four/five ]

If we were to set `reverse` to `true`, it would produce the following:
    
    
    [ one/two/three/, two/three/, three/ ]
