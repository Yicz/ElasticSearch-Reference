# 删除文档
删除文件相当简单。 此示例显示如何删除我们以前的客户，其ID为2：

```sh
DELETE /customer/external/2?pretty
```
请参阅[_delete_by_query API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-delete-by-query.html)以删除与特定查询匹配的所有文档。 值得注意的是，删除整个索引而不是使用Delete By Query API删除所有文档会更有效率。