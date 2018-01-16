## 群集健康 Cluster Health

群集健康API可以获得群集健康的非常简单的状态。 例如，在具有5个分片和一个副本的单个索引的安静单节点群集上，这样做：
    
    
    GET _cluster/health

响应内容:
    
    
    {
      "cluster_name" : "testcluster",
      "status" : "yellow",
      "timed_out" : false,
      "number_of_nodes" : 1,
      "number_of_data_nodes" : 1,
      "active_primary_shards" : 5,
      "active_shards" : 5,
      "relocating_shards" : 0,
      "initializing_shards" : 0,
      "unassigned_shards" : 5,
      "delayed_unassigned_shards": 0,
      "number_of_pending_tasks" : 0,
      "number_of_in_flight_fetch": 0,
      "task_max_waiting_in_queue_millis": 0,
      "active_shards_percent_as_number": 50.0
    }

The API can also be executed against one or more indices to get just the specified indices health:
    
    GET /_cluster/health/test1,test2

群集健康状态是：`green`, `yellow` 和 `red`。 在分片级别上，`red`状态表示特定分片未在簇中分配，`yellow`表示分配了主分片，但副本不分配，`green`表示分配了所有分片。 索引级别状态由最差的分片状态控制。 群集状态由最差的索引状态控制。

该API的主要优点之一是能够等待群集达到一定的高水位健康级别。 例如，以下内容将等待50秒，以达到`yellow`级别（如果在50秒之前达到`green`或`yellow`状态，则会在该点返回）：

    GET /_cluster/health?wait_for_status=yellow&timeout=50s

### 请求参数 Request Parameters

群集健康API接受以下请求参数：

`level`
    
    值内容可以是`cluster`, `indices` 或`shards`其中一个，控制着不同级别的健康信息的返回，默认是`cluster`级别

`wait_for_status`

    值内容可以是`green`, `yellow` 或 `red`。等待达到提供的状态才返回内容，如果提供了超时参数，当到达超时设置之后也会返回。默认不设置

`wait_for_no_relocating_shards`

     一个布尔值，用于控制是否等待（直到提供超时），以使群集不具有分片重定位。 默认为false，这意味着它不会等待重定位碎片。
     
`wait_for_active_shards`

    一个数字，用于控制要激活的分片的数量，等待集群中所有分片激活的“全部”，或者不等待。 默认为“0”。

`wait_for_nodes`

    请求等待，直到指定的节点数量“N”可用。 它也接受`>= N`，`<=N`，`>N`和`<N`。 或者，可以使用`ge（N）`，`le（N）`，`gt（N）`和`lt（N）`表示法。

`timeout`

    一个基于时间的参数，控制如果提供了wait_for_XXX之一等待的时间。 默认为`30s`。

`local`

    如果`true`返回本地节点信息，并且不提供来自主节点的状态。 默认：“false”。

以下是在“分片”级别获取集群运行状况的示例：
    
    
    GET /_cluster/health/twitter?level=shards
