# The Search API

现在让我们开始一些简单的搜索。 有两种运行搜索的基本方法：一种是通过[REST请求URI发送搜索参数](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/search-uri-request.html)，另一种是通过[REST请求主体发送搜索参数](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/search-request-body.html)。 请求主体方法允许您更具表现力，并以更易读的JSON格式定义您的搜索。 我们将尝试请求URI方法的一个例子，但在本教程的剩余部分中，我们将专门使用请求主体方法。

用于搜索的REST API可从_search端点访问。 本示例返回银行索引中的所有文档：

```sh
GET /bank/_search?q=*&sort=account_number:asc&pretty
```

我们首先解析搜索调用。 我们在银行索引中搜索（_search endpoint），并且q = *参数指示Elasticsearch匹配索引中的所有文档。 sort = account_number：asc参数指示使用每个文档的account_number字段按升序对结果进行排序。 参数pretty告诉Elasticsearch返回格式化后的JSON结果，如下：

```sh
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
```

在响应内容中，我们看到以下部分：

Elasticsearch花费了几毫秒的时间来执行搜索

* timed_out - 告诉我们搜索是否超时
* _shards - 告诉我们搜索了多少碎片，以及搜索碎片成功/失败的次数
* hits - 搜索结果
* hits.total - 符合我们搜索条件的文件总数
* hits.hits - 实际的搜索结果数组（默认为前10个文档）
* hits.sort - 结果排序键（按分数排序时缺失）
* hits._score和max_score - 现在忽略这些字段

以上是使用替代请求主体方法的上述相同的确切搜索：

```sh
# kibana
GET /bank/_search
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ]
}
```
这里的区别在于，不是在URI中传递q = *，而是将JSON风格的查询请求主体发布到**_search API**。 我们将在下一节讨论这个JSON查询。

重要的是要明白，一旦你得到你的搜索结果，Elasticsearch完成与请求，并没有维护任何种类的服务器端资源或打开游标到你的结果。 这与许多其他平台（如SQL）形成鲜明对比，其中您最初可能会首先获得查询结果的部分子集，然后如果要获取（或翻阅）其余部分，则必须连续返回到服务器的结果使用某种有状态的服务器端游标。