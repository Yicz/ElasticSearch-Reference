# 安装

在撰写本文时，Elasticsearch至少需要Java 8 的环境.建议您使用Oracle JDK 1.8.0_131版本。 Java安装因平台而异，所以我们不会在这里详细介绍这些细节。 Oracle推荐的安装文档可以在Oracle网站上找到。 在您安装Elasticsearch之前，请先检查一下您的Java版本，然后运行（然后根据需要安装/升级）：

```sh
java -version
echo $JAVA_HOME
```

一旦我们建立了Javag环境，我们就可以下载并运行Elasticsearch。 这些二进制文件可以从www.elastic.co/downloads以及过去发布的所有版本中获得。 对于每个版本，您可以在zip或tar档案或DEB或RPM包中进行选择。 为了简单起见，我们使用tar文件。

```sh
#下载5.4.3 版本的elasticsearch
curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.tar.gz
# 对tar文件进行解压
tar -xvf elasticsearch-5.4.3.tar.gz
# 进行elasticsearch目录
cd elasticsearch-5.4.3/bin
# 运行elasticsearch
./elasticsearch
```
如果一切正常，运行会输出如下的日志：

```sh
[2016-09-16T14:17:51,251][INFO ][o.e.n.Node               ] [] initializing ...
[2016-09-16T14:17:51,329][INFO ][o.e.e.NodeEnvironment    ] [6-bjhwl] using [1] data paths, mounts [[/ (/dev/sda1)]], net usable_space [317.7gb], net total_space [453.6gb], spins? [no], types [ext4]
[2016-09-16T14:17:51,330][INFO ][o.e.e.NodeEnvironment    ] [6-bjhwl] heap size [1.9gb], compressed ordinary object pointers [true]
[2016-09-16T14:17:51,333][INFO ][o.e.n.Node               ] [6-bjhwl] node name [6-bjhwl] derived from node ID; set [node.name] to override
[2016-09-16T14:17:51,334][INFO ][o.e.n.Node               ] [6-bjhwl] version[5.4.3], pid[21261], build[f5daa16/2016-09-16T09:12:24.346Z], OS[Linux/4.4.0-36-generic/amd64], JVM[Oracle Corporation/Java HotSpot(TM) 64-Bit Server VM/1.8.0_60/25.60-b23]
[2016-09-16T14:17:51,967][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [aggs-matrix-stats]
[2016-09-16T14:17:51,967][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [ingest-common]
[2016-09-16T14:17:51,967][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [lang-expression]
[2016-09-16T14:17:51,967][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [lang-groovy]
[2016-09-16T14:17:51,967][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [lang-mustache]
[2016-09-16T14:17:51,967][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [lang-painless]
[2016-09-16T14:17:51,967][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [percolator]
[2016-09-16T14:17:51,968][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [reindex]
[2016-09-16T14:17:51,968][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [transport-netty3]
[2016-09-16T14:17:51,968][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded module [transport-netty4]
[2016-09-16T14:17:51,968][INFO ][o.e.p.PluginsService     ] [6-bjhwl] loaded plugin [mapper-murmur3]
[2016-09-16T14:17:53,521][INFO ][o.e.n.Node               ] [6-bjhwl] initialized
[2016-09-16T14:17:53,521][INFO ][o.e.n.Node               ] [6-bjhwl] starting ...
[2016-09-16T14:17:53,671][INFO ][o.e.t.TransportService   ] [6-bjhwl] publish_address {***192.168.8.112:9300***}, bound_addresses {{192.168.8.112:9300}
[2016-09-16T14:17:53,676][WARN ][o.e.b.BootstrapCheck     ] [6-bjhwl] max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]
[2016-09-16T14:17:56,731][INFO ][o.e.h.HttpServer         ] [6-bjhwl] publish_address {192.168.8.112:9200}, bound_addresses {[::1]:9200}, {192.168.8.112:9200}
[2016-09-16T14:17:56,732][INFO ][o.e.g.GatewayService     ] [6-bjhwl] recovered [0] indices into cluster_state
[2016-09-16T14:17:56,748][INFO ][o.e.n.Node               ] [6-bjhwl] started
```
没有太多细节，我们可以看到我们的节点名为“6-bjhwl”（在你的情况下将是一个不同的字符集）已经开始，并选择自己作为一个集群中的主节点（master node）。 现在不要担心主节点（master node）的意思。 这里最主要的是我们在一个集群中启动了一个节点。

如前所述，我们可以覆盖群集或节点名称。 启动Elasticsearch时，可以从命令行执行以下操作：

```sh
./elasticsearch -Ecluster.name=my_cluster_name -Enode.name=my_node_name
```

还请注意标记为http的行，其中包含有关可以访问节点的HTTP地址（192.168.8.112）和端口（9200）的信息。 默认情况下，Elasticsearch使用端口9200来提供对其REST API的访问。 如有必要，此端口可配置。