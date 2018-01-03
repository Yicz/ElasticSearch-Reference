## 刷新内存 Flush

刷新API允许通过API刷新一个或多个索引。 通过刷新数据到索引存储并清除内部[事务日志]（index-modules-translog.html），索引的刷新过程基本上将内存从索引中释放。 默认情况下，Elasticsearch使用内存启发式，以便根据需要自动触发刷新操作，以清除内存。
    
    POST twitter/_flush

### 请求参数

刷新APi接如下的请求参数：

`wait_if_ongoing`|如果设置为“true”，则清除操作将被阻塞，如果另一个flush操作已经在运行，直到另一个清除操作正在执行。 默认是`false`，并且会导致在分片级别抛出一个异常。
---|---    
`force`| 即使不需要刷新，也应该强制刷新。 如果没有改变将被提交给索引。 即使没有未提交的更改，事务日志ID也应该递增，这很有用。 （这个设置可以被认为是内部的）
  
### 多索引操作 Multi Index

刷新APIAPI可以在一次请求中设置多个索引或者全部(`_all`)索引 
    
    POST kimchy,elasticsearch/_flush
    
    POST _flush
