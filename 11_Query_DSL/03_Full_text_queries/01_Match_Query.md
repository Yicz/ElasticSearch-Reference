## Match Query

`match` queries accept text/numerics/dates, analyzes them, and constructs a query. For example:
    
    
    GET /_search
    {
        "query": {
            "match" : {
                "message" : "this is a test"
            }
        }
    }

Note, `message` is the name of a field, you can substitute the name of any field (including `_all`) instead.

### match

The `match` query is of type `boolean`. It means that the text provided is analyzed and the analysis process constructs a boolean query from the provided text. The `operator` flag can be set to `or` or `and` to control the boolean clauses (defaults to `or`). The minimum number of optional `should` clauses to match can be set using the [`minimum_should_match`](query-dsl-minimum-should-match.html) parameter.

The `analyzer` can be set to control which analyzer will perform the analysis process on the text. It defaults to the field explicit mapping definition, or the default search analyzer.

The `lenient` parameter can be set to `true` to ignore exceptions caused by data-type mismatches, such as trying to query a numeric field with a text query string. Defaults to `false`.

#### Fuzziness

`fuzziness` allows _fuzzy matching_ based on the type of field being queried. See [Fuzziness for allowed settings.

The `prefix_length` and `max_expansions` can be set in this case to control the fuzzy process. If the fuzzy option is set the query will use `top_terms_blended_freqs_${max_expansions}` as its [rewrite method](query-dsl-multi-term-rewrite.html) the `fuzzy_rewrite` parameter allows to control how the query will get rewritten.

Fuzzy transpositions (`ab` → `ba`) are allowed by default but can be disabled by setting `fuzzy_transpositions` to `false`.

Here is an example when providing additional parameters (note the slight change in structure, `message` is the field name):
    
    
    GET /_search
    {
        "query": {
            "match" : {
                "message" : {
                    "query" : "this is a test",
                    "operator" : "and"
                }
            }
        }
    }

#### Zero terms query

If the analyzer used removes all tokens in a query like a `stop` filter does, the default behavior is to match no documents at all. In order to change that the `zero_terms_query` option can be used, which accepts `none` (default) and `all` which corresponds to a `match_all` query.
    
    
    GET /_search
    {
        "query": {
            "match" : {
                "message" : {
                    "query" : "to be or not to be",
                    "operator" : "and",
                    "zero_terms_query": "all"
                }
            }
        }
    }

#### Cutoff frequency

The match query supports a `cutoff_frequency` that allows specifying an absolute or relative document frequency where high frequency terms are moved into an optional subquery and are only scored if one of the low frequency (below the cutoff) terms in the case of an `or` operator or all of the low frequency terms in the case of an `and` operator match.

This query allows handling `stopwords` dynamically at runtime, is domain independent and doesn’t require a stopword file. It prevents scoring / iterating high frequency terms and only takes the terms into account if a more significant / lower frequency term matches a document. Yet, if all of the query terms are above the given `cutoff_frequency` the query is automatically transformed into a pure conjunction (`and`) query to ensure fast execution.

The `cutoff_frequency` can either be relative to the total number of documents if in the range `[0..1)` or absolute if greater or equal to `1.0`.

Here is an example showing a query composed of stopwords exclusively:
    
    
    GET /_search
    {
        "query": {
            "match" : {
                "message" : {
                    "query" : "to be or not to be",
                    "cutoff_frequency" : 0.001
                }
            }
        }
    }

![Important](images/icons/important.png)

The `cutoff_frequency` option operates on a per-shard-level. This means that when trying it out on test indexes with low document numbers you should follow the advice in [Relevance is broken](https://www.elastic.co/guide/en/elasticsearch/guide/2.x/relevance-is-broken.html).

 **Comparison to query_string / field**

The match family of queries does not go through a "query parsing" process. It does not support field name prefixes, wildcard characters, or other "advanced" features. For this reason, chances of it failing are very small / non existent, and it provides an excellent behavior when it comes to just analyze and run that text as a query behavior (which is usually what a text search box does). Also, the `phrase_prefix` type can provide a great "as you type" behavior to automatically load search results.