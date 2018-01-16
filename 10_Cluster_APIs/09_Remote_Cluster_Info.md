## 远程集群信息 Remote Cluster Info

集群远程信息API允许检索所有已配置的远程集群信息。
    
    
    GET /_remote/info

此命令返回由配置的远程群集别名键入的连接和端点信息。


`seeds`

     配置的远程集群的初始种子传输地址。 

`http_addresses`

     已发布的所有连接的远程节点的http地址。

`connected`

     如果至少有一个到远程群集的连接，则为真。

`num_nodes_connected`

     远程集群中连接的节点数。 

`max_connection_per_cluster`

     为远程集群维护的最大连接数。

`initial_connect_timeout`

     远程群集连接的初始连接超时。
