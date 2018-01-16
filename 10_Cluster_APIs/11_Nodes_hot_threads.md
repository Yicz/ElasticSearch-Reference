## 节点热门线程 Nodes hot_threads

这个API允许获取当前集群每一个节点中的热门线程。接口为`/_nodes/hot_threads`或 `/_nodes/{nodesIds}/hot_threads`.


输出是普通文本，每个节点的顶级热线程详细内容。 允许使用的参数是：

`threads`| 热闹线程的数量，默认是3     
---|---    
`interval`| 执行第二次线程采样的时间间隔。 默认为500ms。  
`type`| 要采样的类型默认为cpu，但支持wait和block来查看处于等待或阻塞状态的热线程。    
`ignore_idle_threads`|如果为true，则已知的空闲线程（例如，在套接字选择中等待，或者从空队列中获取任务）被过滤掉。 默认为true。 
