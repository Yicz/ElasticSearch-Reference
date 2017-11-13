# 列出所有的索引（indices）
我们行来看一下我们的全部索引：

```sh
# 使用kibana
GET /_cat/indices?v
# 使用命令行
curl -XGET http://localhost:9200/_cat/indices?v
```
它会返回：

```sh
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
```
这仅仅意味着我们还没有索引（indices）的集群。