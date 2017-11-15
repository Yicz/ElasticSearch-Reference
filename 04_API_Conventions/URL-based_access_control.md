# 基于URL的权限控制

许多用户使用代理和基于url的访问控制安全访问Elasticsearch索引。[multi-search](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/search-multi-search.html) [multi-get](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-multi-get.html)和[bulk](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-bulk.html)请求,用户在URL中指定索引的选择和对每个请求在请求体中。这可以使基于url的访问控制的质疑。 　　 　

防止URL中指定索引导致用户索引被覆盖的问题，有elasticsearch.yml文件中指定如下内容：

```yaml
rest.action.multi.allow_explicit_index:false
```

这个配置的默认值：true,当设置为false的时候.elasticserch将会拒绝一个显式指定索引的请求。