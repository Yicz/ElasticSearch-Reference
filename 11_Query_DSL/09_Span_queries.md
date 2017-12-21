## Span queries

Span queries are low-level positional queries which provide expert control over the order and proximity of the specified terms. These are typically used to implement very specific queries on legal documents or patents.

Span queries cannot be mixed with non-span queries (with the exception of the `span_multi` query).

The queries in this group are:

[`span_term` query](query-dsl-span-term-query.html "Span Term Query")
     The equivalent of the [`term` query](query-dsl-term-query.html "Term Query") but for use with other span queries. 
[`span_multi` query](query-dsl-span-multi-term-query.html "Span Multi Term Query")
     Wraps a [`term`](query-dsl-term-query.html "Term Query"), [`range`](query-dsl-range-query.html "Range Query"), [`prefix`](query-dsl-prefix-query.html "Prefix Query"), [`wildcard`](query-dsl-wildcard-query.html "Wildcard Query"), [`regexp`](query-dsl-regexp-query.html "Regexp Query"), or [`fuzzy`](query-dsl-fuzzy-query.html "Fuzzy Query") query. 
[`span_first` query](query-dsl-span-first-query.html "Span First Query")
     Accepts another span query whose matches must appear within the first N positions of the field. 
[`span_near` query](query-dsl-span-near-query.html "Span Near Query")
     Accepts multiple span queries whose matches must be within the specified distance of each other, and possibly in the same order. 
[`span_or` query](query-dsl-span-or-query.html "Span Or Query")
     Combines multiple span queries — returns documents which match any of the specified queries. 
[`span_not` query](query-dsl-span-not-query.html "Span Not Query")
     Wraps another span query, and excludes any documents which match that query. 
[`span_containing` query](query-dsl-span-containing-query.html "Span Containing Query")
     Accepts a list of span queries, but only returns those spans which also match a second span query. 
[`span_within` query](query-dsl-span-within-query.html "Span Within Query")
     The result from a single span query is returned as long is its span falls within the spans returned by a list of other span queries. 
[`field_masking_span` query](query-dsl-span-field-masking-query.html "Span Field Masking Query")
     Allows queries like `span-near` or `span-or` across different fields. 
