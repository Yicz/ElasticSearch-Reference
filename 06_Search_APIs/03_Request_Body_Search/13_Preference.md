## 首选项 Preference

控制执行搜索的哪个分片副本的`首选项`。 默认情况下，操作在可用分片副本中随机化。
Controls a `preference` of which shard copies on which to execute the search. By default, the operation is randomized among the available shard copies.

`preference`是一个查询字符串参数，可以设置为：

`_primary`| 操作只会在主分片上执行。
---|---    
`_primary_first`| 该操作将在主分片上执行，如果不可用（故障转移），将在其他分片上执行。    
`_replica`| 该操作将仅在副本分片上执行并执行。     
`_replica_first`| 该操作将仅在副本分片上执行，如果不可用（故障转移），将在其他分片上执行。     
`_local`| 如果可能，该操作将优选在本地分配的分片上执行。    
`_prefer_nodes:abc,xyz`| 如果适用，则优先在节点上执行节点ID（在这种情况下为`abc`或`xyz`）。
`_shards:2,3`|限制操作指定的分片。 （在这种情况下为“2”和“3”）。 此首选项可以与其他首选项相结合，但必须首先显示：`_shards：2,3 | _primary`
`_only_nodes`| 将操作限制在[节点规范 node specification](cluster.html)中指定的节点上
自定义（字符串）值| 自定义值将用于保证相同的自定义值将使用相同的分片。 当在不同的刷新状态下点击不同的分片时，这可以帮助“跳跃值”。 示例值可以是Web会话标识或用户名。
  
例如，使用用户的会话ID来确保用户的结果排序一致：    
    
    GET /_search?preference=xyzabc123
    {
        "query": {
            "match": {
                "title": "elasticsearch"
            }
        }
    }
