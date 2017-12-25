##  基于URL的访问控制 URL-based access control

许多用户使用基于URL的访问控制代理来保护对Elasticsearch索引的访问。 对于[multi-search](search-multi-search.html)，[multi-get](docs-multi-get.html)和[bulk](docs-bulk.html "批量API")请求，用户可以选择在URL中指定一个索引，也可以在请求体内的每个请求中指定一个索引。 这可以使基于URL的访问控制具有挑战性。

为了防止用户重写已经在URL中指定的索引，将这个设置添加到`elasticsearch.yml`文件中：
    
     rest.action.multi.allow_explicit_index：false

默认值是“true”，但是当设置为“false”时，Elasticsearch将拒绝在请求体中指定具有明确索引的请求。
