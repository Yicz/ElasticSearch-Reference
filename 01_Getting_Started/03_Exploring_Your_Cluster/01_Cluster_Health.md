## Cluster Health

我们从查看集群的基本健康状态检查开始。我们使用的工具的是`curl`,当然你也可以使用任何HTTP/REST的工具。在启动有ES节点的机器上打开一个shell窗口。

为了检查集群的健康，我们要使用[`cat`API](../09_cat_APIs/05_cat_health.md),你可以在[Kibana’s Console](https://www.elastic.co/guide/en/kibana/5.4/console-kibana.html)，也可以查看命令的状态，也可以从[Kibana’s Console](https://www.elastic.co/guide/en/kibana/5.4/console-kibana.html) 复制`curl`的格式，在终端上进行执行。 
    
    GET /_cat/health?v

响应内容:
    
    epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
    1475247709 17:01:49  elasticsearch green           1         1      0   0    0    0        0             0                  -                100.0%

我们可以看到我们`elasticsearch`集群的运行状态是绿色。

当我们请求查询一个ES的集群状态的时候，我们得到的状态可能是绿色，黄色，红色，绿色代表一切正常（集群功能正常），黄色代表全部数据可用，但一些副本没有被分配（集群功能正常），最后黄色代码因记某些原因一些数据不可用。特别指出，ES的状态即使是红色，ES的部分功能和数据都是可以正常执行的（举例:ES集群会将请求转发到正常运行的节点分片上）但你必须去修复不能正常运行的节点否则你将会丢失部分数据。

在上面的响应内容中，我们可以看总共一个节点包含了0个分片同时也没有任何的数据。提示：我们使用了默认的群集名称elasitcsearch,ES会使用广播在网络中发现elasticsearch集群节点并加入群集。如果你在你的机器上可以启动更多的其他节点，在上面的例子中你可以看到不止一个节点。

我们也可以获取一个群集中节点的列表，如下命令：
    
    GET /_cat/nodes?v

响应如下:
    
    
    ip        heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
    127.0.0.1           10           5   5    4.46                        mdi      *      PB2SGZY

在这里，我们看到名称为"PB2SGZY"的节点，它是当前集群中的单节点。