## 索引统计信息 Indices Stats

索引级别的数据统计展示了在一个索引上不同数据操作的数据统计信息。API的提供的数据建立在索引级别范围（虽然大部分数据也可以说在节点级别上进行检索）


以下返回所有索引的高级聚合和索引级别统计信息：    
    
    GET /_stats

可以指定索引进行检索：    
    
    GET /index1,index2/_stats

默认地，所有的统计信息会被返回，但可以在URI上进行指定特殊的统计数据进行返回。可以设置的统计信息如下：

`docs`|文档总数（包含只标志删除状态的索引），提示，刷新操作会影响这个结果
---|---    
`store`|索引的大小    
`indexing`| 索引统计信息可以与`类型`的逗号分隔列表组合，以提供文档类型级别统计信息。   
`get`| 获取统计信息，包括未查询命中的统计信息    
`search`| 搜索统计包括建议统计。 您可以通过添加额外的`group`参数来包含自定义组的统计信息（搜索操作可以与一个或多个组相关联）。 `groups`参数接受逗号分隔的组名列表。 使用`_all`来返回所有组的统计信息。 
`segments`| 检索打开段的内存使用情况。 可选地，设置`include_segment_file_sizes`标志，报告每个Lucene索引文件的聚集磁盘使用情况。
`completion`| 建议统计分析.     
`fielddata`| 字段数据统计分析.     
`flush`| 刷新统计数据.     
`merge`| 合并统计数据.     
`request_cache`| [Shard request cache](shard-request-cache.html) statistics.     
`refresh`| 刷新统计数据.     
`warmer`| Warmer statistics.     
`translog`| 传输日志的数据分析     

一些统计数据允许每个字段的粒度，它接受一个包含字段列表的逗号分隔列表。 默认情况下所有字段都包含在内

`fields`| 统计中包含的字段列表。 这被用作默认列表，除非提供更具体的字段列表（见下文）。     
---|---    
`completion_fields`| 完成建议统计中包含的字段列表。   
`fielddata_fields`| 要包含在Fielddata统计信息中的字段列表。
  
这里有些例子:
    
    # Get back stats for merge and refresh only for all indices
    GET /_stats/merge,refresh
    # Get back stats for type1 and type2 documents for the my_index index
    GET /my_index/_stats/indexing?types=type1,type2
    # Get back just search stats for group1 and group2
    GET /_stats/search?groups=group1,group2

返回的统计数据汇总在索引级别上，具有`primaries`和`total`聚合，其中`primaries`是仅用于主分片的值，`total`是主分片和副本分片的累积值。

为了取回分片级别统计信息，将`level`参数设置为`shards`。

请注意，随着分片在集群中移动，它们的统计信息将被清除，因为它们是在其他节点上创建的。 另一方面，即使分片**离开**一个节点，该节点仍将保留分片贡献的统计数据。
