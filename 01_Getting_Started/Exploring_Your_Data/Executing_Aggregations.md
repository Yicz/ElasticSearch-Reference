# 执行聚合
聚合提供了从数据中分组和提取统计数据的能力。 考虑聚合的最简单方法是将其大致等同于SQL GROUP BY和SQL聚合函数。 在Elasticsearch中，您可以执行搜索并返回匹配，同时还可以在一个响应中返回与匹配不同的聚合结果。 这是非常强大和高效的，因为您可以运行查询和多个聚合，并一次性获得两个（或两个）操作的结果，从而避免使用简洁和简化的API进行网络往返。

首先，本示例按状态对所有帐户进行分组，然后返回按降序（也是默认值）排序的前10个（默认）状态：

```sh
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

#响应
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
```
在SQL中，上面的聚合在概念上类似于：

```sql
SELECT state, COUNT(*) FROM bank GROUP BY state ORDER BY COUNT(*) DESC
```

我们可以看到ID（Idaho）中有27个账户，其次是德克萨斯州的27个账户，其次是AL（阿拉巴马州）的25个账户，等等。

请注意，我们将size = 0设置为不显示搜索命中，因为我们只想看到响应中的聚合结果。

在前面的汇总基础上，本示例按状态计算平均账户余额（再次仅按前几位按降序排列的状态）：

```sh
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
```
注意我们如何嵌套group_by_state聚合内的average_balance聚合。 这是所有聚合的通用模式。 您可以任意嵌套聚合内的聚合，以便从数据中提取所需的旋转摘要。

基于以前的聚合，现在让我们按降序对平均余额进行排序：

```sh
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
```
这个例子演示了我们如何按年龄段（20-29岁，30-39岁和40-49岁）进行分组，然后按性别进行分组，然后最终得到每个年龄段的平均账户平衡：

```sh
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
```

还有很多其他聚合功能，我们在这里不会详细介绍。 如果您想进行进一步的实验，那么[聚合入门指南](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/search-aggregations.html)是一个很好的起点。


