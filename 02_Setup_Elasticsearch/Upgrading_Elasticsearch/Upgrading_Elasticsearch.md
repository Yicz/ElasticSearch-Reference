# 升级Elasticsearch

> ## 在升级Elastic之前，要了解如下几点：
> * 阅读过[修改记录](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/breaking-changes.html)就这样
> * 使用[Elasticsearch迁移插件( Elasticsearch Migration Plugin)](https://github.com/elastic/elasticsearch-migration/)在升级之前检测可能潜在问题。
> * 在升级生产环境之前，先在开发环境进行测试
> * 在升级之前备份你的数据。没有数据，你将会失去回滚上一个版本的机会。
> * 如果你使用了自定义插件，请检查它的兼容性。

通常可以使用滚动升级过程来升级Elasticsearch，从而不会中断服务。 本节详细介绍如何在完全集群重启的情况下执行滚动升级和升级。

要确定您的版本是否支持滚动升级，请参阅此表：

|旧版本|新版本|支持升级类型|
|:---:|:---:|:---:|
|1.x|5.y|[重建索引升级](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/reindex-upgrade.html)|
|2.x|2.y|[滚动升级](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/rolling-upgrades.html)（y>x）|
|2.x|5.x|[集群重启](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/restart-upgrade.html)|
|5.0.0. pre GA|5.x|[集群重启](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/restart-upgrade.html)|
|5.x|5.y|[重建索引升级](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/rolling-upgrades.html)|

> ## 在Elasticsearch 1.x或之前版本创建的索引
> Elasticsearch只能读取在以前的主要版本中创建的索引。 例如，Elasticsearch 5.x可以使用在Elasticsearch 2.x中创建的索引，但不能使用在Elasticsearch 1.x或之前创建的索引。

> 这种情况也适用于使用快照和恢复进行备份的索引。 如果索引最初是在1.x中创建的，即使快照是由2.x集群创建的，也不能在5.x集群恢复。

> Elasticsearch 5.x节点在索引太旧的情况下将无法启动。

> 请参阅[重建索引升级](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/reindex-upgrade.html)以获取有关如何升级旧索引的更多信息。