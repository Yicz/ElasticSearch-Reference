# 集群 _Cluster_ APIs

## Node specification

大部分的集群级别的APIs都允许指定一个节点进行执行操作（如，查询一个节点的状态），节点（node）使用内部的（节点id）Node id，（节点名称）node name,(地址)address ，（自定义属性）custom attributes在APIs中标识他们的身份,或者只是`_local`标识本地的节点。 例如，下面是一些节点info的示例执行：    
    
    # Local
    GET /_nodes/_local
    # Address
    GET /_nodes/10.0.0.3,10.0.0.4
    GET /_nodes/10.0.0.*
    # Names
    GET /_nodes/node_name_goes_here
    GET /_nodes/node_name_goes_*
    # Attributes (set something like node.attr.rack: 2 in the config)
    GET /_nodes/rack:2
    GET /_nodes/ra*:2
    GET /_nodes/ra*:2*
