## 删除一个文档

删除一个文档是简单容易的，下面例子展示了如何删除之前我们`custome`索引中类型`external`主键为2的文档：
    
    DELETE /customer/external/2?pretty

查阅[`_delete_by_query` API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-delete-by-query.html)通过查询功能批量删除文档. 没有比查询删除（DELETE BY QUERY API）更加高效的批量删除操作了。

