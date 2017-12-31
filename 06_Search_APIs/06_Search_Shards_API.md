## 查询分片API Search Shards API

搜索分片api返回搜索请求将执行的索引和分片。 这可以提供有用的反馈，用于解决问题或使用路由和碎片首选项进行规划优化。 当使用过滤别名时，过滤器作为5.1.0版本中新增的`indices`内容[5.1.0]版本的一部分返回。。


`index`和`type`参数可以是单个值，也可以逗号分隔的多个值。

`type`参数已被弃用[5.1.0]在5.1.0中不推荐使用。 在以前的版本中被忽略。

### 用法 Usage

完整的例子:
    
    
    GET /twitter/_search_shards

这将产生以下结果：    
    
    {
      "nodes": ...,
      "indices" : {
        "twitter": { }
      },
      "shards": [
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 0,
            "state": "STARTED",
            "allocation_id": {"id":"0TvkCyF7TAmM1wHP4a42-A"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 1,
            "state": "STARTED",
            "allocation_id": {"id":"fMju3hd1QHWmWrIgFnI4Ww"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 2,
            "state": "STARTED",
            "allocation_id": {"id":"Nwl0wbMBTHCWjEEbGYGapg"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 3,
            "state": "STARTED",
            "allocation_id": {"id":"bU_KLGJISbW0RejwnwDPKw"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 4,
            "state": "STARTED",
            "allocation_id": {"id":"DMs7_giNSwmdqVukF7UydA"},
            "relocating_node": null
          }
        ]
      ]
    }

然后指定相同的请求，这次使用路由值：    
    
    GET /twitter/_search_shards?routing=foo,baz

这将产生以下结果：    
    
    {
      "nodes": ...,
      "indices" : {
          "twitter": { }
      },
      "shards": [
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 0,
            "state": "STARTED",
            "allocation_id": {"id":"0TvkCyF7TAmM1wHP4a42-A"},
            "relocating_node": null
          }
        ],
        [
          {
            "index": "twitter",
            "node": "JklnKbD7Tyqi9TP3_Q_tBg",
            "primary": true,
            "shard": 1,
            "state": "STARTED",
            "allocation_id": {"id":"fMju3hd1QHWmWrIgFnI4Ww"},
            "relocating_node": null
          }
        ]
      ]
    }

这次搜索将仅针对两个碎片执行，因为已经指定了路由值。
### 所有参数：

`routing`| 在确定要执行哪个分片时，需要考虑路由值的逗号分隔列表。    
---|---    
`preference`| 控制哪个分片复制品执行搜索请求的“首选项”。 默认情况下，操作在碎片副本之间是随机的。 请参阅[首选项]](search-request-preference.html)文档以获取所有可接受值的列表。
`local`| 一个布尔值，是否在本地读取群集状态以确定分配哪个碎片而不是使用主节点的群集状态。