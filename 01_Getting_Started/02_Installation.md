## Installation

ES要求至少java 8的环境，特别地指现在这个版本，我们推荐使用`Oracle JDK 1.8.0_131`,java的安装因平台而已，这里我们不进行多详述，可以查看Oracle JDK的推荐安装[文档](http://docs.oracle.com/javase/8/docs/technotes/guides/install/install_overview.html),请查安装之前检查你的java版本（须要请安装或升级）：

    java -version
    echo $JAVA_HOME

一旦java安装好，我们就可以下载并安装运行ES，安装包可以从[`www.elastic.co/downloads`](http://www.elastic.co/downloads)下载。ES有很多发现的版本，但每个版本都提供了`zip`或`tar`压缩文件，或者`DEB`/`RPM`安装包。这里，方便起见，我们使用tar包进行示范安装。

我们通过如下的链接下载ES 5.4.3版本的tar包
    
    curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.tar.gz

通过下面的命令进行解压（window平台请使用zip的解压软件进行解压）
    
    tar -xvf elasticsearch-5.4.3.tar.gz

执行上面的命令会解压出一个文件夹，里面包含了我们想要的程序，进入bin查看内容
    
    cd elasticsearch-5.4.3/bin

现在我们可以启动我们的ES节点和单结点的集群：    
    
    ./elasticsearch

如果一切正常，你会得到下面的日志输出：
    
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
    [2016-09-16T14:17:53,671][INFO ][o.e.t.TransportService   ] [6-bjhwl] publish_address {192.168.8.112:9300}, bound_addresses { {192.168.8.112:9300}
    [2016-09-16T14:17:53,676][WARN ][o.e.b.BootstrapCheck     ] [6-bjhwl] max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]
    [2016-09-16T14:17:56,731][INFO ][o.e.h.HttpServer         ] [6-bjhwl] publish_address {192.168.8.112:9200}, bound_addresses {[::1]:9200}, {192.168.8.112:9200}
    [2016-09-16T14:17:56,732][INFO ][o.e.g.GatewayService     ] [6-bjhwl] recovered [0] indices into cluster_state
    [2016-09-16T14:17:56,748][INFO ][o.e.n.Node               ] [6-bjhwl] started

不用了解太详细，我们从日志中看到结点（node）被命令成了 `6-bjhwl` (在你的例子中可以是不同的名字) 且启动成功并选择了它自己作为单集群的主节点. 
现在别担主节点（master）的意思.重要的事情是我们成功运行了一个单集群节点。

此外，我们可以通过 如下的命令指定集群或者节点的名字：
    
    ./elasticsearch -Ecluster.name=my_cluster_name -Enode.name=my_node_name

日志同时还标记出了HTTP访问地址和它的端口。默认地ES会使用9200端口进行的提供 REST API，当然这个端口也是进行指定的。
