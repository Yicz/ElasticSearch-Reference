# 索引模块 Index Modules

索引模块是为每个索引创建的模块，并控制与索引相关的所有内容。

## 索引设置

索引级别设置可以按照索引设置。 设置可能是：

_静态 static_
     只能在索引创建时或在[关闭的索引]进行行设置(indices-open-close.html). 
_动态 dynamic_
     可以使用[update-index-settings](indices-update-settings.html)API在实时索引中更改

![Warning](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/warning.png)

更改关闭索引上的静态或动态索引设置可能会导致错误的设置，如果不删除并重新创建索引，这些设置将无法纠正。

### 静态索引设置 Static index settings

以下列出了与任何特定索引模块无关的所有_static_索引设置：

`index.number_of_shards`

     索引应该具有的主分片的数量。 默认为5.此设置只能在索引创建时设置。 它不能在关闭索引上更改。 注意：每个索引的分片数量限制为1024。 这个限制是为了防止由于资源分配而意外地创建可能使集群不稳定的索引的安全限制。 限制可以通过指定进行修改群集上的节点服务器属性`export ES_JAVA_OPTS="-Des.index.max_number_of_shards=128"`变更

`index.shard.check_on_startup`

    [实验性的] 当启动打开分片的时候，检查分片是否有损坏的，当是检测到损坏的时候，进行保护分片。参数设置为：

          `false`
               (默认) 打开之前不检查
          `checksum`
               只检查物理校验. 
          `true`
               检查物理和逻校验，会占用CPU和内存。
          `fix`
               检查物理和逻辑校验。 报告为损坏的分段将被自动删除。 此选项**可能导致数据丢失**。 谨慎使用！

在检测大的索引的时候，会花费大量时间。

`index.codec`
     
     'default'值用LZ4压缩压缩存储的数据，但是这可以设置为`best_compression`，它使用[DEFLATE]（https://en.wikipedia.org/wiki/DEFLATE）获得更高的压缩比率，代价是较慢的存储字段性能。

`index.routing_partition_size`

     自定义[routing](mapping-routing-field.html) 值可以转到的碎片数量。默认为1，只能在索引创建时设置。此值必须小于index.number_of_shards，除非index.number_of_shards值也为1.有关更多详细信息，请参阅[路由到索引分区](mapping-routing-field.html#routing-index-partition)。 关于如何使用这个设置。

### 动态索引设置 Dynamic index settings

以下是与任何特定索引模块无关的所有_dynamic_索引设置的列表：

`index.number_of_replicas`
     
     副本分片的数量，缺省是1. 

`index.auto_expand_replicas`
     
     根据可用节点的数量自动扩展副本的数量。设置为划定短划线的下限和上限（例如`0-5`）或使用`all`作为上限（例如`0-all`）。默认为“false”（即禁用）。

`index.refresh_interval`
    
     多久执行一次刷新操作，这会使最近对索引进行的更改可见，从而进行搜索。 默认为`1s`。 可以设置为`-1`来禁用刷新。

`index.max_result_window`

     用于搜索此索引的`from + size`的最大值。 默认为`10000`。 搜索请求占用堆内存，时间与`from + size`成正比，这就限制了内存。 请参阅[滚动 Scroll](search-request-scroll.html)或[Search After](search-request-search-after.html)以提高效率。

`index.max_rescore_window`
     
     搜索此索引时`rescore`请求的`window_size`的最大值。默认为`index.max_result_window`即`10000`。搜索请求占用堆内存，时间与`max（window_size，from + size）成正比`，这限制了内存。

`index.blocks.read_only`
     
     设置为“true”以使索引和索引元数据只读，“false”允许写入和元数据更改。

`index.blocks.read`
    
    设置为“true”以禁止对索引执行读取操作。

`index.blocks.write`
     
     设置为“true”以禁止对索引执行写入操作

`index.blocks.metadata`

     设置为“true”以禁止对索引执行写入和读取操作

`index.max_refresh_listeners`

     索引的每个分片上可用的刷新监听器的最大数量。 这些监听器是用来实现的[`refresh=wait_for`](docs-refresh.html). 

### 其他索引模块中的设置

其他索引设置在索引模块中可用：

[分词 Analysis](analysis.html)
    
     定义分析器，标记器，令牌过滤器和字符过滤器的设置。

[索引分片分配 Index shard allocation](index-modules-allocation.html)

     控制何处，何时以及如何将分片分配给节点。 

[映射关系 Mapping](index-modules-mapper.html)

    启用或禁用索引的动态映射。

[合并 Merging](index-modules-merge.html)

     控制后台合并过程如何合并分片。

[相关度 Similarities](index-modules-similarity.html)

     配置自定义相似性设置以自定义搜索结果得分的方式。

[日志显示 Slowlog](index-modules-slowlog.html)

     控制记录查询和提取请求的速度。

[存储 Store](index-modules-store.html)

     配置用于访问分片数据的文件系统的类型。

[事务日志 Translog](index-modules-translog.html)

     控制事务日志和后台刷新操作