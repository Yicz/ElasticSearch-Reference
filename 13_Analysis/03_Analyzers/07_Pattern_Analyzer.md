## Pattern Analyzer

The `pattern` analyzer uses a regular expression to split the text into terms. The regular expression should match the **token separators** not the tokens themselves. The regular expression defaults to `\W+` (or all non-word characters).

![Warning](images/icons/warning.png)

### Beware of Pathological Regular Expressions

The pattern analyzer uses [Java Regular Expressions](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html).

A badly written regular expression could run very slowly or even throw a StackOverflowError and cause the node it is running on to exit suddenly.

Read more about [pathological regular expressions and how to avoid them](http://www.regular-expressions.info/catastrophic.html).

### Definition

It consists of:

Tokenizer 
    

  * [Pattern Tokenizer](analysis-pattern-tokenizer.html)



Token Filters 
    

  * [Lower Case Token Filter](analysis-lowercase-tokenfilter.html)
  * [Stop Token Filter](analysis-stop-tokenfilter.html) (disabled by default) 



### Example output
    
    
    POST _analyze
    {
      "analyzer": "pattern",
      "text": "The 2 QUICK Brown-Foxes jumped over the lazy dog's bone."
    }

The above sentence would produce the following terms:
    
    
    [ the, 2, quick, brown, foxes, jumped, over, the, lazy, dog, s, bone ]

### Configuration

The `pattern` analyzer accepts the following parameters:

`pattern`| A [Java regular expression](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html), defaults to `\W+`.     
---|---    
`flags`| Java regular expression [flags](http://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#field.summary). Flags should be pipe-separated, eg `"CASE_INSENSITIVE|COMMENTS"`.     
`lowercase`| Should terms be lowercased or not. Defaults to `true`.     
`stopwords`| A pre-defined stop words list like `_english_` or an array containing a list of stop words. Defaults to `\_none_`.     
`stopwords_path`| 

The path to a file containing stop words.   
  
See the [Stop Token Filter](analysis-stop-tokenfilter.html) for more information about stop word configuration.

### Example configuration

In this example, we configure the `pattern` analyzer to split email addresses on non-word characters or on underscores (`\W|_`), and to lower-case the result:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "my_email_analyzer": {
              "type":      "pattern",
              "pattern":   "\\W|_", #1
              "lowercase": true
            }
          }
        }
      }
    }
    
    POST my_index/_analyze
    {
      "analyzer": "my_email_analyzer",
      "text": "John_Smith@foo-bar.com"
    }
#1| The backslashes in the pattern need to be escaped when specifying the pattern as a JSON string.     
---|---    
The above example produces the following terms:
    
    
    [ john, smith, foo, bar, com ]

#### CamelCase tokenizer

The following more complicated example splits CamelCase text into tokens:
    
    
    PUT my_index
    {
      "settings": {
        "analysis": {
          "analyzer": {
            "camel": {
              "type": "pattern",
              "pattern": "([^\\p{L}\\d]+)|(?<=\\D)(?=\\d)|(?<=\\d)(?=\\D)|(?<=[\\p{L}&&[^\\p{Lu}]])(?=\\p{Lu})|(?<=\\p{Lu})(?=\\p{Lu}[\\p{L}&&[^\\p{Lu}]])"
            }
          }
        }
      }
    }
    
    GET my_index/_analyze
    {
      "analyzer": "camel",
      "text": "MooseX::FTPClass2_beta"
    }

The above example produces the following terms:
    
    
    [ moose, x, ftp, class, 2, beta ]

The regex above is easier to understand as:
    
    
      ([^\p{L}\d]+)                 # swallow non letters and numbers,
    | (?<=\D)(?=\d)                 # or non-number followed by number,
    | (?<=\d)(?=\D)                 # or number followed by non-number,
    | (?<=[ \p{L} && [^\p{Lu}]])    # or lower case
      (?=\p{Lu})                    #   followed by upper case,
    | (?<=\p{Lu})                   # or upper case
      (?=\p{Lu}                     #   followed by upper case
        [\p{L}&&[^\p{Lu}]]          #   then lower case
      )
