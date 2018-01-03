## 查看分配 cat allocation

`allocation`提供了一个分配给每个数据节点的分片数以及它们使用多少磁盘空间的快照。
    
    GET /_cat/allocation?v

响应内容:
    
    
    shards disk.indices disk.used disk.avail disk.total disk.percent host      ip        node
         5         260b    47.3gb     43.4gb    100.7gb           46 127.0.0.1 127.0.0.1 CSUXak2

在这里我们可以看到每个节点都被分配了一个分片，并且他们都使用了大致相同的空间。