## Analysis

The index analysis module acts as a configurable registry of _analyzers_ that can be used in order to convert a string field into individual terms which are:

  * added to the inverted index in order to make the document searchable 
  * used by high level queries such as the [`match` query](query-dsl-match-query.html "Match Query") to generate search terms. 



See [Analysis](analysis.html "Analysis") for configuration details.
