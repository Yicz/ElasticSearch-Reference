##  索引缓冲大小

索引缓冲区用于存储新索引的文档。 当它填满时，缓冲区中的文档被写入磁盘上的一个段。 它在节点上的所有分片之间是相互隔离的。

以下设置是_静态_，并且必须在集群中的每个数据节点上进行配置：

`indices.memory.index_buffer_size`

     接受百分比或字节大小值。 它默认为`10％`，这意味着分配给节点的总堆的10％将被用作在所有分片之间共享的索引缓冲区大小。
`indices.memory.min_index_buffer_size`

     如果将`index_buffer_size`指定为百分比，则可以使用此设置指定绝对最小值。 默认为`48mb`。
`indices.memory.max_index_buffer_size`

     如果`index_buffer_size`被指定为百分比，那么这个设置可以用来指定一个绝对最大值。 默认为无界。
