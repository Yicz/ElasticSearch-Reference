## Mapping Char Filter

The `mapping` character filter accepts a map of keys and values. Whenever it encounters a string of characters that is the same as a key, it replaces them with the value associated with that key.

Matching is greedy; the longest pattern matching at a given point wins. Replacements are allowed to be the empty string.

### Configuration

The `mapping` character filter accepts the following parameters:

`mappings`| A array of mappings, with each element having the form `key => value`.     
---|---    
`mappings_path`| A path, either absolute or relative to the `config` directory, to a UTF-8 encoded text mappings file containing a `key => value` mapping per line.   
  
Either the `mappings` or `mappings_path` parameter must be provided.

### Example configuration

In this example, we configure the `mapping` character filter to replace Arabic numerals with their Latin equivalents:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_analyzer": {
              "tokenizer": "keyword",
              "char_filter": [
                "my_char_filter"
              ]
            }
          },
          "char_filter": {
            "my_char_filter": {
              "type": "mapping",
              "mappings": [
                "٠ => 0",
                "١ => 1",
                "٢ => 2",
                "٣ => 3",
                "٤ => 4",
                "٥ => 5",
                "٦ => 6",
                "٧ => 7",
                "٨ => 8",
                "٩ => 9"
              ]
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "My license plate is ٢٥٠١٥"
    }

The above example produces the following term:
    
    
    [ My license plate is 25015 ]

Keys and values can be strings with multiple characters. The following example replaces the `:)` and `:(` emoticons with a text equivalent:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_analyzer": {
              "tokenizer": "standard",
              "char_filter": [
                "my_char_filter"
              ]
            }
          },
          "char_filter": {
            "my_char_filter": {
              "type": "mapping",
              "mappings": [
                ":) => _happy_",
                ":( => _sad_"
              ]
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "I'm delighted about it :("
    }

The above example produces the following terms:
    
    
    [ I'm, delighted, about, it, _sad_ ]
