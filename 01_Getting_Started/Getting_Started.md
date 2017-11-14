# 入门指南

**Elasticsearch**是一个**高度可扩展**的开源全文搜索和分析引擎。它使您能够**快速**，**近似实时**地存储，搜索和分析大量数据。它通常用作支持具有复杂搜索功能和需求的应用程序的底层引擎/技术。

下面是Elasticsearch可用于的几个示例用例：

* 您运行一个在线网上商店，让您的客户搜索您销售的产品。在这种情况下，您可以使用Elasticsearch来存储整个产品目录和库存，并为其提供搜索和自动填充建议。

* 您希望收集日志或交易数据，并且想要分析和挖掘这些数据以查找趋势，统计数据，总结或异常情况。在这种情况下，可以使用Logstash（Elasticsearch / Logstash / Kibana堆栈的一部分）来收集，汇总和解析数据，然后使用Logstash将这些数据提供给Elasticsearch。一旦数据在Elasticsearch中，您可以运行搜索(search)和聚合(aggregate)来挖掘您感兴趣的任何信息。

* 你运行一个价格提醒平台，它允许精明的顾客指定一个规则，例如“我有兴趣购买一个特定的电子产品，如果在下个月内任何供应商的产品价格低于$X，我都会收到通知” 。在这种情况下，您可以刮取供应商价格，将其推入Elasticsearch，并使用其反向搜索（Percolator）功能将价格变动与客户查询进行匹配，并在发现匹配后最终将警报推送给客户。

* 您有分析/业务智能的需求，并希望快速调查，分析，可视化并针对大量数据提出特别的问题（想想几百万或几十亿条记录）。在这种情况下，您可以使用Elasticsearch存储数据，然后使用Kibana（Elasticsearch / Logstash / Kibana堆栈的一部分）来构建自定义仪表板，以便可视化数据对您很重要的几个方面。另外，您可以使用Elasticsearch聚合功能来针对您的数据执行复杂的商业智能查询。

对于本教程的其余部分，我将引导您完成启动并运行Elasticsearch的过程，查看它并执行诸如索引，搜索和修改数据的基本操作。在本教程结束时，您应该对Elasticsearch是什么以及它的工作原理有一个很好的了解，并希望能够启发您如何使用它来构建复杂的搜索应用程序或从数据中挖掘情报。

## [基本概念](Basic_Concepts.md)
## [安装](Installation.md)
## [了解你的集群](Exploring_Your_Cluster/Exploring_Your_Cluster.md)
### [集群状态](Exploring_Your_Cluster/Cluster_Health.md)
### [列出所有索引](Exploring_Your_Cluster/List_All_Indices.md)
### [新建索引](Exploring_Your_Cluster/Create_an_Index.md)
### [索引并查询一个文档](Exploring_Your_Cluster/Index_and_Query_a_Document.md)
### [删除索引](Exploring_Your_Cluster/Delete_an_Index.md)
## [修改你的数据]()
### [更新操作](Modifying_Your_Data/Updating_Documents.md)
### [批量操作](Modifying_Your_Data/Batch_Processing.md)
### [删除操作](Modifying_Your_Data/Deleting_Documents.md)
## [了解你的数据]()
### [查询API（Search API）](Exploring_Your_Data/The_Search_API.md)
### [查询语言介绍](Exploring_Your_Data/Introducing_the_Query_Language.md)
### [执行查询](Exploring_Your_Data/Executing_Searches.md)
### [执行过虑器](Exploring_Your_Data/Executing_Filters.md)
### [执行聚合](Exploring_Your_Data/Executing_Aggregations.md)
## [结论](Conclusion.md)




