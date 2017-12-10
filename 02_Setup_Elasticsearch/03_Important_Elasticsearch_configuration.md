## 重要的ES配置

ES有时候需要小部分的配置，下面的配置需要手动配置，并在进行生产环境的时候要明确匹配：

  * [`path.data` and `path.logs`](important-settings.html#path-settings "path.data and path.logsedit")
  * [`cluster.name`](important-settings.html#cluster.name "cluster.nameedit")
  * [`node.name`](important-settings.html#node.name "node.nameedit")
  * [`bootstrap.memory_lock`](important-settings.html#bootstrap.memory_lock "bootstrap.memory_lockedit")
  * [`network.host`](important-settings.html#network.host "network.hostedit")
  * [`discovery.zen.ping.unicast.hosts`](important-settings.html#unicast.hosts "discovery.zen.ping.unicast.hostsedit")
  * [`discovery.zen.minimum_master_nodes`](important-settings.html#minimum_master_nodes "discovery.zen.minimum_master_nodesedit")



### `path.data` and `path.logs`

如果你使用的是 `.zip` or `.tar.gz` 安装包, `data` 会 `logs` 会在 `$ES_HOME`目录下. 如果使用默认的配置，在升级ES的时候，有可以会对数据和日志文件进行删除。这是一种高风险的配置，我们推荐在生产环境中手动配置data和log的路径。
    
    path:
      logs: /var/log/elasticsearch
      data: /var/data/elasticsearch

RPM and Debian安装包已经 自定义了 `data` and `logs`的目录路径.

path.data可以配置多个路径，也就会保存多份一致的数据。    
    
    path:
      data:
        - /mnt/elasticsearch_1
        - /mnt/elasticsearch_2
        - /mnt/elasticsearch_3

### `cluster.name`

`cluster.name`标志着节点要加入的群集。默认值是`elasticsearch`,你可以修改成你想要加入的集群。
    
    cluster.name: logging-prod

请确保在不同的环境中的集群名称不相同。否则就相当于只有一个环境，

### `node.name`

默认地ES会随机生成7个字符作为节点的ID，并作为`node.name`使用，只在第一次启动的时候生成保存，重启并不会重新生成。

建议配置一个有意义的节点名称，便于标识节点。    
    
    node.name: prod-data-2

`node.name` 可以配置成服务器的HOSTNAME:
    
    node.name: ${HOSTNAME}

### `bootstrap.memory_lock`

这是一个jvmk跟磁盘交换的一个重要指标，并显示着节点的健康状态。设置`bootstrap.memory_lock=true`,要系统配置支持。[更多关于启用`bootstrap.memory_lock`的详情](setup-configuration-memory.html#mlockall "Enable bootstrap.memory_lock") 

### `network.host`

默认地ES配置绑定了回环地址 `127.0.0.1` and `[::1]`. 这个配置只对单节点服务生效。事实上在同一台机器上可以启动多个节点，不推荐在产生环境上使用。

为了集群之间的节点可以交流，我们要配置一个非回环地址。 [更多网络配置详情](modules-network.html "Network Settings")
    
    network.host: 192.168.1.10

`network.host` 配置可以理一些特殊的字符如： `_local_`, `_site_`, `_global_`  `:ip4`和 `:ip6`


### `discovery.zen.ping.unicast.hosts`

开箱即用，默认的配置下，ES绑定了回环地址并会在端口9300-9305之前与同一台机子上的节点进行交流。这是默认的群集自动配置。


当你的集群有多台服务器上的节点时，你要提供这些节点的列表让他们之间可以进行交流，提供的格式如下。
    
    discovery.zen.ping.unicast.hosts:
       - 192.168.1.10:9300
       - 192.168.1.11 没提供端口，会使用transport.profiles.default.port和transport.tcp.port
       - seeds.mydomain.com 使用ip来映射多个ip地址
  
### `discovery.zen.minimum_master_nodes`

为了防止数据丢失，心須要配置`discovery.zen.minimum_master_nodes `


为防止数据丢失，配置“discovery.zen.minimum_master_nodes”设置至关重要，以便每个符合主节点的节点都知道为了形成一个集群而必须可见的最低限度的主节点数量_。

如果没有这个设置，那么遭受网络故障的集群就有可能将集群分成两个独立的集群 - 分裂的大脑 - 这将导致数据丢失。 [避免与`minimum_master_nodes分裂脑]提供更详细的解释。

为了避免脑裂，这个设置应该被设置为主节点的一个公式：    
    
    (master_eligible_nodes / 2) + 1

换句话说，如果有三个主节点，那么最小主节点应该设置为“（3/2）+ 1”或“2”：    
    
    discovery.zen.minimum_master_nodes: 2
