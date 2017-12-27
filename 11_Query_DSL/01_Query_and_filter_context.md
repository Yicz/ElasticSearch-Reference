## Query and filter context

The behaviour of a query clause depends on whether it is used in _query context_ or in _filter context_ :

Query context 
    

A query clause used in query context answers the question “ _How well does this document match this query clause?_ ” Besides deciding whether or not the document matches, the query clause also calculates a `_score` representing how well the document matches, relative to other documents.

Query context is in effect whenever a query clause is passed to a `query` parameter, such as the `query` parameter in the [`search`](search-request-query.html) API.

Filter context 
    

In _filter_ context, a query clause answers the question “ _Does this document match this query clause?_ ” The answer is a simple Yes or No — no scores are calculated. Filter context is mostly used for filtering structured data, e.g.

  * _Does this`timestamp` fall into the range 2015 to 2016?_
  * _Is the`status` field set to `"published"`_? 



Frequently used filters will be cached automatically by Elasticsearch, to speed up performance.

Filter context is in effect whenever a query clause is passed to a `filter` parameter, such as the `filter` or `must_not` parameters in the [`bool`](query-dsl-bool-query.html) query, the `filter` parameter in the [`constant_score`](query-dsl-constant-score-query.html) query, or the [`filter`](search-aggregations-bucket-filter-aggregation.html) aggregation.

Below is an example of query clauses being used in query and filter context in the `search` API. This query will match documents where all of the following conditions are met:

  * The `title` field contains the word `search`. 
  * The `content` field contains the word `elasticsearch`. 
  * The `status` field contains the exact word `published`. 
  * The `publish_date` field contains a date from 1 Jan 2015 onwards. 


    
    
    GET /_search
    {
      "query": { <1>
        "bool": { <2>
          "must": [
            { "match": { "title":   "Search"        } }, <3>
            { "match": { "content": "Elasticsearch" } }  <4>
          ],
          "filter": [ <5>
            { "term":  { "status": "published" } }, <6>
            { "range": { "publish_date": { "gte": "2015-01-01" } } } <7>
          ]
        }
      }
    }

<1>| The `query` parameter indicates query context.     
---|---    
<2> <3> <4>| The `bool` and two `match` clauses are used in query context, which means that they are used to score how well each document matches.     
<5>| The `filter` parameter indicates filter context.     
<6> <7>| The `term` and `range` clauses are used in filter context. They will filter out documents which do not match, but they will not affect the score for matching documents.   
  
![Tip](/images/icons/tip.png)

Use query clauses in query context for conditions which should affect the score of matching documents (i.e. how well does the document match), and use all other query clauses in filter context.
