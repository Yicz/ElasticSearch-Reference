## Highlighting

Allows to highlight search results on one or more fields. The implementation uses either the lucene `plain` highlighter, the fast vector highlighter (`fvh`) or `postings` highlighter. The following is an example of the search request body:
    
    
    GET /_search
    {
        "query" : {
            "match": { "content": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {}
            }
        }
    }

In the above case, the `content` field will be highlighted for each search hit (there will be another element in each search hit, called `highlight`, which includes the highlighted fields and the highlighted fragments).

![Note](images/icons/note.png)

In order to perform highlighting, the actual content of the field is required. If the field in question is stored (has `store` set to `true` in the mapping) it will be used, otherwise, the actual `_source` will be loaded and the relevant field will be extracted from it.

The `_all` field cannot be extracted from `_source`, so it can only be used for highlighting if it mapped to have `store` set to `true`.

The field name supports wildcard notation. For example, using `comment_*` will cause all [text](text.html) and [keyword](keyword.html) fields (and [string](string.html) from versions before 5.0) that match the expression to be highlighted. Note that all other fields will not be highlighted. If you use a custom mapper and want to highlight on a field anyway, you have to provide the field name explicitly.

### Plain highlighter

The default choice of highlighter is of type `plain` and uses the Lucene highlighter. It tries hard to reflect the query matching logic in terms of understanding word importance and any word positioning criteria in phrase queries.

![Warning](images/icons/warning.png)

If you want to highlight a lot of fields in a lot of documents with complex queries this highlighter will not be fast. In its efforts to accurately reflect query logic it creates a tiny in-memory index and re-runs the original query criteria through Lucene’s query execution planner to get access to low-level match information on the current document. This is repeated for every field and every document that needs highlighting. If this presents a performance issue in your system consider using an alternative highlighter.

### Postings highlighter

If `index_options` is set to `offsets` in the mapping the postings highlighter will be used instead of the plain highlighter. The postings highlighter:

  * Is faster since it doesn’t require to reanalyze the text to be highlighted: the larger the documents the better the performance gain should be 
  * Requires less disk space than term_vectors, needed for the fast vector highlighter 
  * Breaks the text into sentences and highlights them. Plays really well with natural languages, not as well with fields containing for instance html markup 
  * Treats the document as the whole corpus, and scores individual sentences as if they were documents in this corpus, using the BM25 algorithm 



Here is an example of setting the `content` field in the index mapping to allow for highlighting using the postings highlighter on it:
    
    
    PUT /example
    {
      "mappings": {
        "doc" : {
          "properties": {
            "comment" : {
              "type": "text",
              "index_options" : "offsets"
            }
          }
        }
      }
    }

![Note](images/icons/note.png)

Note that the postings highlighter is meant to perform simple query terms highlighting, regardless of their positions. That means that when used for instance in combination with a phrase query, it will highlight all the terms that the query is composed of, regardless of whether they are actually part of a query match, effectively ignoring their positions.

![Warning](images/icons/warning.png)

The postings highlighter doesn’t support highlighting some complex queries, like a `match` query with `type` set to `match_phrase_prefix`. No highlighted snippets will be returned in that case.

### Fast vector highlighter

If `term_vector` information is provided by setting `term_vector` to `with_positions_offsets` in the mapping then the fast vector highlighter will be used instead of the plain highlighter. The fast vector highlighter:

  * Is faster especially for large fields (> `1MB`) 
  * Can be customized with `boundary_scanner` (see [below](search-request-highlighting.html#boundary-scanners)) 
  * Requires setting `term_vector` to `with_positions_offsets` which increases the size of the index 
  * Can combine matches from multiple fields into one result. See `matched_fields`
  * Can assign different weights to matches at different positions allowing for things like phrase matches being sorted above term matches when highlighting a Boosting Query that boosts phrase matches over term matches 



Here is an example of setting the `content` field to allow for highlighting using the fast vector highlighter on it (this will cause the index to be bigger):
    
    
    PUT /example
    {
      "mappings": {
        "doc" : {
          "properties": {
            "comment" : {
              "type": "text",
              "term_vector" : "with_positions_offsets"
            }
          }
        }
      }
    }

### Unified Highlighter

![Warning](images/icons/warning.png)

This functionality is experimental and may be changed or removed completely in a future release. Elastic will take a best effort approach to fix any issues, but experimental features are not subject to the support SLA of official GA features.

The `unified` highlighter can extract offsets from either postings, term vectors, or via re-analyzing text. Under the hood it uses Lucene UnifiedHighlighter which picks its strategy depending on the field and the query to highlight. Independently of the strategy this highlighter breaks the text into sentences and scores individual sentences as if they were documents in this corpus, using the BM25 algorithm. It supports accurate phrase and multi-term (fuzzy, prefix, regex) highlighting and can be used with the following options:

  * `force_source`
  * `encoder`
  * `highlight_query`
  * `pre_tags and `post_tags`
  * `require_field_match`
  * `boundary_scanner` (`sentence` ( **default** ) or `word`) 
  * `max_fragment_length` (only for `sentence` scanner) 
  * `no_match_size`



### Force highlighter type

The `type` field allows to force a specific highlighter type. This is useful for instance when needing to use the plain highlighter on a field that has `term_vectors` enabled. The allowed values are: `plain`, `postings` and `fvh`. The following is an example that forces the use of the plain highlighter:
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {"type" : "plain"}
            }
        }
    }

### Force highlighting on source

Forces the highlighting to highlight fields based on the source even if fields are stored separately. Defaults to `false`.
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {"force_source" : true}
            }
        }
    }

### Highlighting Tags

By default, the highlighting will wrap highlighted text in `<em>` and `</em>`. This can be controlled by setting `pre_tags` and `post_tags`, for example:
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "pre_tags" : ["<tag1>"],
            "post_tags" : ["</tag1>"],
            "fields" : {
                "_all" : {}
            }
        }
    }

Using the fast vector highlighter there can be more tags, and the "importance" is ordered.
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "pre_tags" : ["<tag1>", "<tag2>"],
            "post_tags" : ["</tag1>", "</tag2>"],
            "fields" : {
                "_all" : {}
            }
        }
    }

There are also built in "tag" schemas, with currently a single schema called `styled` with the following `pre_tags`:
    
    
    <em class="hlt1">, <em class="hlt2">, <em class="hlt3">,
    <em class="hlt4">, <em class="hlt5">, <em class="hlt6">,
    <em class="hlt7">, <em class="hlt8">, <em class="hlt9">,
    <em class="hlt10">

and `</em>` as `post_tags`. If you think of more nice to have built in tag schemas, just send an email to the mailing list or open an issue. Here is an example of switching tag schemas:
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "tags_schema" : "styled",
            "fields" : {
                "content" : {}
            }
        }
    }

### Encoder

An `encoder` parameter can be used to define how highlighted text will be encoded. It can be either `default` (no encoding) or `html` (will escape html, if you use html highlighting tags).

### Highlighted Fragments

Each field highlighted can control the size of the highlighted fragment in characters (defaults to `100`), and the maximum number of fragments to return (defaults to `5`). For example:
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {"fragment_size" : 150, "number_of_fragments" : 3}
            }
        }
    }

The `fragment_size` is ignored when using the postings highlighter, as it outputs sentences regardless of their length.

On top of this it is possible to specify that highlighted fragments need to be sorted by score:
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "order" : "score",
            "fields" : {
                "content" : {"fragment_size" : 150, "number_of_fragments" : 3}
            }
        }
    }

If the `number_of_fragments` value is set to `0` then no fragments are produced, instead the whole content of the field is returned, and of course it is highlighted. This can be very handy if short texts (like document title or address) need to be highlighted but no fragmentation is required. Note that `fragment_size` is ignored in this case.
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "_all" : {},
                "bio.title" : {"number_of_fragments" : 0}
            }
        }
    }

When using `fvh` one can use `fragment_offset` parameter to control the margin to start highlighting from.

In the case where there is no matching fragment to highlight, the default is to not return anything. Instead, we can return a snippet of text from the beginning of the field by setting `no_match_size` (default `0`) to the length of the text that you want returned. The actual length may be shorter or longer than specified as it tries to break on a word boundary. When using the postings highlighter it is not possible to control the actual size of the snippet, therefore the first sentence gets returned whenever `no_match_size` is greater than `0`.
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "fields" : {
                "content" : {
                    "fragment_size" : 150,
                    "number_of_fragments" : 3,
                    "no_match_size": 150
                }
            }
        }
    }

### Fragmenter

Fragmenter can control how text should be broken up in highlight snippets. However, this option is applicable only for the Plain Highlighter. There are two options:

`simple`

| 

Breaks up text into same sized fragments.   
  
---|---  
  
`span`

| 

Same as the simple fragmenter, but tries not to break up text between highlighted terms (this is applicable when using phrase like queries). This is the default.   
      
    
    GET twitter/tweet/_search
    {
        "query" : {
            "match_phrase": { "message": "number 1" }
        },
        "highlight" : {
            "fields" : {
                "message" : {
                    "fragment_size" : 15,
                    "number_of_fragments" : 3,
                    "fragmenter": "simple"
                }
            }
        }
    }

Response:
    
    
    {
        ...
        "hits": {
            "total": 1,
            "max_score": 1.4818809,
            "hits": [
                {
                    "_index": "twitter",
                    "_type": "tweet",
                    "_id": "1",
                    "_score": 1.4818809,
                    "_source": {
                        "user": "test",
                        "message": "some message with the number 1",
                        "date": "2009-11-15T14:12:12",
                        "likes": 1
                    },
                    "highlight": {
                        "message": [
                            " with the <em>number</em>",
                            " <em>1</em>"
                        ]
                    }
                }
            ]
        }
    }
    
    
    GET twitter/tweet/_search
    {
        "query" : {
            "match_phrase": { "message": "number 1" }
        },
        "highlight" : {
            "fields" : {
                "message" : {
                    "fragment_size" : 15,
                    "number_of_fragments" : 3,
                    "fragmenter": "span"
                }
            }
        }
    }

Response:
    
    
    {
        ...
        "hits": {
            "total": 1,
            "max_score": 1.4818809,
            "hits": [
                {
                    "_index": "twitter",
                    "_type": "tweet",
                    "_id": "1",
                    "_score": 1.4818809,
                    "_source": {
                        "user": "test",
                        "message": "some message with the number 1",
                        "date": "2009-11-15T14:12:12",
                        "likes": 1
                    },
                    "highlight": {
                        "message": [
                            "some message with the <em>number</em> <em>1</em>"
                        ]
                    }
                }
            ]
        }
    }

If the `number_of_fragments` option is set to `0`, `NullFragmenter` is used which does not fragment the text at all. This is useful for highlighting the entire content of a document or field.

### Highlight query

It is also possible to highlight against a query other than the search query by setting `highlight_query`. This is especially useful if you use a rescore query because those are not taken into account by highlighting by default. Elasticsearch does not validate that `highlight_query` contains the search query in any way so it is possible to define it so legitimate query results aren’t highlighted at all. Generally it is better to include the search query in the `highlight_query`. Here is an example of including both the search query and the rescore query in `highlight_query`.
    
    
    GET /_search
    {
        "stored_fields": [ "_id" ],
        "query" : {
            "match": {
                "content": {
                    "query": "foo bar"
                }
            }
        },
        "rescore": {
            "window_size": 50,
            "query": {
                "rescore_query" : {
                    "match_phrase": {
                        "content": {
                            "query": "foo bar",
                            "slop": 1
                        }
                    }
                },
                "rescore_query_weight" : 10
            }
        },
        "highlight" : {
            "order" : "score",
            "fields" : {
                "content" : {
                    "fragment_size" : 150,
                    "number_of_fragments" : 3,
                    "highlight_query": {
                        "bool": {
                            "must": {
                                "match": {
                                    "content": {
                                        "query": "foo bar"
                                    }
                                }
                            },
                            "should": {
                                "match_phrase": {
                                    "content": {
                                        "query": "foo bar",
                                        "slop": 1,
                                        "boost": 10.0
                                    }
                                }
                            },
                            "minimum_should_match": 0
                        }
                    }
                }
            }
        }
    }

Note that the score of text fragment in this case is calculated by the Lucene highlighting framework. For implementation details you can check the `ScoreOrderFragmentsBuilder.java` class. On the other hand when using the postings highlighter the fragments are scored using, as mentioned above, the BM25 algorithm.

### Global Settings

Highlighting settings can be set on a global level and then overridden at the field level.
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "number_of_fragments" : 3,
            "fragment_size" : 150,
            "fields" : {
                "_all" : { "pre_tags" : ["<em>"], "post_tags" : ["</em>"] },
                "bio.title" : { "number_of_fragments" : 0 },
                "bio.author" : { "number_of_fragments" : 0 },
                "bio.content" : { "number_of_fragments" : 5, "order" : "score" }
            }
        }
    }

### Require Field Match

`require_field_match` can be set to `false` which will cause any field to be highlighted regardless of whether the query matched specifically on them. The default behaviour is `true`, meaning that only fields that hold a query match will be highlighted.
    
    
    GET /_search
    {
        "query" : {
            "match": { "user": "kimchy" }
        },
        "highlight" : {
            "require_field_match": false,
            "fields": {
                    "_all" : { "pre_tags" : ["<em>"], "post_tags" : ["</em>"] }
            }
        }
    }

### Boundary Scanners

When highlighting a field using the unified highlighter or the fast vector highlighter, you can specify how to break the highlighted fragments using `boundary_scanner`, which accepts the following values:

  * `chars` (default mode for the FVH): allows to configure which characters (`boundary_chars`) constitute a boundary for highlighting. It’s a single string with each boundary character defined in it (defaults to `.,!? \t\n`). It also allows configuring the `boundary_max_scan` to control how far to look for boundary characters (defaults to `20`). Works only with the Fast Vector Highlighter. 
  * `sentence` and `word`: use Java’s [BreakIterator](https://docs.oracle.com/javase/8/docs/api/java/text/BreakIterator.html) to break the highlighted fragments at the next _sentence_ or _word_ boundary. You can further specify `boundary_scanner_locale` to control which Locale is used to search the text for these boundaries. 



![Note](images/icons/note.png)

When used with the `unified` highlighter, the `sentence` scanner splits sentence bigger than `fragment_size` at the first word boundary next to `fragment_size`. You can set `fragment_size` to 0 to never split any sentence.

### Matched Fields

The Fast Vector Highlighter can combine matches on multiple fields to highlight a single field using `matched_fields`. This is most intuitive for multifields that analyze the same string in different ways. All `matched_fields` must have `term_vector` set to `with_positions_offsets` but only the field to which the matches are combined is loaded so only that field would benefit from having `store` set to `yes`.

In the following examples `content` is analyzed by the `english` analyzer and `content.plain` is analyzed by the `standard` analyzer.
    
    
    GET /_search
    {
        "query": {
            "query_string": {
                "query": "content.plain:running scissors",
                "fields": ["content"]
            }
        },
        "highlight": {
            "order": "score",
            "fields": {
                "content": {
                    "matched_fields": ["content", "content.plain"],
                    "type" : "fvh"
                }
            }
        }
    }

The above matches both "run with scissors" and "running with scissors" and would highlight "running" and "scissors" but not "run". If both phrases appear in a large document then "running with scissors" is sorted above "run with scissors" in the fragments list because there are more matches in that fragment.
    
    
    GET /_search
    {
        "query": {
            "query_string": {
                "query": "running scissors",
                "fields": ["content", "content.plain^10"]
            }
        },
        "highlight": {
            "order": "score",
            "fields": {
                "content": {
                    "matched_fields": ["content", "content.plain"],
                    "type" : "fvh"
                }
            }
        }
    }

The above highlights) is boosted.
    
    
    GET /_search
    {
        "query": {
            "query_string": {
                "query": "running scissors",
                "fields": ["content", "content.plain^10"]
            }
        },
        "highlight": {
            "order": "score",
            "fields": {
                "content": {
                    "matched_fields": ["content.plain"],
                    "type" : "fvh"
                }
            }
        }
    }

The above query wouldn’t highlight "run" or "scissor" but shows that it is just fine not to list the field to which the matches are combined (`content`) in the matched fields.

![Note](images/icons/note.png)

Technically it is also fine to add fields to `matched_fields` that don’t share the same underlying string as the field to which the matches are combined. The results might not make much sense and if one of the matches is off the end of the text then the whole query will fail.

![Note](images/icons/note.png)

There is a small amount of overhead involved with setting `matched_fields` to a non-empty array so always prefer
    
    
        "highlight": {
            "fields": {
                "content": {}
            }
        }

to
    
    
        "highlight": {
            "fields": {
                "content": {
                    "matched_fields": ["content"],
                    "type" : "fvh"
                }
            }
        }

### Phrase Limit

The fast vector highlighter has a `phrase_limit` parameter that prevents it from analyzing too many phrases and eating tons of memory. It defaults to 256 so only the first 256 matching phrases in the document scored considered. You can raise the limit with the `phrase_limit` parameter but keep in mind that scoring more phrases consumes more time and memory.

If using `matched_fields` keep in mind that `phrase_limit` phrases per matched field are considered.

### Field Highlight Order

Elasticsearch highlights the fields in the order that they are sent. Per the json spec objects are unordered but if you need to be explicit about the order that fields are highlighted then you can use an array for `fields` like this:
    
    
    GET /_search
    {
        "highlight": {
            "fields": [
                { "title": {} },
                { "text": {} }
            ]
        }
    }

None of the highlighters built into Elasticsearch care about the order that the fields are highlighted but a plugin may.