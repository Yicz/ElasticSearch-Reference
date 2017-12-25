## Percolator

![Warning](images/icons/warning.png)

### Deprecated in 5.0.0. 

Percolate and multi percolate APIs are deprecated and have been replaced by the new [`percolate` query](query-dsl-percolate-query.html)

For indices created on or after version 5.0.0-alpha1 the percolator automatically indexes the query terms with the percolator queries. This allows the percolator to percolate documents more quickly. It is advisable to reindex any pre 5.0.0 indices to take advantage of this new optimization.
