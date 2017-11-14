# ElasticSearch 重要的配置
虽然Elasticsearch需要很少的配置中,但还是有些需要手动配置和进入生产阶段之前应该配置。

* [path.data and path.logs](#path.data and path.logs)
* [cluster.name](#cluster.name)
* [node.name](#node.name)
* [bootstrap.memory_lock](#bootstrap.memory_lock)
* [network.host](#network.host)
* [discovery.zen.ping.unicast.hosts](#discovery.zen.ping.unicast.hosts)
* [discovery.zen.minimum_master_nodes](#discovery.zen.minimum_master_nodes)

## path.data and path.logs
如果使用.zip或.tar.gz存档，则数据和日志目录是$ ES_HOME的子文件夹。 如果这些重要文件夹保留在其默认位置，则在将Elasticsearch升级到新版本时，这些文件夹被删除的风险很高。

在生产使用中，几乎可以肯定地要更改数据和日志文件夹的位置：

```yaml
path:
  logs: /var/log/elasticsearch
  data: /var/data/elasticsearch
```
RPM和Debian发行版已经使用数据和日志的自定义路径。

path.data设置可以设置为多个路径，在这种情况下，所有路径将用于存储数据（尽管属于单个分片的文件将全部存储在相同的数据路径中）：

```yaml
path:
  data:
    - /mnt/elasticsearch_1
    - /mnt/elasticsearch_2
    - /mnt/elasticsearch_3
```

## cluster.name
节点只能在与集群中的所有其他节点共享cluster.name时才能加入集群。 默认名称是elasticsearch，但是您应该将其更改为描述集群用途的适当名称。

```sh
cluster.name: logging-prod
```

确保你在不同的环境中没有重用相同的集群名称,否则你可能会最终加入了错误集群。

## node.name
默认情况下，Elasticsearch将随机生成的uuid的第一个字符作为节点ID。 请注意，节点ID是持久的，并且在节点重新启动时不会更改，因此默认节点名称也不会更改。

值得配置一个更有意义的名字，这个名字在重启节点后也会有持久的优势：

```yaml
node.name：prod-data-2
```
node.name也可以设置为服务器的HOSTNAME，如下所示：

```yaml
node.name：$ {HOSTNAME}
```
## bootstrap.memory_lock
对于您的节点的健康状况来说，没有任何一个JVM被swapper到磁盘上，这一点非常重要。 一种实现方法是将bootstrap.memory_lock设置为true。
要使此设置生效，需要首先配置其他系统设置。 有关如何正确设置内存锁定的更多详细信息，请参阅启用[bootstrap.memory_lock](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/setup-configuration-memory.html#mlockall)。
## network.host
默认情况下，Elasticsearch只绑定到回环地址 - 例如 127.0.0.1和[:: 1]。 这足以在服务器上运行单个开发节点。
为了与其他服务器上的节点进行通信并形成群集，您的节点将需要绑定到非环回地址。 虽然有很多的网络设置，通常你只需要配置network.host：

```yaml
network.host: 192.168.1.10
```
network.host设置还可以理解一些特殊的值，如_local_，_site_，_global_和修饰符如：ip4和：ip6，其详细信息可以在[network.hostedit的特殊值](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/modules-network.html#network-interface-values)中找到。

## discovery.zen.ping.unicast.hosts
开箱即用，没有任何网络配置，Elasticsearch将绑定到可用的环回地址，并将扫描端口9300到9305尝试连接到运行在同一服务器上的其他节点。 这提供了自动集群体验，而无需进行任何配置。

当需要与其他服务器上的节点组成群集时，您必须提供群集中其他节点的种子列表，这些节点可能是活的并且可联系的。 这可以指定如下：

```yaml
discovery.zen.ping.unicast.hosts:
   - 192.168.1.10:9300
   - 192.168.1.11 
   - seeds.mydomain.com 
```
* 端口将默认transport.profiles.default.port并回退。如果未指定transport.tcp端口。
* 主机名解析为多个IP地址将尝试所有解决地址。

## discovery.zen.minimum_master_nodes
为防止数据丢失，配置discovery.zen.minimum_master_nodes设置至关重要，以便每个符合主节点的节点都知道为了形成群集而必须可见的主节点的最小数量。

如果没有这个设置，那么遭受网络故障的集群就有可能将集群分成两个独立的集群 - 分裂的大脑 - 这将导致数据丢失。 在使用minimum_master_nodesedit避免分裂脑中提供了更详细的解释。

为了避免脑裂，应将此设置设置为符合主数据节点的法定人数：

```yaml
(master_eligible_nodes / 2)+ 1 　
```
换句话说,如果有三个master-eligible节点,那么最小主节点应该设置为(3 / 2)+ 1或2: 　　

```yaml
discovery.zen。minimum_master_nodes:2
```