## 查看恢复 cat recovery

 `recovery` 命令是查看索引分片恢复情况的一个视图，包含正在执行和已经完成的。是一个比[recovery](indices-recovery.html) API接口更加复杂的接口。

索引分片移动到集群中的其他节点时，会发生恢复事件。 这可能发生在快照恢复，复制级别更改，节点故障或节点启动过程中。 最后一种类型称为本地存储恢复，是节点启动时从磁盘加载分片的常用方式。


作为一个例子，下面是当从一个节点到另一个节点不存在分片时，集群恢复状态的样子：
    
    
    GET _cat/recovery?v

这个请求的回应是这样的：    
    
    index   shard time type  stage source_host source_node target_host target_node repository snapshot files files_recovered files_percent files_total bytes bytes_recovered bytes_percent bytes_total translog_ops translog_ops_recovered translog_ops_percent
    twitter 0     13ms store done  n/a         n/a         node0       node-0      n/a        n/a      0     0               100%          13          0     0               100%          9928        0            0                      100.0%

在上述情况下，源节点和目标节点是相同的，因为恢复类型是存储的，即它们是从节点开始时从本地存储读取的。

现在让我们看看现场恢复的样子。 通过增加我们的索引的副本计数，并使另一个节点联机来托管副本，我们可以看到实时分片恢复的样子。
    
    
    GET _cat/recovery?v&h=i,s,t,ty,st,shost,thost,f,fp,b,bp

这将返回一个如下所示的内容：    
    
    i       s t      ty   st    shost       thost       f     fp      b bp
    twitter 0 1252ms peer done  192.168.1.1 192.168.1.2 0     100.0%  0 100.0%

我们可以在上面的列表中看到，我们的Twitter twitter是从另一个节点恢复的。 请注意，恢复类型显示为“peer”。 所复制的文件和字节是实时测量结果。

最后，让我们看看快照恢复的样子。 假设我以前做过索引的备份，我可以使用[snapshot and restore](modules-snapshots.html)API来恢复它。
    
    GET _cat/recovery?v&h=i,s,t,ty,st,rep,snap,f,fp,b,bp

这将在响应中显示类型快照的恢复:    
    
    i       s t      ty       st    rep     snap   f  fp   b     bp
    twitter 0 1978ms snapshot done  twitter snap_1 79 8.0% 12086 9.0%
