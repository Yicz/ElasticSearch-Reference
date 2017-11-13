# 创建一个索引
我们现在来创建一个名为“customer”的索引,然后再列出全部索引：

```sh
# 使用kibana
PUT /customer?pretty
GET /_cat/indices?v
# 使用命令行
curl -XPUT http://localhost:9200/customer?pretty
curl -XGET http://localhost:9200/_cat/indices?v
```

第一个命令使用PUT动词创建名为“customer”的索引。 我们只是简单地追加pretty到请求尾部，告诉它漂亮地打印JSON响应（如果有的话）。

它的响应是：

```sh
health status index    uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   customer 95SQ4TSUT7mWBT7VNHH67A   5   1          0            0       260b           260
```

第二个命令的结果告诉我们，现在我们有一个名为customer的索引，它有5个主分片和1个副本（默认值），它包含0个文档。

您可能还会注意到，客户索引标有黄色的健康状况。 回想一下我们之前的讨论，黄色意味着一些复制品还没有被分配。 这个索引发生的原因是因为Elasticsearch默认为这个索引创建了一个副本。 由于此刻我们只有一个节点正在运行，因此，在另一个节点加入集群的较晚时间点之前，尚无法分配一个副本（以获得高可用性）。 一旦该副本被分配到第二个节点上，该索引的健康状态将变成绿色。