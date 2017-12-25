## Full text queries

The high-level full text queries are usually used for running full text queries on full text fields like the body of an email. They understand how the field being queried is [analyzed](analysis.html) and will apply each field’s `analyzer` (or `search_analyzer`) to the query string before executing.

The queries in this group are:

[`match` query](query-dsl-match-query.html)
     The standard query for performing full text queries, including fuzzy matching and phrase or proximity queries. 
[`match_phrase` query](query-dsl-match-query-phrase.html)
     Like the `match` query but used for matching exact phrases or word proximity matches. 
[`match_phrase_prefix` query](query-dsl-match-query-phrase-prefix.html)
     The poor man’s _search-as-you-type_. Like the `match_phrase` query, but does a wildcard search on the final word. 
[`multi_match` query](query-dsl-multi-match-query.html)
     The multi-field version of the `match` query. 
[`common_terms` query](query-dsl-common-terms-query.html)
     A more specialized query which gives more preference to uncommon words. 
[`query_string` query](query-dsl-query-string-query.html)
     Supports the compact Lucene [query string syntax](query-dsl-query-string-query.html#query-string-syntax), allowing you to specify AND|OR|NOT conditions and multi-field search within a single query string. For expert users only. 
[`simple_query_string`](query-dsl-simple-query-string-query.html)
     A simpler, more robust version of the `query_string` syntax suitable for exposing directly to users. 
