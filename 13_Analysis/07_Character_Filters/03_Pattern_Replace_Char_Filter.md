## Pattern Replace Char Filter

The `pattern_replace` character filter uses a regular expression to match characters which should be replaced with the specified replacement string. The replacement string can refer to capture groups in the regular expression.

![Warning](/images/icons/warning.png)

### Beware of Pathological Regular Expressions

The pattern replace character filter uses [Java Regular Expressions](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html).

A badly written regular expression could run very slowly or even throw a StackOverflowError and cause the node it is running on to exit suddenly.

Read more about [pathological regular expressions and how to avoid them](http://www.regular-expressions.info/catastrophic.html).

### Configuration

The `pattern_replace` character filter accepts the following parameters:

`pattern`| A [Java regular expression](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html). Required.     
---|---    
`replacement`| The replacement string, which can reference capture groups using the `$1`..`$9` syntax, as explained [here](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Matcher.html#appendReplacement-java.lang.StringBuffer-java.lang.String-).     
`flags`| Java regular expression [flags](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#field.summary). Flags should be pipe-separated, eg `"CASE_INSENSITIVE|COMMENTS"`.   
  
### Example configuration

In this example, we configure the `pattern_replace` character filter to replace any embedded dashes in numbers with underscores, i.e `123-456-789` → `123_456_789`:
    
    
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
              "type": "pattern_replace",
              "pattern": "(\\d+)-(?=\\d)",
              "replacement": "$1_"
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "My credit card is 123-456-789"
    }

The above example produces the following term:
    
    
    [ My, credit, card, is 123_456_789 ]

![Warning](/images/icons/warning.png)

Using a replacement string that changes the length of the original text will work for search purposes, but will result in incorrect highlighting, as can be seen in the following example.

This example inserts a space whenever it encounters a lower-case letter followed by an upper-case letter (i.e. `fooBarBaz` → `foo Bar Baz`), allowing camelCase words to be queried individually:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_analyzer": {
              "tokenizer": "standard",
              "char_filter": [
                "my_char_filter"
              ],
              "filter": [
                "lowercase"
              ]
            }
          },
          "char_filter": {
            "my_char_filter": {
              "type": "pattern_replace",
              "pattern": "(?<=\\p{Lower})(?=\\p{Upper})",
              "replacement": " "
            }
          }
        }
      },
      "mappings": {
        "my_type": {
          "properties": {
            "text": {
              "type": "text",
              "analyzer": "my_analyzer"
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_analyzer",
      "text": "The fooBarBaz method"
    }

The above returns the following terms:
    
    
    [ the, foo, bar, baz, method ]

Querying for `bar` will find the document correctly, but highlighting on the result will produce incorrect highlights, because our character filter changed the length of the original text:
    
    
    PUT my_index/my_doc/1?refresh
    {
      "text": "The fooBarBaz method"
    }
    
    GET my_index/_search
    {
      "query": {
        "match": {
          "text": "bar"
        }
      },
      "highlight": {
        "fields": {
          "text": {}
        }
      }
    }

The output from the above is:
    
    
    {
      "timed_out": false,
      "took": $body.took,
      "_shards": {
        "total": 5,
        "successful": 5,
        "failed": 0
      },
      "hits": {
        "total": 1,
        "max_score": 0.2824934,
        "hits": [
          {
            "_index": "my_index",
            "_type": "my_doc",
            "_id": "1",
            "_score": 0.2824934,
            "_source": {
              "text": "The fooBarBaz method"
            },
            "highlight": {
              "text": [
                "The foo<em>Ba</em>rBaz method" <1>
              ]
            }
          }
        ]
      }
    }

<1>| Note the incorrect highlight.     
---|---
