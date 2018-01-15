## 索引分片存储信息 Indices Shard Stores

提供索引分片副本的存储信息。 存储关于哪些节点分片副本存在的信息报告，分片副本分配ID，每个分片副本的唯一标识符，以及在打开分片索引时遇到的任何异常或者早期的引擎故障。

默认情况下，只列出存储具有至少一个未分配副本的碎片的信息。 当群集运行状况为黄色时，将列出至少有一个未分配副本的碎片的存储信息。 当群集运行状况为红色时，将列出未分配初级的片段的存储信息。

接口可以指定一个、多个或全部的索引：

    curl -XGET 'http://localhost:9200/test/_shard_stores'
    curl -XGET 'http://localhost:9200/test1,test2/_shard_stores'
    curl -XGET 'http://localhost:9200/_shard_stores'

可以通过`status`参数来更改列表存储信息的分片范围。 默认为_yellow_和_red_。 _yellow_列表存储至少有一个未分配的副本的碎片信息，以及具有未分配的主分片的碎片的_red_。 使用_green_列出所有分配副本的分片存储信息。

    
    curl -XGET 'http://localhost:9200/_shard_stores?status=green'

响应如下：

分片存储信息按索引和分片ID进行分组。    
    
    {
        ...
       "0": { <1>
            "stores": [ <2>
                {
                    "sPa3OgxLSYGvQ4oPs-Tajw": { <3>
                        "name": "node_t0",
                        "transport_address": "local[1]",
                        "attributes": {
                            "mode": "local"
                        }
                    },
                    "allocation_id": "2iNySv_OQVePRX-yaRH_lQ", <4>
                    "legacy_version": 42, <5>
                    "allocation" : "primary" | "replica" | "unused", <6>
                    "store_exception": ... <7>
                },
                ...
            ]
       },
        ...
    }

<1>| 键值是存储信息对应的分片ID     
---|---    
<2>| 存储信息关于分片复制的列表
<3>| 托管存储副本的节点信息，键值是唯一节点标识。     
<4>| 分配存储信息拷贝信息  
<5>| The version of the store copy (available only for legacy shard copies that have not yet been active in a current version of Elasticsearch)    
<6>| The status of the store copy, whether it is used as a primary, replica or not used at all     
<7>| Any exception encountered while opening the shard index or from earlier engine failure 
