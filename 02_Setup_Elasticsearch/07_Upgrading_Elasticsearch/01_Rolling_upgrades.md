# 滚动升级(Rolling Upgrade)
滚动升级允许在Elasticsearch群集一次升级一个节点，而不会导致用户停机。 在同一集群中不允许长时间运行多个版本的Elasticsearch，因为分片不会从最新版本复制到旧版本。

请参阅[此表](Upgrading_Elasticsearch.md)以验证您的Elasticsearch版本是否支持滚动升级(
Rolling Upgrade)。

要执行滚动升级步骤：

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
    
2. 停止不必要的索引和执行一个同步刷新（可选）
    你可以愉快地在升级继续建立索引。如果你暂时停止不必要的索引和执行[synced-flush请求](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/indices-synced-flush.html)，分片复原将更快:
    
    ```sh
    curl -XPOST 'localhost:9200/_flush/synced?pretty'
    ```
    
3. 停止并升级一个单结节
   在开始升级前，要停止当前要升级的结节
   
   > ### Tips
   > 使用zip或tar包时，缺省情况下，config，data，logs和plugins目录被放置在Elasticsearch主目录中。

   > 将这些目录放置在写Elasticsearch不同的位置是一个好主意，以便在升级Elasticsearch时不会删除它们。 可以使用path.conf，path.logs和path.data设置来配置这些自定义路径，并使用ES_JVM_OPTIONS来指定jvm.options文件的位置。

   > Debian和RPM软件包将这些目录放置在每个操作系统的适当位置。
   
   使用Debian 或 RPM 包进行升级：
   
   * 使用rpm或dpkg安装新的包。所有文件应放置在适当的位置,和配置文件不应该被覆盖。
   
   使用zip 或 tar.gz 包升级：
   
   * 提取zip或压缩文件到一个新的目录,可以肯定的是,你不覆盖配置或数据目录。
   * 从你的旧的config目录中复制文件到你的新安装目录,或指定环境变量$ES_JVM_OPTIONS来设置jvm的位置。或使用命令参数 -E path.config=<config-path>来指定配置文件的位置。
   * 配置elasticsearch.yaml来指定索引data的存放位置，或者直接拷贝一分旧的data数据到新的data路径。
   
4. 升级插件  
   升级集群中的一个节点，必须升级这个节点的插件。使用elasticsearch-plugin命令进行重新安装
5. 启动升级后的节点  
   启动升级后的节点，并使用如下命令的检查集群的状态：
   
   ```sh
   curl -XGET 'localhost:9200/_cat/nodes?pretty'
   ```
   
6. 重新雇用分片配置
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
7. 等待结点数据的恢复  
   你应该等待当前节结完成分片分配后再进行集群下一个节点的升级。您可以使用_cat/health检查当前集群的状态:
   
   ```sh
   curl -XGET 'localhost:9200/_cat/health?pretty'
   ```
   
   等待状态列从黄色变为绿色。状态绿色意味着所有primary-shards(主分片)和replica-shards（复制分片）全部重新分配。
   
   > ### Tips 
   > 在滚动升级期间，分配给具有较高版本的节点的主分片永远不会将其副本分配给具有较低版本的节点，因为较新版本可能具有旧版本不能理解的不同数据格式。
   
   > 可能存在副本分片示分配到另一个节点情况 - 例如 如果群集中只有一个版本较高的节点，则副本分片将保持未分配状态，群集运行状况将保持状态黄色。

   > 在这种情况下，请确保在执行前没有初始化或重定位分片（init和relo列）。

   > 一旦另一个节点也升级了，则会进行分配副本并且群集运行状况将切换到状态绿色。
   
 8. 重复  
    当集群运行良好并数据稳定后，重复执行一面的步骤对剩余的节点进行升级，