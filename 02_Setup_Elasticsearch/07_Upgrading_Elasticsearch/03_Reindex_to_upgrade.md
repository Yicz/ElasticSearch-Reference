# 重新建立引过升级
Elasticsearch能够只兼容在主要版本变动创建索引。例如,Elasticsearch 5.x可以使用索引创建Elasticsearch 2.x,但Elasticsearch 1中创建的索引例外！

> ### Tips 
> Elasticsearch 5.x 的版本不能使用太旧版本的索引数据，否则5.x将启动不成功。

如果您正在运行Elasticsearch 2.x群集包含了在2.x之前旧版本创建的索引，在升级到5.x之前则需要删除这些旧的索引或重新索引它们。 

如果你傅的是Elasticsearch 1.x 的版本，你有两种方式进行升级：

1. 先升级到2.4.x的版本，[重建索引](#reindex)文件后，再升级到5.x.x的版本
2. 直接建立5.x.x 版本的群集，然后使用[reindex-from-remote](#reindex-from-remote)导入1.x版本的索引

## [重建索引并替换](reindex)
将旧的（1.x）索引重建索引的最简单方法是使用[Elasticsearch迁移插件(migration plugin)](https://github.com/elastic/elasticsearch-migration/tree/2.x)。您将需要先升级到Elasticsearch 2.3.x或2.4.x。

迁移插件中提供的reindex实用程序执行以下操作：

* 使用类似旧索引名称（例如my_index-2.4.1）的在Elasticsearch版本创建新索引，并从旧索引复制映射和设置。新索引上的刷新处于禁用状态，为有效重新索引，副本数量设置为0。
* 将旧索引设置为只读，以确保没有数据写入旧索引。
* 将旧索引中的所有文档重新索引到新索引。
* 将refresh_interval和number_of_replicas重置为旧索引中使用的值，并等待索引变为绿色。
* 将旧索引中存在的任何别名添加到新索引。
* 删除旧的索引。
* 使用旧的索引名称为新索引添加一个别名，例如别名my_index指向索引my_index-2.4.1。

在这个过程的最后，你将会有一个新的2.x索引，可以被Elasticsearch 5.x集群使用。
## [Reindex-from-remote](reindex-from-remote)
如果您正在运行1.x群集，并且希望直接迁移到5.x而无需先迁移到2.x，则可以使用[reindex-from-remote](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-reindex.html#reindex-from-remote)。

您需要在现有的1.x群集里面设置5.x群集。 5.x群集需要访问1.x群集的REST API权限。

对于要转移到5.x群集的每个1.x索引，您需要：

* 在5.x中使用适当的映射和设置创建一个新的索引。将refresh_interval设置为-1，并将number_of_replicas设置为0以加快重新索引。
* 使用[reindex-from-remote](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/docs-reindex.html#reindex-from-remote)将1.x索引中的文档拖入新的5.x索引。
* 如果您在后台运行reindex作业（wait_for_completion设置为false），则重新索引请求将返回一个task_id，该task_id可用于监视任务API中reindex作业的进度：GET _tasks /task_id。
* 重新索引完成后，将refresh_interval和number_of_replicas设置为所需值（默认值分别为30秒和1）。
* 新索引完成复制后，可以删除旧的索引。

5.x集群可以从小处开始，并且可以在迁移索引时逐渐将节点从1.x集群移动到5.x集群