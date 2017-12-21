## 执行聚合

聚合提供组合和分析你数据的能力。可以简单地想象聚合（aggregations）类似于`SQL GROUP BY`和SQL的聚合函数。在ES中，你可以在一个请求聚合查询结果，这个功能是非常强大和高效的，你可以使用一个请求来避免大量的网络传输和聚合所有请求结果。


下面的例子，通过account的state进行分组并返回默认10个文档，state的的排序是倒序的（ES默认）    
    
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

使用SQL来替换上面的请求：    
    
    SELECT state, COUNT(*) FROM bank GROUP BY state ORDER BY COUNT(*) DESC

响应内容（只展示部分）：    
    
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
    
我们可以看到27个文档的国家（state）是`ID`,27个文档是`TX`,还有25个文档是`AL`,等等。


提示：我们设置了sieze=0,进行不显示查询到的文档，只查看聚合函数的结果。


在前面聚合的基础上，下面的例子求account的各个state的balance的平均值（默认的返回10个聚合结果，并还是统计个数倒排序）
    
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

提示：我们在`group_by_state`中嵌套了`average_balance`聚合。这个模式可以使用于全部的聚合。你可以嵌套一个聚合到另外一个聚合中。

在前面的聚合基础上，我们来排序balance的平均值，使用倒排序：
    
    
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

下面的例子展示了使用年龄范围聚合和性别聚合并计算balance平均值的聚合。    
    
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

还是更多的聚合类型，这是不进行详细阐述，请自行参考[聚合参考的指南](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/search-aggregations.html)。