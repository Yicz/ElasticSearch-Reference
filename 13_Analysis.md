# Analysis

 _Analysis_ is the process of converting text, like the body of any email, into _tokens_ or _terms_ which are added to the inverted index for searching. Analysis is performed by an [_analyzer_](analysis-analyzers.html "Analyzers") which can be either a built-in analyzer or a [`custom`](analysis-custom-analyzer.html "Custom Analyzer") analyzer defined per index.

## Index time analysis

For instance at index time, the built-in [`english`](analysis-lang-analyzer.html#english-analyzer "english analyzer") _analyzer_ would convert this sentence:
    
    
    "The QUICK brown foxes jumped over the lazy dog!"

into these terms, which would be added to the inverted index.
    
    
    [ quick, brown, fox, jump, over, lazi, dog ]

### Specifying an index time analyzer

Each [`text`](text.html "Text datatype") field in a mapping can specify its own [`analyzer`](analyzer.html "analyzer"):
    
    
    PUT my_index
    {
      "mappings": {
        "my_type": {
          "properties": {
            "title": {
              "type":     "text",
              "analyzer": "standard"
            }
          }
        }
      }
    }

At index time, if no `analyzer` has been specified, it looks for an analyzer in the index settings called `default`. Failing that, it defaults to using the [`standard` analyzer](analysis-standard-analyzer.html "Standard Analyzer").

## Search time analysis

This same analysis process is applied to the query string at search time in [full text queries](full-text-queries.html "Full text queries") like the [`match` query](query-dsl-match-query.html "Match Query") to convert the text in the query string into terms of the same form as those that are stored in the inverted index.

For instance, a user might search for:
    
    
    "a quick fox"

which would be analysed by the same `english` analyzer into the following terms:
    
    
    [ quick, fox ]

Even though the exact words used in the query string don’t appear in the original text (`quick` vs `QUICK`, `fox` vs `foxes`), because we have applied the same analyzer to both the text and the query string, the terms from the query string exactly match the terms from the text in the inverted index, which means that this query would match our example document.

### Specifying a search time analyzer

Usually the same analyzer should be used both at index time and at search time, and [full text queries](full-text-queries.html "Full text queries") like the [`match` query](query-dsl-match-query.html "Match Query") will use the mapping to look up the analyzer to use for each field.

The analyzer to use to search a particular field is determined by looking for:

  * An `analyzer` specified in the query itself. 
  * The [`search_analyzer`](search-analyzer.html "search_analyzer") mapping parameter. 
  * The [`analyzer`](analyzer.html "analyzer") mapping parameter. 
  * An analyzer in the index settings called `default_search`. 
  * An analyzer in the index settings called `default`. 
  * The `standard` analyzer. 


