## Joining queries

Performing full SQL-style joins in a distributed system like Elasticsearch is prohibitively expensive. Instead, Elasticsearch offers two forms of join which are designed to scale horizontally.

[`nested` query](query-dsl-nested-query.html)
     Documents may contain fields of type [`nested`](nested.html). These fields are used to index arrays of objects, where each object can be queried (with the `nested` query) as an independent document. 
[`has_child`](query-dsl-has-child-query.html) and [`has_parent`](query-dsl-has-parent-query.html) queries 
     A [parent-child relationship](mapping-parent-field.html) can exist between two document types within a single index. The `has_child` query returns parent documents whose child documents match the specified query, while the `has_parent` query returns child documents whose parent document matches the specified query. 

Also see the [terms-lookup mechanism](query-dsl-terms-query.html#query-dsl-terms-lookup) in the `terms` query, which allows you to build a `terms` query from values contained in another document.