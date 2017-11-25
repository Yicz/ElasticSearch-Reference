## Term level queries

While the [full text queries](full-text-queries.html "Full text queries") will analyze the query string before executing, the _term-level queries_ operate on the exact terms that are stored in the inverted index.

These queries are usually used for structured data like numbers, dates, and enums, rather than full text fields. Alternatively, they allow you to craft low-level queries, foregoing the analysis process.

The queries in this group are:

[`term` query](query-dsl-term-query.html "Term Query")
     Find documents which contain the exact term specified in the field specified. 
[`terms` query](query-dsl-terms-query.html "Terms Query")
     Find documents which contain any of the exact terms specified in the field specified. 
[`range` query](query-dsl-range-query.html "Range Query")
     Find documents where the field specified contains values (dates, numbers, or strings) in the range specified. 
[`exists` query](query-dsl-exists-query.html "Exists Query")
     Find documents where the field specified contains any non-null value. 
[`prefix` query](query-dsl-prefix-query.html "Prefix Query")
     Find documents where the field specified contains terms which begin with the exact prefix specified. 
[`wildcard` query](query-dsl-wildcard-query.html "Wildcard Query")
     Find documents where the field specified contains terms which match the pattern specified, where the pattern supports single character wildcards (`?`) and multi-character wildcards (`*`) 
[`regexp` query](query-dsl-regexp-query.html "Regexp Query")
     Find documents where the field specified contains terms which match the [regular expression](query-dsl-regexp-query.html#regexp-syntax "Regular expression syntax") specified. 
[`fuzzy` query](query-dsl-fuzzy-query.html "Fuzzy Query")
     Find documents where the field specified contains terms which are fuzzily similar to the specified term. Fuzziness is measured as a [Levenshtein edit distance](http://en.wikipedia.org/wiki/Damerau%E2%80%93Levenshtein_distance) of 1 or 2. 
[`type` query](query-dsl-type-query.html "Type Query")
     Find documents of the specified type. 
[`ids` query](query-dsl-ids-query.html "Ids Query")
     Find documents with the specified type and IDs. 
