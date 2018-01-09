## 索引恢复 Indices Recovery

索引恢复API提供了对正在进行的索引分片恢复的深入了解。 恢复状态可能会针对特定索引或集群范围进行报告。

例如，以下命令将显示索引`index1`和`index`的恢复信息。    
    
    GET index1,index2/_recovery?human

要查看群集范围的恢复状态，只需省略索引名称即可。    
    
    GET /_recovery?human

响应如下：
    
    
    {
      "index1" : {
        "shards" : [ {
          "id" : 0,
          "type" : "SNAPSHOT",
          "stage" : "INDEX",
          "primary" : true,
          "start_time" : "2014-02-24T12:15:59.716",
          "start_time_in_millis": 1393244159716,
          "total_time" : "2.9m",
          "total_time_in_millis" : 175576,
          "source" : {
            "repository" : "my_repository",
            "snapshot" : "my_snapshot",
            "index" : "index1"
          },
          "target" : {
            "id" : "ryqJ5lO5S4-lSFbGntkEkg",
            "hostname" : "my.fqdn",
            "ip" : "10.0.1.7",
            "name" : "my_es_node"
          },
          "index" : {
            "size" : {
              "total" : "75.4mb",
              "total_in_bytes" : 79063092,
              "reused" : "0b",
              "reused_in_bytes" : 0,
              "recovered" : "65.7mb",
              "recovered_in_bytes" : 68891939,
              "percent" : "87.1%"
            },
            "files" : {
              "total" : 73,
              "reused" : 0,
              "recovered" : 69,
              "percent" : "94.5%"
            },
            "total_time" : "0s",
            "total_time_in_millis" : 0
          },
          "translog" : {
            "recovered" : 0,
            "total" : 0,
            "percent" : "100.0%",
            "total_on_start" : 0,
            "total_time" : "0s",
            "total_time_in_millis" : 0,
          },
          "start" : {
            "check_index_time" : "0s",
            "check_index_time_in_millis" : 0,
            "total_time" : "0s",
            "total_time_in_millis" : 0
          }
        } ]
      }
    }

上面的响应显示了单个索引恢复单个分片。 在这种情况下，恢复的来源是快照库，恢复的目标是名为`my_es_node`的节点。

此外，输出显示恢复的文件数量和百分比，以及恢复的字节数和百分比。

在某些情况下，更高层次的细节可能更可取。 设置`detailed = true`将显示恢复中的物理文件列表。
      
    GET _recovery?human&detailed=true

响应如下：
    
    
    {
      "index1" : {
        "shards" : [ {
          "id" : 0,
          "type" : "STORE",
          "stage" : "DONE",
          "primary" : true,
          "start_time" : "2014-02-24T12:38:06.349",
          "start_time_in_millis" : "1393245486349",
          "stop_time" : "2014-02-24T12:38:08.464",
          "stop_time_in_millis" : "1393245488464",
          "total_time" : "2.1s",
          "total_time_in_millis" : 2115,
          "source" : {
            "id" : "RGMdRc-yQWWKIBM4DGvwqQ",
            "hostname" : "my.fqdn",
            "ip" : "10.0.1.7",
            "name" : "my_es_node"
          },
          "target" : {
            "id" : "RGMdRc-yQWWKIBM4DGvwqQ",
            "hostname" : "my.fqdn",
            "ip" : "10.0.1.7",
            "name" : "my_es_node"
          },
          "index" : {
            "size" : {
              "total" : "24.7mb",
              "total_in_bytes" : 26001617,
              "reused" : "24.7mb",
              "reused_in_bytes" : 26001617,
              "recovered" : "0b",
              "recovered_in_bytes" : 0,
              "percent" : "100.0%"
            },
            "files" : {
              "total" : 26,
              "reused" : 26,
              "recovered" : 0,
              "percent" : "100.0%",
              "details" : [ {
                "name" : "segments.gen",
                "length" : 20,
                "recovered" : 20
              }, {
                "name" : "_0.cfs",
                "length" : 135306,
                "recovered" : 135306
              }, {
                "name" : "segments_2",
                "length" : 251,
                "recovered" : 251
              },
               ...
              ]
            },
            "total_time" : "2ms",
            "total_time_in_millis" : 2
          },
          "translog" : {
            "recovered" : 71,
            "total_time" : "2.0s",
            "total_time_in_millis" : 2025
          },
          "start" : {
            "check_index_time" : 0,
            "total_time" : "88ms",
            "total_time_in_millis" : 88
          }
        } ]
      }
    }

该响应显示了恢复的实际文件及其大小的详细列表(进行了精减)。

还显示了恢复的各个阶段的时间（毫秒）：索引检索，超时重播和索引开始时间。

请注意，上面的清单表明恢复处于`DONE`阶段。 所有恢复，无论是正在进行还是完成，都保持集群状态，并可能随时进行报告。 设置`active_only = true`将导致仅报告正在进行的恢复。

这是一个完整的选项列表：


`detailed`| 显示详细的视图。 这主要用于查看物理索引文件的恢复。 默认：false。     
---|---    
`active_only`| 只显示目前正在进行的恢复。 默认：false。     


输出内容的描述

字段:

`id`| 分片id     
---|---    
`type`| 恢复类型   <br> store   <br> snapshot   <br> replica   <br> relocating     
`stage`| 恢复状态:   <br> init: 未开始   <br> index: Reading index meta-data and copying bytes from source to destination   <br> start: Starting the engine; opening the index for use   <br> translog: Replaying transaction log   <br> finalize: Cleanup   <br> done: Complete     
`primary`| 是否主分片    
`start_time`| 开始时间     
`stop_time`| 结束时间     
`total_time_in_millis`| 总恢复时间     
`source`| 恢复来源:   * repository description if recovery is from a snapshot   * description of source node otherwise     
`target`| 目标结节   
`index`| Statistics about physical index recovery     
`translog`| Statistics about translog recovery     
`start`| Statistics about time to open and start the index 