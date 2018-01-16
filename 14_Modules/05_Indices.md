## 索引 Indices

索引模块控制着索引相关的设置并全局管理全部索引。相当于索引级别上的设置。

可用的设置包含：

[Circuit breaker](circuit-breaker.html)

     断路器限制了内存的使用以避免内存溢出。
[Fielddata cache](modules-fielddata.html)

     设置内存中字段数据高速缓存使用的堆的限制。
[Node query cache](query-cache.html)

     配置用于缓存查询结果的堆量。 
[Indexing buffer](indexing-buffer.html)

    控制分配给索引进程的缓冲区的大小。 
[Shard request cache](shard-request-cache.html)

     控制分片级请求缓存的行为。
[Recovery](recovery.html)

     控制分片恢复过程的资源限制。 
