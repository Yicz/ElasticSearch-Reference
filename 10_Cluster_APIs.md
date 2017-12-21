# 集群 _Cluster_ APIs

## Node specification

Most cluster level APIs allow to specify which nodes to execute on (for example, getting the node stats for a node). Nodes can be identified in the APIs either using their internal node id, the node name, address, custom attributes, or just the `_local` node receiving the request. For example, here are some sample executions of nodes info:
    
    
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
