## Completion Suggester

![Note](/images/icons/note.png)

In order to understand the format of suggestions, please read the [_Suggesters_](search-suggesters.html) page first.

The `completion` suggester provides auto-complete/search-as-you-type functionality. This is a navigational feature to guide users to relevant results as they are typing, improving search precision. It is not meant for spell correction or did-you-mean functionality like the `term` or `phrase` suggesters.

Ideally, auto-complete functionality should be as fast as a user types to provide instant feedback relevant to what a user has already typed in. Hence, `completion` suggester is optimized for speed. The suggester uses data structures that enable fast lookups, but are costly to build and are stored in-memory.

### Mapping

To use this feature, specify a special mapping for this field, which indexes the field values for fast completions.
    
    
    PUT music
    {
        "mappings": {
            "song" : {
                "properties" : {
                    "suggest" : {
                        "type" : "completion"
                    },
                    "title" : {
                        "type": "keyword"
                    }
                }
            }
        }
    }

Mapping supports the following parameters:

`analyzer`
     The index analyzer to use, defaults to `simple`. In case you are wondering why we did not opt for the `standard` analyzer: We try to have easy to understand behaviour here, and if you index the field content `At the Drive-in`, you will not get any suggestions for `a`, nor for `d` (the first non stopword). 
`search_analyzer`
     The search analyzer to use, defaults to value of `analyzer`. 
`preserve_separators`
     Preserves the separators, defaults to `true`. If disabled, you could find a field starting with `Foo Fighters`, if you suggest for `foof`. 
`preserve_position_increments`
     Enables position increments, defaults to `true`. If disabled and using stopwords analyzer, you could get a field starting with `The Beatles`, if you suggest for `b`. **Note** : You could also achieve this by indexing two inputs, `Beatles` and `The Beatles`, no need to change a simple analyzer, if you are able to enrich your data. 
`max_input_length`
     Limits the length of a single input, defaults to `50` UTF-16 code points. This limit is only used at index time to reduce the total number of characters per input string in order to prevent massive inputs from bloating the underlying datastructure. Most usecases won’t be influenced by the default value since prefix completions seldom grow beyond prefixes longer than a handful of characters. 

### Indexing

You index suggestions like any other field. A suggestion is made of an `input` and an optional `weight` attribute. An `input` is the expected text to be matched by a suggestion query and the `weight` determines how the suggestions will be scored. Indexing a suggestion is as follows:
    
    
    PUT music/song/1?refresh
    {
        "suggest" : {
            "input": [ "Nevermind", "Nirvana" ],
            "weight" : 34
        }
    }

The following parameters are supported:

`input`
     The input to store, this can be an array of strings or just a string. This field is mandatory. 
`weight`
     A positive integer or a string containing a positive integer, which defines a weight and allows you to rank your suggestions. This field is optional. 

You can index multiple suggestions for a document as follows:
    
    
    PUT music/song/1?refresh
    {
        "suggest" : [
            {
                "input": "Nevermind",
                "weight" : 10
            },
            {
                "input": "Nirvana",
                "weight" : 3
            }
        ]
    }

You can use the following shorthand form. Note that you can not specify a weight with suggestion(s) in the shorthand form.
    
    
    PUT music/song/1?refresh
    {
      "suggest" : [ "Nevermind", "Nirvana" ]
    }

### Querying

Suggesting works as usual, except that you have to specify the suggest type as `completion`. Suggestions are near real-time, which means new suggestions can be made visible by [refresh](indices-refresh.html) and documents once deleted are never shown. This request:
    
    
    POST music/_search?pretty
    {
        "suggest": {
            "song-suggest" : {
                "prefix" : "nir",
                "completion" : {
                    "field" : "suggest"
                }
            }
        }
    }

returns this response:
    
    
    {
      "_shards" : {
        "total" : 5,
        "successful" : 5,
        "failed" : 0
      },
      "hits": ...
      "took": 2,
      "timed_out": false,
      "suggest": {
        "song-suggest" : [ {
          "text" : "nir",
          "offset" : 0,
          "length" : 3,
          "options" : [ {
            "text" : "Nirvana",
            "_index": "music",
            "_type": "song",
            "_id": "1",
            "_score": 1.0,
            "_source": {
              "suggest": ["Nevermind", "Nirvana"]
            }
          } ]
        } ]
      }
    }

![Important](/images/icons/important.png)

`_source` meta-field must be enabled, which is the default behavior, to enable returning `_source` with suggestions.

The configured weight for a suggestion is returned as `_score`. The `text` field uses the `input` of your indexed suggestion. Suggestions return the full document `_source` by default. The size of the `_source` can impact performance due to disk fetch and network transport overhead. To save some network overhead, filter out unnecessary fields from the `_source` using [source filtering](search-request-source-filtering.html) to minimize `_source` size. Note that the `_suggest` endpoint doesn’t support source filtering but using suggest on the `_search` endpoint does:
    
    
    POST music/_search?size=0
    {
        "_source": "suggest",
        "suggest": {
            "song-suggest" : {
                "prefix" : "nir",
                "completion" : {
                    "field" : "suggest"
                }
            }
        }
    }

Which should look like:
    
    
    {
        "took": 6,
        "timed_out": false,
        "_shards" : {
            "total" : 5,
            "successful" : 5,
            "failed" : 0
        },
        "hits": {
            "total" : 0,
            "max_score" : 0.0,
            "hits" : []
        },
        "suggest": {
            "song-suggest" : [ {
                "text" : "nir",
                "offset" : 0,
                "length" : 3,
                "options" : [ {
                    "text" : "Nirvana",
                    "_index": "music",
                    "_type": "song",
                    "_id": "1",
                    "_score": 1.0,
                    "_source": {
                        "suggest": ["Nevermind", "Nirvana"]
                    }
                } ]
            } ]
        }
    }

The basic completion suggester query supports the following parameters:

`field`
     The name of the field on which to run the query (required). 
`size`
     The number of suggestions to return (defaults to `5`). 

![Note](/images/icons/note.png)

The completion suggester considers all documents in the index. See [Context Suggester](suggester-context.html) for an explanation of how to query a subset of documents instead.

![Note](/images/icons/note.png)

In case of completion queries spanning more than one shard, the suggest is executed in two phases, where the last phase fetches the relevant documents from shards, implying executing completion requests against a single shard is more performant due to the document fetch overhead when the suggest spans multiple shards. To get best performance for completions, it is recommended to index completions into a single shard index. In case of high heap usage due to shard size, it is still recommended to break index into multiple shards instead of optimizing for completion performance.

### Fuzzy queries

The completion suggester also supports fuzzy queries - this means, you can have a typo in your search and still get results back.
    
    
    POST music/_search?pretty
    {
        "suggest": {
            "song-suggest" : {
                "prefix" : "nor",
                "completion" : {
                    "field" : "suggest",
                    "fuzzy" : {
                        "fuzziness" : 2
                    }
                }
            }
        }
    }

Suggestions that share the longest prefix to the query `prefix` will be scored higher.

The fuzzy query can take specific fuzzy parameters. The following parameters are supported:

`fuzziness`| The fuzziness factor, defaults to `AUTO`. See [Fuzziness for allowed settings.     
---|---    
`transpositions`| if set to `true`, transpositions are counted as one change instead of two, defaults to `true`    
`min_length`| Minimum length of the input before fuzzy suggestions are returned, defaults `3`    
`prefix_length`| Minimum length of the input, which is not checked for fuzzy alternatives, defaults to `1`    
`unicode_aware`| If `true`, all measurements (like fuzzy edit distance, transpositions, and lengths) are measured in Unicode code points instead of in bytes. This is slightly slower than raw bytes, so it is set to `false` by default.   
  
![Note](/images/icons/note.png)

If you want to stick with the default values, but still use fuzzy, you can either use `fuzzy: {}` or `fuzzy: true`.

### Regex queries

The completion suggester also supports regex queries meaning you can express a prefix as a regular expression
    
    
    POST music/_search?pretty
    {
        "suggest": {
            "song-suggest" : {
                "regex" : "n[ever|i]r",
                "completion" : {
                    "field" : "suggest"
                }
            }
        }
    }

The regex query can take specific regex parameters. The following parameters are supported:

`flags`| Possible flags are `ALL` (default), `ANYSTRING`, `COMPLEMENT`, `EMPTY`, `INTERSECTION`, `INTERVAL`, or `NONE`. See [regexp-syntax](query-dsl-regexp-query.html) for their meaning     
---|---    
`max_determinized_states`| Regular expressions are dangerous because it’s easy to accidentally create an innocuous looking one that requires an exponential number of internal determinized automaton states (and corresponding RAM and CPU) for Lucene to execute. Lucene prevents these using the `max_determinized_states` setting (defaults to 10000). You can raise this limit to allow more complex regular expressions to execute. 
