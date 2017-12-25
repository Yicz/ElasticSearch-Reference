# 整个集群重启升级
Elasticsearch需要完整的集群跨大版本升级时重新启动。滚动升级在主要版本不支持。查阅[此表](Upgrading_Elasticsearch.md)来验证一个集群需要完整重启。 　　 　　

集群需要完整重启执行流程如下:

1. 禁用分片分配  
    当关闭节点时，分配过程将等待一分钟，然后开始将该节点上的分片复制到集群中的其他节点，导致大量浪费的I/O。 这可以通过关闭节点之前禁用分配来避免：
    
    ```sh
    curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
    {
      "transient": {
        "cluster.routing.allocation.enable": "none"
      }
    }
    '
    ```
    
2. 执行一个同步刷新
    分片复原将更快:
    
    ```sh
    curl -XPOST 'localhost:9200/_flush/synced?pretty'
    ```
    
3. 停止并升级全部结节  
   停止集群中所有elastisearch服务，每一个的[升级](Rolling_upgrades.md)的过程都是一致的
   
   
4. 升级插件  
   升级集群中的一个节点，必须升级这个节点的插件。使用elasticsearch-plugin命令进行重新安装
   
5. 启动整个集群的节点  
   启动升级后的节点，并使用如下命令的检查集群的状态：
   
   ```sh
   # 查看节点状态
   curl -XGET 'localhost:9200/_cat/nodes?pretty'
   # 查看集群状态
   curl -XGET 'localhost:9200/_cat/nodes?pretty'
   ```
6. 等待集群状态变黄色
   慢慢的一个个节点交会加入到集群中，单个节点会开始恢复本地的主分片，一旦主分片恢复完成,状态就会变成黄色，没有变成绿色的原因是我们这实禁用了分功的配置。   
7. 重新雇用分片配置
   一旦一个升级后的结节重新进入到集群中后，我们就要重新设置这个结点的分片配置功能：
   
   ```sh
   curl -XPUT 'localhost:9200/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
    {
      "transient": {
        "cluster.routing.allocation.enable": "all"
      }
    }
    '
    ``` 
   
