## 打开/关闭索引API Open / Close Index API

打开/关闭索引API允许关闭一个索引，然后进行打开它，一个关闭状态的索引在集群上几乎没有任何开销（除了维护其元数据），并且对于读/写操作而言被阻塞。 关闭的索引可以打开，然后通过正常的恢复过程。


REST API接口是 `/{index}/_close` 和 `/{index}/_open`. 例如：
    
    
    POST /my_index/_close
    
    POST /my_index/_open

允许对多个索引进行打开和关闭的操作，如果没有明确地指定一个索引，操作会返回一个错误。可以通过设置`ignore_unavailable=true`来忽略这个错误。

可以使用`_all`或`*`来表示全部的索引。

可以通过设置`action.destructive_requires_name=true`来禁用通配符和`_all`的使用。这个设置同样会响应更新索引API操作。

封闭式索引消耗大量的磁盘空间，这可能会在托管环境中导致问题。 通过将cluster.indices.close.enable设置为false，可以通过集群设置API禁用关闭索引。 默认是`true`。

关闭状态的索引会占用大量的磁盘空间，这可以会导致管理环境中的管理问题，可以通过`cluster.indices.close.enable=false`来设置禁用关闭索引操作。

