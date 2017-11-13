# 集群的健康
我们从一个基本的健康检查开始，我们可以用它来看看我们的集群是如何做的。 我们将使用curl来做到这一点，但是您可以使用任何工具来允许您进行HTTP / REST调用。 假设我们仍然在开始Elasticsearch的同一个节点上，并打开另一个命令外壳窗口。

为了检查集群健康状况，我们将使用_cat API。 您可以在***Kibana***的控制台中运行下面的命令，也可以使用命令行进行第二个命令：

```sh
#使用kibana
GET /_cat/health?v
#使用命令行
curl -XGET http://localhost:9200/_cat/health?v
```

它将会返回：

```sh
epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
1475247709 17:01:49  elasticsearch green           1         1      0   0    0    0        0             0                  -                100.0%
```


我们可以看到，我们的名为“elasticsearch”集群的状态是绿色的。

每当我们查看群集健康，我们看到的一定是绿色，黄色，或红色三种中的一种。绿色表示一切正常（群集完全正常），黄色表示所有数据都可用，但一些副本尚未分配（群集功能完全），红色表示某些数据因任何原因不可用。请注意，即使群集是红色的，它仍然是部分功能的（即它将继续提供来自可用分片的搜索请求），但是您可能需要尽快修复它，因为您缺少数据。

同样从上面的回答中，我们可以看到总共有1个节点，而我们有0个分片，因为我们还没有数据。请注意，由于我们使用的是默认集群名称（elasticsearch），并且由于Elasticsearch默认使用单播网络发现来查找同一台计算机上的其他节点，所以可能会意外启动计算机上的多个节点并使其全部加入一个集群。在这种情况下，您可能会在上述响应中看到多个节点。

我们也可以得到我们集群中的节点列表，如下所示：

```sh
#使用kibana
GET /_cat/node?v
#使用命令行
curl -XGET http://localhost:9200/_cat/node?v
```

它会返回：

```sh
ip        heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
127.0.0.1           10           5   5    4.46                        mdi      *      PB2SGZY
```
在这里,我们可以看到一个名为“PB2SGZY”的节点,这是单一节点,目前在我们的集群。