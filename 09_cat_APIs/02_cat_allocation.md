## 查看分配 cat allocation

`allocation` provides a snapshot of how many shards are allocated to each data node and how much disk space they are using.
    
    
    GET /_cat/allocation?v

Might respond with:
    
    
    shards disk.indices disk.used disk.avail disk.total disk.percent host      ip        node
         5         260b    47.3gb     43.4gb    100.7gb           46 127.0.0.1 127.0.0.1 CSUXak2

Here we can see that each node has been allocated a single shard and that they’re all using about the same amount of space.
