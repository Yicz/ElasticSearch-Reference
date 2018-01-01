## 收缩索引 Shrink Index

收缩索引允许对已经存在的索引进行变更它的主分片数据到一个新的索引中。目标索引中所请求的主分片数量必须是源索引中分片数量的一个因子。 例如，可以将具有`8`主分片的索引收缩为`4`，`2`或`1`主分片或者具有`15`主分片的索引可以收缩为`5`，`3`或`1`。如果索引中的碎片数量是素数，则只能将其缩小为(1)单个主碎片。在收缩之前，索引中每个分片的（主要或副本）副本必须出现在同一个节点上。

收缩操作，做了如下的内容：

   * 首先，它创建一个新的目标索引，其定义与源索引相同，但主碎片数量较少。
   * 然后将源索引中的段硬连接到目标索引。 （如果文件系统不支持硬连接，那么所有的段都被复制到新的索引中，这是一个更耗时的过程。）
   最后，它恢复了目标索引，好像它是一个刚刚重新开放的关闭状态的索引。



### 收缩一个索引的准备工作 Preparing an index for shrinking

为了缩小索引，必须将索引标记为只读，并且必须将索引中每个分片的（主要或副本）副本重定位到同一个节点，并且具有[health](cluster-health.html)状态为`green`。

这两个条件可以通过以下要求来实现：    
    
    PUT /my_source_index/_settings
    {
      "settings": {
        "index.routing.allocation.require._name": "shrink_node_name", <1>
        "index.blocks.write": true <2>
      }
    }

<1>| 强制将每个分片的副本重定位到名称为`shrink_node_name`的节点。 请参阅[Shard Allocation Filtering](shard-allocation-filtering.html)以获取更多内容。     
---|---    
<2>| 防止对此索引执行写操作，同时允许更改元数据（如删除索引）。 
  
重分配索引的过程是一个比较耗时的过程，可以通过[`_cat recovery` API](cat-recovery.html)追踪处理过程,或 [`cluster health` API](cluster-health.html)使用`wait_for_no_relocating_shards`参数来查看是否分配完成。

### 收缩一个索引 Shrinking an index

要将`my_source_index`缩小到一个名为`my_target_index`的新索引，请发出以下请求：    
    
    POST my_source_index/_shrink/my_target_index

一旦目标索引添加到集群状态，上述请求立即返回 - 它不会等待收缩操作启动。

![Important](/images/icons/important.png)

索引只能满足以下要求才能收缩：
  * 目标索引必须存在 
  * 源索引的分片数必须比目标索引的结构存在
  * 目标索引中的主要碎片数量必须是源索引中主要碎片数量的一个因子。 源索引必须具有比目标索引更多的主分片。
  * 该索引在所有分片中总共不能包含超过`2,147,483,519个`文档，这些文档将被缩减为目标索引中的一个分片，因为这是可以放入单个分片的文档的最大数量。
  * 处理收缩进程的节点必须有足够的可用磁盘空间来容纳现有索引的第二个副本。



`_shrink` API类似于[`create index` API](indices-create-index.html)，接受目标索引的`settings`和`aliases`参数：
    
    
    POST my_source_index/_shrink/my_target_index
    {
      "settings": {
        "index.number_of_replicas": 1,
        "index.number_of_shards": 1, <1>
        "index.codec": "best_compression" <2>
      },
      "aliases": {
        "my_search_indices": {}
      }
    }

<1>| 目标索引中的主分片数量。 这必须是源索引中的分片数量的一个因素。     
---|---    
<2>| 当对索引进行新的写入操作时，例如[force-merge](indices-forcemerge.html)将片段分割为单个片段时，最佳压缩只会起作用。  
  
![Note](/images/icons/note.png)

映射关系如果不会在`_shrink`请求中指定，所有`index.analysis.*`和`index.similarity.*`设置将被来自源索引的设置覆盖。


### 监控收缩过程 Monitoring the shrink process


可以使用[`_cat recovery API`](cat-recovery.html)或[`cluster health` API]（cluster-health.html）来监控收缩进程，以等待所有主分片 通过将`wait_for_status`参数设置为`yellow`来分配。

只要目标索引已经添加到集群状态，在分配任何分片之前，`_shrink` API就会返回。 此时，所有碎片都处于“未分配”状态。 如果出于任何原因，目标索引不能在收缩节点上分配，则其主分片将保持“未分配”状态，直到可以在该节点上分配为止。

一旦主分片被分配，它就进入“初始化”状态，收缩过程开始。 收缩操作完成后，分片将变为“活动”状态。 在这一点上，Elasticsearch将尝试分配任何副本，并可能决定将主分片重定位到另一个节点。

### 等待激活的分片 Wait For Active Shards

因为收缩操作会创建一个新的索引来收缩碎片，所以索引创建时的[等待活动碎片 `wait for active shards`](indices-create-index.html＃create-index-wait-for-active-shards)设置适用于收缩操作。
