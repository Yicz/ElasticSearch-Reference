## Executing Aggregations

Aggregations provide the ability to group and extract statistics from your data. The easiest way to think about aggregations is by roughly equating it to the SQL GROUP BY and the SQL aggregate functions. In Elasticsearch, you have the ability to execute searches returning hits and at the same time return aggregated results separate from the hits all in one response. This is very powerful and efficient in the sense that you can run queries and multiple aggregations and get the results back of both (or either) operations in one shot avoiding network roundtrips using a concise and simplified API.

To start with, this example groups all the accounts by state, and then returns the top 10 (default) states sorted by count descending (also default):
    
    
    GET /bank/_search
    {
      "size": 0,
      "aggs": {
        "group_by_state": {
          "terms": {
            "field": "state.keyword"
          }
        }
      }
    }

In SQL, the above aggregation is similar in concept to:
    
    
    SELECT state, COUNT(*) FROM bank GROUP BY state ORDER BY COUNT(*) DESC

And the response (partially shown):
    
    
    {
      "took": 29,
      "timed_out": false,
      "_shards": {
        "total": 5,
        "successful": 5,
        "failed": 0
      },
      "hits" : {
        "total" : 1000,
        "max_score" : 0.0,
        "hits" : [ ]
      },
      "aggregations" : {
        "group_by_state" : {
          "doc_count_error_upper_bound": 20,
          "sum_other_doc_count": 770,
          "buckets" : [ {
            "key" : "ID",
            "doc_count" : 27
          }, {
            "key" : "TX",
            "doc_count" : 27
          }, {
            "key" : "AL",
            "doc_count" : 25
          }, {
            "key" : "MD",
            "doc_count" : 25
          }, {
            "key" : "TN",
            "doc_count" : 23
          }, {
            "key" : "MA",
            "doc_count" : 21
          }, {
            "key" : "NC",
            "doc_count" : 21
          }, {
            "key" : "ND",
            "doc_count" : 21
          }, {
            "key" : "ME",
            "doc_count" : 20
          }, {
            "key" : "MO",
            "doc_count" : 20
          } ]
        }
      }
    }

We can see that there are 27 accounts in `ID` (Idaho), followed by 27 accounts in `TX` (Texas), followed by 25 accounts in `AL` (Alabama), and so forth.

Note that we set `size=0` to not show search hits because we only want to see the aggregation results in the response.

Building on the previous aggregation, this example calculates the average account balance by state (again only for the top 10 states sorted by count in descending order):
    
    
    GET /bank/_search
    {
      "size": 0,
      "aggs": {
        "group_by_state": {
          "terms": {
            "field": "state.keyword"
          },
          "aggs": {
            "average_balance": {
              "avg": {
                "field": "balance"
              }
            }
          }
        }
      }
    }

Notice how we nested the `average_balance` aggregation inside the `group_by_state` aggregation. This is a common pattern for all the aggregations. You can nest aggregations inside aggregations arbitrarily to extract pivoted summarizations that you require from your data.

Building on the previous aggregation, let’s now sort on the average balance in descending order:
    
    
    GET /bank/_search
    {
      "size": 0,
      "aggs": {
        "group_by_state": {
          "terms": {
            "field": "state.keyword",
            "order": {
              "average_balance": "desc"
            }
          },
          "aggs": {
            "average_balance": {
              "avg": {
                "field": "balance"
              }
            }
          }
        }
      }
    }

This example demonstrates how we can group by age brackets (ages 20-29, 30-39, and 40-49), then by gender, and then finally get the average account balance, per age bracket, per gender:
    
    
    GET /bank/_search
    {
      "size": 0,
      "aggs": {
        "group_by_age": {
          "range": {
            "field": "age",
            "ranges": [
              {
                "from": 20,
                "to": 30
              },
              {
                "from": 30,
                "to": 40
              },
              {
                "from": 40,
                "to": 50
              }
            ]
          },
          "aggs": {
            "group_by_gender": {
              "terms": {
                "field": "gender.keyword"
              },
              "aggs": {
                "average_balance": {
                  "avg": {
                    "field": "balance"
                  }
                }
              }
            }
          }
        }
      }
    }

There are many other aggregations capabilities that we won’t go into detail here. The [aggregations reference guide](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/search-aggregations.html) is a great starting point if you want to do further experimentation.
