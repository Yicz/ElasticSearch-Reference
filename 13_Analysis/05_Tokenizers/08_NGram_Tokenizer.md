## NGram Tokenizer

The `ngram` tokenizer first breaks text down into words whenever it encounters one of a list of specified characters, then it emits [N-grams](https://en.wikipedia.org/wiki/N-gram) of each word of the specified length.

N-grams are like a sliding window that moves across the word - a continuous sequence of characters of the specified length. They are useful for querying languages that don’t use spaces or that have long compound words, like German.

### Example output

With the default settings, the `ngram` tokenizer treats the initial text as a single token and produces N-grams with minimum length `1` and maximum length `2`:
    
    
    POST _analyze
    {
      "tokenizer": "ngram",
      "text": "Quick Fox"
    }

The above sentence would produce the following terms:
    
    
    [ Q, Qu, u, ui, i, ic, c, ck, k, "k ", " ", " F", F, Fo, o, ox, x ]

### Configuration

The `ngram` tokenizer accepts the following parameters:

`min_gram`| Minimum length of characters in a gram. Defaults to `1`.     
---|---    
`max_gram`| Maximum length of characters in a gram. Defaults to `2`.     
`token_chars`| Character classes that should be included in a token. Elasticsearch will split on characters that don’t belong to the classes specified. Defaults to `[]` (keep all characters). 

Character classes may be any of the following:

  * `letter` —  for example `a`, `b`, `ï` or `京`
  * `digit` —  for example `3` or `7`
  * `whitespace` —  for example `" "` or `"\n"`
  * `punctuation` — for example `!` or `"`
  * `symbol` —  for example `$` or `√`

  
  
![Tip](/images/icons/tip.png)

It usually makes sense to set `min_gram` and `max_gram` to the same value. The smaller the length, the more documents will match but the lower the quality of the matches. The longer the length, the more specific the matches. A tri-gram (length `3`) is a good place to start.

### Example configuration

In this example, we configure the `ngram` tokenizer to treat letters and digits as tokens, and to produce tri-grams (grams of length `3`):
    
    
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
              "type": "ngram",
              "min_gram": 3,
              "max_gram": 3,
              "token_chars": [
                "letter",
                "digit"
              ]
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "2 Quick Foxes."
    }

The above example produces the following terms:
    
    
    [ Qui, uic, ick, Fox, oxe, xes ]
