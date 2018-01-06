## Keyword Marker Token Filter

Protects words from being modified by stemmers. Must be placed before any stemming filters.

Setting | Description  
---|---    
`keywords`| A list of words to use.    
`keywords_path`| A path (either relative to `config` location, or absolute) to a list of words.    
`keywords_pattern`| A regular expression pattern to match against words in the text.    
`ignore_case`| Set to `true` to lower case all words first. Defaults to `false`.  
  
You can configure it like:
    
    
    PUT /keyword_marker_example
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "protect_cats": {
              "type": "custom",
              "tokenizer": "standard",
              "filter": ["lowercase", "protect_cats", "porter_stem"]
            },
            "normal": {
              "type": "custom",
              "tokenizer": "standard",
              "filter": ["lowercase", "porter_stem"]
            }
          },
          "filter": {
            "protect_cats": {
              "type": "keyword_marker",
              "keywords": ["cats"]
            }
          }
        }
      }
    }

And test it with:
    
    
    POST /keyword_marker_example/_analyze
    {
      "analyzer" : "protect_cats",
      "text" : "I like cats"
    }

And it’d respond:
    
    
    {
      "tokens": [
        {
          "token": "i",
          "start_offset": 0,
          "end_offset": 1,
          "type": "<ALPHANUM>",
          "position": 0
        },
        {
          "token": "like",
          "start_offset": 2,
          "end_offset": 6,
          "type": "<ALPHANUM>",
          "position": 1
        },
        {
          "token": "cats",
          "start_offset": 7,
          "end_offset": 11,
          "type": "<ALPHANUM>",
          "position": 2
        }
      ]
    }

As compared to the `normal` analyzer which has `cats` stemmed to `cat`:
    
    
    POST /keyword_marker_example/_analyze
    {
      "analyzer" : "normal",
      "text" : "I like cats"
    }

响应如下：
    
    
    {
      "tokens": [
        {
          "token": "i",
          "start_offset": 0,
          "end_offset": 1,
          "type": "<ALPHANUM>",
          "position": 0
        },
        {
          "token": "like",
          "start_offset": 2,
          "end_offset": 6,
          "type": "<ALPHANUM>",
          "position": 1
        },
        {
          "token": "cat",
          "start_offset": 7,
          "end_offset": 11,
          "type": "<ALPHANUM>",
          "position": 2
        }
      ]
    }
