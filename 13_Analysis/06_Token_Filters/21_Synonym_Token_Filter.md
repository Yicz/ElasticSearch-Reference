## Synonym Token Filter

The `synonym` token filter allows to easily handle synonyms during the analysis process. Synonyms are configured using a configuration file. Here is an example:
    
    
    PUT /test_index
    {
        "settings": {
            "index" : {
                "analysis" : {
                    "filter" : {
                        "synonym" : {
                            "type" : "synonym", #1
                            "synonyms_path" : "analysis/synonym.txt",
                            "tokenizer" : "whitespace" #2
                        }
                    },
                    "analyzer" : {
                        "synonym" : {
                            "tokenizer" : "whitespace",
                            "filter" : ["synonym"] #3
                        }
                    }
                }
            }
        }
    }

#1| We configure a `synonym` filter, with a path of `analysis/synonym.txt` (relative to the `config` location).     
---|---  
#2| The `tokenizer` parameter controls the tokenizers that will be used to tokenize the synonym, and defaults to the `whitespace` tokenizer. Additional settings are: `ignore_case` (defaults to `false`), and `expand` (defaults to `true`).     
#3| The `synonym` analyzer is then configured with the filter.   
  
Two synonym formats are supported: Solr, WordNet.

#### Solr synonyms

The following is a sample format of the file:
    
    
    # Blank lines and lines starting with pound are comments.
    
    # Explicit mappings match any token sequence on the LHS of "=>"
    # and replace with all alternatives on the RHS.  These types of mappings
    # ignore the expand parameter in the schema.
    # Examples:
    i-pod, i pod => ipod,
    sea biscuit, sea biscit => seabiscuit
    
    # Equivalent synonyms may be separated with commas and give
    # no explicit mapping.  In this case the mapping behavior will
    # be taken from the expand parameter in the schema.  This allows
    # the same synonym file to be used in different synonym handling strategies.
    # Examples:
    ipod, i-pod, i pod
    foozball , foosball
    universe , cosmos
    lol, laughing out loud
    
    # If expand==true, "ipod, i-pod, i pod" is equivalent
    # to the explicit mapping:
    ipod, i-pod, i pod => ipod, i-pod, i pod
    # If expand==false, "ipod, i-pod, i pod" is equivalent
    # to the explicit mapping:
    ipod, i-pod, i pod => ipod
    
    # Multiple synonym mapping entries are merged.
    foo => foo bar
    foo => baz
    # is equivalent to
    foo => foo bar, baz

You can also define synonyms for the filter directly in the configuration file (note use of `synonyms` instead of `synonyms_path`):
    
    
    PUT /test_index
    {
        "settings": {
            "index" : {
                "analysis" : {
                    "filter" : {
                        "synonym" : {
                            "type" : "synonym",
                            "synonyms" : [
                                "i-pod, i pod => ipod",
                                "universe, cosmos"
                            ]
                        }
                    }
                }
            }
        }
    }

However, it is recommended to define large synonyms set in a file using `synonyms_path`, because specifying them inline increases cluster size unnecessarily.

#### WordNet synonyms

Synonyms based on [WordNet](http://wordnet.princeton.edu/) format can be declared using `format`:
    
    
    PUT /test_index
    {
        "settings": {
            "index" : {
                "analysis" : {
                    "filter" : {
                        "synonym" : {
                            "type" : "synonym",
                            "format" : "wordnet",
                            "synonyms" : [
                                "s(100000001,1,'abstain',v,1,0).",
                                "s(100000001,2,'refrain',v,1,0).",
                                "s(100000001,3,'desist',v,1,0)."
                            ]
                        }
                    }
                }
            }
        }
    }

Using `synonyms_path` to define WordNet synonyms in a file is supported as well.
