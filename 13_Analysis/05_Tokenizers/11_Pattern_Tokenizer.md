## Pattern Tokenizer

The `pattern` tokenizer uses a regular expression to either split text into terms whenever it matches a word separator, or to capture matching text as terms.

The default pattern is `\W+`, which splits text whenever it encounters non-word characters.

![Warning](/images/icons/warning.png)

### Beware of Pathological Regular Expressions

The pattern tokenizer uses [Java Regular Expressions](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html).

A badly written regular expression could run very slowly or even throw a StackOverflowError and cause the node it is running on to exit suddenly.

Read more about [pathological regular expressions and how to avoid them](http://www.regular-expressions.info/catastrophic.html).

### Example output
    
    
    POST _analyze
    {
      "tokenizer": "pattern",
      "text": "The foo_bar_size's default is 5."
    }

The above sentence would produce the following terms:
    
    
    [ The, foo_bar_size, s, default, is, 5 ]

### Configuration

The `pattern` tokenizer accepts the following parameters:

`pattern`| A [Java regular expression](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html), defaults to `\W+`.     
---|---    
`flags`| Java regular expression [flags](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#field.summary). lags should be pipe-separated, eg `"CASE_INSENSITIVE|COMMENTS"`.     
`group`| Which capture group to extract as tokens. Defaults to `-1` (split).   
  
### Example configuration

In this example, we configure the `pattern` tokenizer to break text into tokens when it encounters commas:
    
    
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
              "type": "pattern",
              "pattern": ","
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "comma,separated,values"
    }

The above example produces the following terms:
    
    
    [ comma, separated, values ]

In the next example, we configure the `pattern` tokenizer to capture values enclosed in double quotes (ignoring embedded escaped quotes `\"`). The regex itself looks like this:
    
    
    "((?:\\"|[^"]|\\")*)"

And reads as follows:

  * A literal `"`
  * Start capturing: 

    * A literal `\"` OR any character except `"`
    * Repeat until no more characters match 

  * A literal closing `"`



When the pattern is specified in JSON, the `"` and `\` characters need to be escaped, so the pattern ends up looking like:
    
    
    \"((?:\\\\\"|[^\"]|\\\\\")+)\"
    
    
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
              "type": "pattern",
             )+)\"",
              "group": 1
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "\"value\", \"value with embedded \\\" quote\""
    }

The above example produces the following two terms:
    
    
    [ value, value with embedded \" quote ]
