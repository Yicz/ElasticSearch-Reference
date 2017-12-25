## Specialized queries

This group contains queries which do not fit into the other groups:

[`more_like_this` query](query-dsl-mlt-query.html)
     This query finds documents which are similar to the specified text, document, or collection of documents. 
[`template` query](query-dsl-template-query.html)
     The `template` query accepts a Mustache template (either inline, indexed, or from a file), and a map of parameters, and combines the two to generate the final query to execute. 
[`script` query](query-dsl-script-query.html)
     This query allows a script to act as a filter. Also see the [`function_score` query](query-dsl-function-score-query.html). 
[`percolate` query](query-dsl-percolate-query.html)
     This query finds queries that are stored as documents that match with the specified document. 
