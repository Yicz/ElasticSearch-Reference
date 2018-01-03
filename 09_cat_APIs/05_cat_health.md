## 查看健康状态 cat health

`health`是来自`/_cluster/health`的相同信息的简洁表示。
    
    GET /_cat/health?v
    
    
    epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
    1475871424 16:17:04  elasticsearch green           1         1      5   5    0    0        0             0                  -                100.0%

它有一个选项`ts`来禁用时间戳：    
    
    GET /_cat/health?v&ts=false

响应:
    
    
    cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
    elasticsearch green           1         1      5   5    0    0        0             0                  -                100.0%


此命令的一个常见用法是验证跨节点的运行状况是否一致：    
    
    % pssh -i -h list.of.cluster.hosts curl -s localhost:9200/_cat/health
    [1] 20:20:52 [SUCCESS] es3.vm
    1384309218 18:20:18 foo green 3 3 3 3 0 0 0 0
    [2] 20:20:52 [SUCCESS] es1.vm
    1384309218 18:20:18 foo green 3 3 3 3 0 0 0 0
    [3] 20:20:52 [SUCCESS] es2.vm
    1384309218 18:20:18 foo green 3 3 3 3 0 0 0 0

不太明显的用途是随着时间的推移追踪大型集群的恢复。 有足够的分片，启动集群，甚至在丢失节点后恢复，可能需要时间（取决于您的网络和磁盘）。 跟踪其进度的方法是在添加了延迟所循环中使用此命令：

    % while true; do curl localhost:9200/_cat/health; sleep 120; done
    1384309446 18:24:06 foo red 3 3 20 20 0 0 1812 0
    1384309566 18:26:06 foo yellow 3 3 950 916 0 12 870 0
    1384309686 18:28:06 foo yellow 3 3 1328 916 0 12 492 0
    1384309806 18:30:06 foo green 3 3 1832 916 4 0 0
    ^C

在这种情况下，我们可以看出恢复需要大约四分钟的时间。 如果这种情况持续了好几个小时，我们就能看到“UNASSIGNED”的分片急剧下降。 如果这个数字长时间保持不变，我们会认为这是一个未解决的问题。

### 为什么是时间戳?

当群集发生故障时，您通常使用`health`命令。 在此期间，关联日志文件，警报系统等的活动非常重要。

有两个输出。 `HH：MM：SS`输出只是为了人类理解。 时间戳保留了更多的信息，包含详细时间，如果你的恢复时间跨越了几天，还可以使用机器进行排序。
