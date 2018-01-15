## 索引段 Indices Segments

提供了lucene底层内置的分片级分段的信息。允许提供一个索引和分片的状态信息，可能包含优化信息和删除的文档在段中占用的存在大小等等。

接口可以指定一个索引，多个索引或全部索引：
    
    curl -XGET 'http://localhost:9200/test/_segments'
    curl -XGET 'http://localhost:9200/test1,test2/_segments'
    curl -XGET 'http://localhost:9200/_segments'

响应如下：
    
    {
        ...
            "_3": {
                "generation": 3,
                "num_docs": 1121,
                "deleted_docs": 53,
                "size_in_bytes": 228288,
                "memory_in_bytes": 3211,
                "committed": true,
                "search": true,
                "version": "4.6",
                "compound": true
            }
        ...
    }

`\_0`

     JSON文档的关键是段的名称。 该名称用于生成文件名：该分片的目录中以该分段名称开头的所有文件都属于该分段。

生成器（generation）
 

    在需要编写新段时基本上增加了一个数。 段名称来源于这一代号码。

文档数（num_docs） 

    存储在此段中的未被标记删除文档的数量。

删除的文档数（deleted_docs） 

     存储在此段中的已删除文档的数量。 如果这个数字大于0，那么这个分段完全没问题，当这个分段被合并时，空间将被回收。

节点大小（size_in_bytes） 

     此段使用的磁盘空间量（以字节为单位）。

内存占用大小（memory_in_bytes） 

     段需要将一些数据存储到内存中以便有效地进行搜索。 这个数字返回用于这个目的的字节数。 值为-1表示Elasticsearch无法计算此数字。

已提交（committed） 

     段是否已经在磁盘上同步。 承诺的细分将在硬重启后生存。 如果发生错误，不需要担心，未提交段的数据也会存储在事务日志中，以便Elasticsearch能够在下次启动时重播更改。

可查询（search） 

    分段是否可搜索。 false的值很可能意味着该段已写入磁盘，但自此之后不再刷新以使其可搜索。

版本号 （version） 

    已经被用来编写这个段的Lucene的版本。

合成（compound） 

    段是否存储在复合文件中。 如果为true，这意味着Lucene将合并段中的所有文件，以保存文件描述符。

### 可视模式 Verbose mode

要添加可用于调试的其他信息，请使用`verbose`参数

![Warning](/images/icons/warning.png)
使用如下请求的数据，会随时可变
    
    curl -XGET 'http://localhost:9200/test/_segments?verbose=true'

响应如下：
    
    
    {
        ...
            "_3": {
                ...
                "ram_tree": [
                    {
                        "description": "postings [PerFieldPostings(format=1)]",
                        "size_in_bytes": 2696,
                        "children": [
                            {
                                "description": "format 'Lucene50_0' ...",
                                "size_in_bytes": 2608,
                                "children" :[ ... ]
                            },
                            ...
                        ]
                    },
                    ...
                    ]
    
            }
        ...
    }
