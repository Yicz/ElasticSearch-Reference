##  查看主节点信息 cat master

`master`没有任何额外的选项。 它只显示主节点的ID，绑定的IP地址和节点名称。 例如：    
    
    GET /_cat/master?v

响应:
    
    
    id                     host      ip        node
    YzWoH_2BT-6UjVGDyPdqYg 127.0.0.1 127.0.0.1 YzWoH_2

这个信息也可以通过`nodes`命令得到，但是当你想要做的时候，这个信息会稍微缩短一点，例如，验证所有节点在主机上是一致的：
    
    % pssh -i -h list.of.cluster.hosts curl -s localhost:9200/_cat/master
    [1] 19:16:37 [SUCCESS] es3.vm
    Ntgn2DcuTjGuXlhKDUD4vA 192.168.56.30 H5dfFeA
    [2] 19:16:37 [SUCCESS] es2.vm
    Ntgn2DcuTjGuXlhKDUD4vA 192.168.56.30 H5dfFeA
    [3] 19:16:37 [SUCCESS] es1.vm
    Ntgn2DcuTjGuXlhKDUD4vA 192.168.56.30 H5dfFeA
