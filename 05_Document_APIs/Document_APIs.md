# 文档API 编辑
本节首先简要介绍Elasticsearch的[数据复制模型](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-replication.html)，然后详细描述以下CRUD API：

单个文档API

* [索引API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-index_.html)
* [获取API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-get.html)
* [删除API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-delete.html)
* [更新API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-update.html)

多文档API
* [多获取API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-update.html)
* [批量API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-multi-get.html)
* [通过查询API删除](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-delete-by-query.html)
* [通过查询API更新](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-update-by-query.html)
* [Reindex API](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-reindex.html)

> ### Tips
> 所有的CRUD API都是单一索引的API。该index参数接受单个索引名称，或者alias指向单个索引。