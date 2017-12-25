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
      "query": { ![](images/icons/callouts/1.png)
        "bool": { ![](images/icons/callouts/2.png)
          "must": [
            { "match": { "title":   "Search"        } }, ![](images/icons/callouts/3.png)
            { "match": { "content": "Elasticsearch" } }  ![](images/icons/callouts/4.png)
          ],
          "filter": [ ![](images/icons/callouts/5.png)
            { "term":  { "status": "published" } }, ![](images/icons/callouts/6.png)
            { "range": { "publish_date": { "gte": "2015-01-01" } } } ![](images/icons/callouts/7.png)
          ]
        }
      }
    }

![](images/icons/callouts/1.png)

| 

The `query` parameter indicates query context.   
  
---|---  
  
![](images/icons/callouts/2.png) ![](images/icons/callouts/3.png) ![](images/icons/callouts/4.png)

| 

The `bool` and two `match` clauses are used in query context, which means that they are used to score how well each document matches.   
  
![](images/icons/callouts/5.png)

| 

The `filter` parameter indicates filter context.   
  
![](images/icons/callouts/6.png) ![](images/icons/callouts/7.png)

| 

The `term` and `range` clauses are used in filter context. They will filter out documents which do not match, but they will not affect the score for matching documents.   
  
![Tip](images/icons/tip.png)

Use query clauses in query context for conditions which should affect the score of matching documents (i.e. how well does the document match), and use all other query clauses in filter context.
