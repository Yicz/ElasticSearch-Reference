## 查看段信息 cat segments

`segments`命令提供有关索引分片中的分段的低级别信息。它提供的信息类似 [\_segments](indices-segments.html) 接口. 列出:
    
    
    GET /_cat/segments?v

响应如下:
    
    
    index shard prirep ip        segment generation docs.count docs.deleted size size.memory committed searchable version compound
    test  3     p      127.0.0.1 _0               0          1            0  3kb        2042 false     true       6.5.0   true
    test1 3     p      127.0.0.1 _0               0          1            0  3kb        2042 false     true       6.5.0   true

输出显示前两列中索引名称和分片号的信息。

If you only want to get information about segments in one particular index, you can add the index name in the URL, for example `/_cat/segments/test`. Also, several indexes can be queried like `/_cat/segments/test,test1`

以下各栏提供了其他监控信息：


`prirep` 

     该分段是属于主分片还是复制分片。 

`ip` 

     段的分片的IP地址。 

`segment` 

    段名称，从段生成派生。 该名称在内部用于在该分段所属的分片的目录中生成文件名。

`generation` 

     生产号码随着每一段被写入而递增。 段的名称来源于这一代数字。

`docs.count` 

    存储在此段中的未删除文档的数量。 请注意，这些是Lucene文档，因此计数将包含隐藏文档（例如嵌套类型）。

`docs.deleted` 

     存储在此段中的已删除文档的数量。 如果这个数字大于0，那么这个分段完全没问题，当这个分段被合并时，空间将被回收。 

`size` 

     此分段使用的磁盘空间量

`size.memory` 

     段将一些数据存储到内存中以便有效地搜索。 此列显示所使用的内存中的字节数。

`committed` 

     段是否已经在磁盘上同步。 提供了的段将在硬重启后生存。 如果发生错误，不需要担心，未提交段的数据也会存储在事务日志中，以便Elasticsearch能够在下次启动时重播更改。

`searchable` 

    如果段可以搜索，则为真。 false的值很可能意味着该段已写入磁盘，但自此之后不再刷新以使其可搜索。 

`version` 

     已经被用来编写这个段的Lucene的版本。

`compound` 

     段是否存储在复合文件中。 如果为true，这意味着Lucene将合并段中的所有文件，以保存文件描述符。