## 影子副本索引 Shadow replica indices

![Warning](/images/icons/warning.png)

### 该功能已于5.2.0版本中弃用. 

影子副本作用看起来并没有那么大，计划将来的版本中进行删除。


如果您想使用共享文件系统，则可以使用阴影副本设置来选择保留索引数据的磁盘位置，以及Elasticsearch应如何在索引的所有副本碎片上重放操作。


为了充分利用`index.data_path`和`index.shadow_replicas`设置，您需要通过在elasticsearch.yml中将`node.add_lock_id_to_custom_path`设置为false来允许Elasticsearch为多个实例使用相同的数据目录：
    
    node.add_lock_id_to_custom_path: false

您还需要向安全管理员指明自定义索引的位置，以便可以应用正确的权限。 你可以通过在elasticsearch.yml中设置`path.shared_data`设置来实现：
    
    path.shared_data: /opt/data

这意味着Elasticsearch可以读取和写入`path.shared_data`设置的任何子目录中的文件。

然后，您可以使用自定义数据路径创建一个索引，其中每个节点将为此数据使用此路径：

![Warning](/images/icons/warning.png)

由于影子副本不会对副本分片上的文档编制索引，因此如果尚未在包含副本的节点上处理最新的集群状态，则副本的已知映射可能位于索引的已知映射之后。 因此，强烈建议使用影子副本时使用预定义的映射。

    PUT /my_index
    {
        "index" : {
            "number_of_shards" : 1,
            "number_of_replicas" : 4,
            "data_path": "/opt/data/my_index",
            "shadow_replicas": true
        }
    }

![Warning](/images/icons/warning.png)

在上面的示例中，`/opt/data/my_index`路径是Elasticsearch群集中每个节点上必须可用的共享文件系统。 您还必须确保Elasticsearch进程具有正确的权限来读取和写入`index.data_path`设置中使用的目录。

`data_path`不一定要包含索引名称，在这种情况下，使用了`my_index`，但它也可以很容易地在`/opt/data/`进行创建。

已经使用`index.shadow_replicas`设置创建的索引，可以使用常规刷新（由`index.refresh_interval`控制）来使新数据可搜索。

![Note](/images/icons/note.png)

由于文档只在主分片上索引，因此如果在副本分片上执行，实时GET请求可能无法返回文档，因此，如果没有设置优先标记，GET API请求会自动设置`?preference=_primary`参数。

为了确保数据以足够快的速度同步，您可能需要将索引的刷新阈值调整为所需的数字。 同步段文件需要刷新到磁盘，所以他们将是所有其他副本节点可见。 用户应该测试他们适合的刷新阈值等级，因为缩短刷新时间会影响索引性能。

Elasticsearch集群仍然会检测到主分片的丢失，并在此情况下将副本转换为主分区。 这个转换将花费更长时间，因为没有为每个影子副本维护`IndexWriter`。

以下是使用更新设置API（update setttings）可以更改的设置列表：


**`index.data_path`** 
     
     用于索引数据的路径。 请注意，默认情况下，Elasticsearch会默认将节点序号附加到路径中，以确保同一机器上的多个Elasticsearch实例不共享数据目录。

**`index.shadow_replicas`**

    指定此索引的布尔值应使用影子副本。 默认为`false`。
**`index.shared_filesystem`**

    指定此索引的布尔值使用共享文件系统。 如果将`index.shadow_replicas=true`，则默认为`true`，否则为`false`。
**`index.shared_filesystem.recover_on_any_node`**

    布尔值，指定是否允许在集群中的任何节点上恢复索引的主分片。 如果找到一个拥有分片副本的节点，恢复首选该节点。 默认为`false`。
