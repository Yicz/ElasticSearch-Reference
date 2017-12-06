## 查询API

现在让我们做一些简单的查询，这里有两种方式去执行查询操作：一种是通过使用[REST request URI](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/search-uri-request.html)发送URI参数，另一种是参过[REST request body](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/search-request-body.html)发送请求体。发送请求体的方式能更准确地表述请求条件同时也能有一个可阅读的JSON格式。我们会尝试一下使用[REST request RUI]()做为一个教程，我们更加倾向使用[REST reqeust body]()

使用查询的REST API接口是`_search`，下面的例子是返回`bank`索引中的所有文档：    
    
    GET /bank/_search?q=*&sort=account_number:asc&pretty

下面详细介绍一下这个请求的具体内容：我们使用了`_search`接口查询`bank`索引，并使用了`q=*`参数去匹配索引中所有的文档，然后使用了`sort=account_number:asc`参数去指定结果的排序为`account_number`的增序。再一次我们使用了`pretty`参数将回去的JSON结果进行格式化。

显示部分响应内容:
    
    
    {
      "took" : 63,
      "timed_out" : false,
      "_shards" : {
        "total" : 5,
        "successful" : 5,
        "failed" : 0
      },
      "hits" : {
        "total" : 1000,
        "max_score" : null,
        "hits" : [ {
          "_index" : "bank",
          "_type" : "account",
          "_id" : "0",
          "sort": [0],
          "_score" : null,
          "_source" : {"account_number":0,"balance":16623,"firstname":"Bradshaw","lastname":"Mckenzie","age":29,"gender":"F","address":"244 Columbus Place","employer":"Euron","email":"bradshawmckenzie@euron.com","city":"Hobucken","state":"CO"}
        }, {
          "_index" : "bank",
          "_type" : "account",
          "_id" : "1",
          "sort": [1],
          "_score" : null,
          "_source" : {"account_number":1,"balance":39225,"firstname":"Amber","lastname":"Duke","age":32,"gender":"M","address":"880 Holmes Lane","employer":"Pyrami","email":"amberduke@pyrami.com","city":"Brogan","state":"IL"}
        }, ...
        ]
      }
    }

在响应内容中，我们看到了如下的内容

  * `took` – ES执行耗费的时间 
  * `timed_out` –告诉我的查询是否超时
  * `_shards` – 告诉我们查询了多少分片，并详细说明有多少分片是成功/失败的
  * `hits` – 查询结果
  * `hits.total` – 匹配的查询结果
  * `hits.hits` – 实际的查询结果
  * `hits.sort` \- 排序的关键字
  * `hits._score` and `max_score` \- 暂时忽略这个内容




下面是使用[reqeust body method]()的方式 
    
    GET /bank/_search
    {
      "query": { "match_all": {} },
      "sort": [
        { "account_number": "asc" }
      ]
    }

这里的主要区别是使用了JSON风格的请求体替换了使用`_search`接口的URI参数`q=*`，在下一节，我们将详细说明JSON的内容。


理解结果返回的每一个字段对刚开始学习的人来说是很重要的。ES完全执行请求并不会包含额外的数据在返回结果中。这中SQL平台的数据有一个区别，SQL平台会返回一个服务端的游标。
