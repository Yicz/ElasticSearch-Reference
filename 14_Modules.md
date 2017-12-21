# 模块 Modules

本章节主要说明ES各个方面的功能模块，大致两个模块如下：

_静态部分（static）_   
     
     这一部分属于节点级别，包含`elasticsearch.yml`，环境变量，节点启动的命令行参数，它们在群集的节点中必须明确指定。
_动态部分（dynamic）_  
     
     这一部分主要使用 [cluster-update-settings](cluster-update-settings.html "Cluster Update Settings") API. 

模块详细划分如下:

[集群级别的分片划分](modules-cluster.html "Cluster")  
     配置控制着在哪，什么时候，怎么样去分配分片到节点。  
[注册中心（Discovery）](modules-discovery.html "Discovery")  
     集群如何发现节点  
[网关](modules-gateway.html "Local Gateway")  
     How many nodes need to join the cluster before recovery can start.   
[HTTP](modules-http.html "HTTP")  
     配置HTTP节点的接口   
[索引](modules-indices.html "Indices")  
     全局索引相关   
[网络模块](modules-network.html "Network Settings")  
     网络设置.   
[客户端节点](modules-node.html "Node")  
     一个结点，但不包含数据，只有功能的节点  
[Painless](modules-scripting-painless.html "Painless Scripting Language")  
     是为了ES安全的内置脚本语言   
[插件](modules-plugins.html "Plugins")  
     ES的功能拓展   
[脚本](modules-scripting.html "Scripting")  
     自定义脚本包含 Lucene Expressions, Groovy, Python, and Javascript.还有内置的[Painless](modules-scripting-painless.html "Painless Scripting Language").   
[快照/重建（Snapshot/Restore）](modules-snapshots.html "Snapshot And Restore")  
     备份功能  
[线程池](modules-threadpool.html "Thread Pool")  
     ES线程池的说明  
[传输模块](modules-transport.html "Transport")  
     集群中节点之间的传输，包含网络层相关信息。  
[簇节点（Tribe nodes）](modules-tribe.html "Tribe node")  
     簇节点加入一个或多个集群，并作为跨联合客户端。  
[跨集群搜索（Cross cluster Search）](modules-cross-cluster-search.html "Cross Cluster Search")  
     跨群集搜索功能可跨多个群集执行搜索请求，而无需将其加入群组中，并充当联合客户端。  

