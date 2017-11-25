## Executing Filters

In the previous div, we skipped over a little detail called the document score (`_score` field in the search results). The score is a numeric value that is a relative measure of how well the document matches the search query that we specified. The higher the score, the more relevant the document is, the lower the score, the less relevant the document is.

But queries do not always need to produce scores, in particular when they are only used for "filtering" the document set. Elasticsearch detects these situations and automatically optimizes query execution in order not to compute useless scores.

The [`bool` query](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/query-dsl-bool-query.html) that we introduced in the previous div also supports `filter` clauses which allow to use a query to restrict the documents that will be matched by other clauses, without changing how scores are computed. As an example, let’s introduce the [`range` query](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/query-dsl-range-query.html), which allows us to filter documents by a range of values. This is generally used for numeric or date filtering.

This example uses a bool query to return all accounts with balances between 20000 and 30000, inclusive. In other words, we want to find accounts with a balance that is greater than or equal to 20000 and less than or equal to 30000.
    
    
    GET /bank/_search
    {
      "query": {
        "bool": {
          "must": { "match_all": {} },
          "filter": {
            "range": {
              "balance": {
                "gte": 20000,
                "lte": 30000
              }
            }
          }
        }
      }
    }

Dissecting the above, the bool query contains a `match_all` query (the query part) and a `range` query (the filter part). We can substitute any other queries into the query and the filter parts. In the above case, the range query makes perfect sense since documents falling into the range all match "equally", i.e., no document is more relevant than another.

In addition to the `match_all`, `match`, `bool`, and `range` queries, there are a lot of other query types that are available and we won’t go into them here. Since we already have a basic understanding of how they work, it shouldn’t be too difficult to apply this knowledge in learning and experimenting with the other query types.
