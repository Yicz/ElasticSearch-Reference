# 索引名称支持日期数学
日期数学索引名称解析使您可以搜索一系列时间序列的索引，而不是搜索所有时间序列索引，并过滤结果或保留别名。 限制搜索索引的数量会减少集群的负载，并提高执行性能。 例如，如果要在日常日志中搜索错误，则可以使用日期数学名称模板将搜索限制在过去两天。

几乎所有具有索引参数的API都支持索引参数值中的数学计算。

日期数学索引名称采用以下形式：

```sh
|<static_name{date_math_expr{date_formate|time+zone}}> | # static_name 是索引名称的一部分 |
# date_match_expr是一个动态数据表达式，用来计算动态的日期
# date_formate 日期的可选格式 默认为YYYY.MM.dd
# time_zone 可以选择的时区 默认 utc.
```

|上面格式的<尖角括号> | angle brackets)是必须的，同时要使用进行URI编码,举个粟子： |

```sh
|# GET /<logstash-{now/d}> | _search |
curl -XGET 'localhost:9200/%3Clogstash-%7Bnow%2Fd%7D%3E/_search?pretty' -H 'Content-Type: application/json' -d'
{
  "query" : {
    "match": {
      "test": "data"
    }
  }
}
'
```
以下示例显示了不同格式的日期数学索引名称以及在当前时间为2024年3月22日中午utc时解析的最终索引名称。

|表达式	| 解析结果 |
|:---|:--|
|\<logstash-{now/d}> | logstash-2024.03.22 |
|\<logstash-{now/M}> | logstash-2024.03.01 |
|\<logstash-{now/M{YYYY.MM}}> | logstash-2024.03 |
|\<logstash-{now/M-1M{YYYY.MM}}> | logstash-2024.02 |
|\<logstash-{now/d{YYYY.MM.dd\|+12:00}}> | logstash-2024.03.23 |

如果静态名称部分包含了{},则要用到\\对它们进行转义

```sh
<elastic\\{ON\\}>-{now/M} 解析为 elatic{ON}-2024.03.01
```

下面的示例显示了一个搜索请求,搜索Logstash指数在过去三天,假设指标使用默认Logstash索引名称格式,logstash-YYYY.MM.dd。

```sh
# GET /<logstash-{now/d-2d}>,<logstash-{now/d-1d}>,<logstash-{now/d}>/_search
curl -XGET 'localhost:9200/%3Clogstash-%7Bnow%2Fd-2d%7D%3E%2C%3Clogstash-%7Bnow%2Fd-1d%7D%3E%2C%3Clogstash-%7Bnow%2Fd%7D%3E/_search?pretty' -H 'Content-Type: application/json' -d'
{
  "query" : {
    "match": {
      "test": "data"
    }
  }
}
'
```