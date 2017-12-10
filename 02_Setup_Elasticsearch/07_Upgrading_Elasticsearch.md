## ES升级


在升级Elasticsearch之前：

  * 请参阅[版本变化](breaking-changes.html“破坏性变化”)文件。
  * 使用[Elasticsearch迁移插件](https://github.com/elastic/elasticsearch-migration/)在升级之前检测潜在的问题。
  * 在升级您的生产群集之前，在开发环境中测试升级。
  * 升级前，请务必[备份您的数据](modules-snapshots.html“快照和还原”)。除非您有数据备份，否则无法将回滚到较早的版本。
  * 如果您使用自定义插件，请检查兼容版本是否可用。



通常可以使用滚动升级过程来升级Elasticsearch，从而不会中断服务。本章详细说明了如何在完全集群重启的情况下执行滚动升级和升级。

要确定您的版本是否支持滚动升级，请参阅此表：

|Upgrade From | Upgrade To | Supported Upgrade Type |
|:---:|:---:|:---:|  
|`1.x`| `5.x`| [Reindex to upgrade](reindex-upgrade.html "Reindex to upgrade")  |  
|`2.x`|`2.y`|[Rolling upgrade](rolling-upgrades.html "Rolling upgrades") (where `y > x`)  |
|`2.x`|`5.x`|[Full cluster restart](restart-upgrade.html "Full cluster restart upgrade")  |
|`5.0.0 pre GA`|`5.x`|[Full cluster restart](restart-upgrade.html "Full cluster restart upgrade")  |
|`5.x`|`5.y`|[Rolling upgrade](rolling-upgrades.html "Rolling upgrades") (where `y > x`)  |
  

### ES 1.x 或之前的版本索引

Elasticsearch能够读取在**前一个主要版本中创建的索引**。例如，Elasticsearch 5.x可以使用在Elasticsearch 2.x中创建的索引，但不能使用在Elasticsearch 1.x或之前创建的索引。

这种情况也适用于使用[快照和还原](modules-snapshots.html“快照和还原”)备份的索引。如果索引最初是在1.x中创建的，即使快照是由2.x集群创建的，也不能恢复到5.x集群。

Elasticsearch 5.x节点在索引太旧时将无法启动。

有关如何升级旧索引的更多信息，请参见[重建索引以升级](reindex-upgrade.html“重建索引以升级”)。
