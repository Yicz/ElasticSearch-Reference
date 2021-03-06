## 基本概念

这里列出了几个ES的核心概念，理解这些概念能帮助你的更好学习ES

### 近实时 (NRT)

ES是一个近实时的搜索平台，意味着只要一个延迟就可以（通常是1秒），你可以查询到你索引的文档。

### 集群（Cluster）

集群是一个或者多个节点`elasticsearch`,名字是很重要的一个部分，他标志着一个节点（Node）唯一所属的集群。

确保你在不同的环境使用不一样的名字，否则他们将会加入不同的节点。举个例子：你可以使用`logging-dev`，`logging-stage`,`logging-prod`分别为开发环境，测试环境，生产环境。

注意！只有一个节点的集群是完全可以的。 此外，您还可能拥有多个独立的群集，每个群集都有自己的唯一群集名称。
### 节点 (Node)

一个节点是集群中一个独立的应用，它保存你的数据，并参与索引和搜索的功能。类似集群，节点也有一个唯一的名字，默认是在启动的时候分配一个随机的UUID，你也可以指定一个你喜欢的名字，如果你不喜欢这个名字。这个名字对ES集群的管理者是相当重要的，它标志着集群中有那个节点在工作。

一个节点通过配置它的群集名称，让它加入一个集群，节点默认加入的集群是`elasticsearch`,意味着默认启动一个节点就会加入`elasticsearch`的集群。

在一个群集中，你会有大量的节点。 此外，如果你的环境没有ES服务，你启动一个ES节点，它会自己加入一个单节点的集群。

### 索引（Index）

索引是具有相似特征的文档的集合。 例如，您可以拥有客户数据的索引，产品目录的另一个索引以及订单数据的另一个索引。 索引由名称标识（必须全部为小写），该名称用于在对索引文档进行索引，搜索，更新和删除操作时引用索引。

在一个集群中，你可以定义你想要多的索引

### 类型 (Type)

在一个索引内，你可以定义一个或者多个类型，类型是

类型是您的索引的逻辑类别/分区，其语义完全取决于您。 通常，为具有一组公共字段的文档定义类型。 例如，假设您运行博客平台并将所有数据存储在单个索引中。 在此索引中，您可以为用户数据定义类型，为博客数据定义另一个类型，为定义数据定义另一个类型。

### 文档（Document）

文档是可以索引的最基本信息，例如，你可以对一个客户称作一个文档，一个产品称作另个一个文档，再另个一个文档是订单。文档被表述为一个[Json]（http://json.org/）(javascript object Notation)数据传输对象。

在索引/类型中，您可以根据需要存储多个文档。 请注意，尽管文档实际上驻留在索引中，但实际上文档必须被索引/分配给索引内的类型。

### 分片 & 副本

索引可能潜在地存储大量数据，这些数据可能会超出单个节点的硬件限制。 例如，占用1TB磁盘空间的十亿份文档的单个索引可能不适合单个节点的磁盘，或者可能太慢而无法单独为来自单个节点的搜索请求提供服务。

为解决这个问题，ES提供了分片机制：分割你的数据到不同的地方，当你创建索引的时候，你可以定义分片的数量，每一个分片都是管委会完全并独立的索引

分片是非常重要的两个理由:

  * 允许你垂直分割/拓展你的容量
  * 允许你分布式和并行地进行操作，这样可以提高性能/生产力

如何分片的机制以及文档如何聚合回搜索请求完全由ES管理，这操作对用户来说是透明的。

在任何时候都可能出现故障的网络/云环境中，非常有用并强烈建议有一个故障切换机制，以防分片/节点以某种方式脱机或因任何原因而消失。 为此，Elasticsearch允许您将索引分片的一个或多个副本。

副本是非常重要的两个理由:

  * 它提供了一个高可用的机制，当一个分片或者节点失败的时候。一个副本分片是不允许跟`原始/主`分片分在同一个结点上的
  * 它允许你大量计算人的数据通过在分片上并行执行请求

总结，第一个索引可以被分成多个分片。一个索引也可以设置0个副本。一旦设置了副本，索引就会存在主分片（原始数据）和副本分片（原始数据的拷贝），分片是数量是在索引创建的时候进行指定的，你可以随时动态更改副本的数量，但您无法在事后更改分片的数量。

ES分片默认的设置是分配5个分片和一个副本，这意味着至少集群要包含两个结点。通过默认设置，你会得到5个分片和5个副本分片，总共就是每个索引（index）10个分片。


![提示](/images/icons/note.png)

每一个ES分片都是一个lucene的索引. 单个lucene索引中文档数是有一个最大值的. 参考 [`LUCENE-5843`](https://issues.apache.org/jira/browse/LUCENE-5843), 最大值是 `2,147,483,519` (= Integer.MAX_VALUE - 128) 你可以使用 [`_cat/shards`](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/cat-shards.html) api进行查看分片的大小

现在让我们开始最有趣的部分。
