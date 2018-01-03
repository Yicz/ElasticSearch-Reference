## 查看快照 cat snapshots

`snapshots`命令显示属于特定存储库的所有快照。 要查找可用存储库列表以查询，可以使用命令`/_cat/repositories`。 查询名为`repo1`的存储库的快照如下所示。
    
    % curl 'localhost:9200/_cat/snapshots/repo1?v'
    id     status start_epoch start_time end_epoch  end_time duration indices successful_shards failed_shards total_shards
    snap1  FAILED 1445616705  18:11:45   1445616978 18:16:18     4.6m       1                 4             1            5
    snap2 SUCCESS 1445634298  23:04:58   1445634672 23:11:12     6.2m       2                10             0           10

每个快照都包含有关何时启动和停止的信息。 开始和停止时间戳有两种格式。 `HH：MM：SS`输出只是为了快速消费。 `end_epoch`保留更多信息，包括日期，如果快照过程跨越数天，则可以通过机器排序。
