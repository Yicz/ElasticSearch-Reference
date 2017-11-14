# 引导检查

总的来说，我们有很多用户遭遇意外问题的经验，因为他们没有配置重要的设置。 在之前的Elasticsearch版本中，其中一些设置的配置错误被记录为警告。 可以理解的是，用户有时会错过这些日志消息。 为了确保这些设置得到他们应得的关注，Elasticsearch在启动时进行引导检查。

这些引导检查检查各种Elasticsearch和系统设置，并将它们与Elasticsearch操作安全的值进行比较。 如果Elasticsearch处于开发模式，那么失败的任何引导检查都会在Elasticsearch日志中显示为警告。 如果Elasticsearch处于生产模式，则任何失败的引导检查都将导致Elasticsearch拒绝启动。

有一些引导程序检查始终强制执行，以防止Elasticsearch在不兼容的设置下运行。 这些检查单独记录。

## 模式对比：development VS production

默认情况下，Elasticsearch绑定到本地主机进行HTTP和传输（内部）通信。 这对于下载Elasticsearch用来玩，以及日常的开发是很好的，但对于生产系统来说是没有用的。 要加入群集，必须通过传输通信访问Elasticsearch节点。 要通过外部网络接口加入集群，节点必须将传输绑定到外部接口，而不是使用单节点发现。 因此，如果Elasticsearch节点无法通过外部网络接口与另一台计算机形成群集，并且在外部接口上可以加入群集，那么我们认为Elasticsearch节点处于开发模式，否则处于生产模式。

请注意，HTTP和transport可以通过http.host和transport.host单独配置。 这对于配置单个节点可通过HTTP进行测试而无需触发生产模式是很有用的。

## 单点发现

我们认识到，一些用户需要将传输绑定到一个外部接口来测试他们对传输客户端的使用情况。 对于这种情况，我们提供了发现类型的单节点（通过将discovery.type设置为单节点来配置它）。 在这种情况下，节点将选举自己的主人，不会加入任何其他节点的集群。

## 强制引导检查

如果您在生产环境中运行单个节点，则可以通过不绑定传输到外部接口，或通过将传输绑定到外部接口并将发现类型设置为单节点来避开引导程序检查。 对于这种情况，您可以通过将系统属性es.enforce.bootstrap.checks设置为true来强制执行引导程序检查（在设置[JVM选项](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/setting-system-settings.html#jvm-options)中进行设置，或者向环境中添加-Des.enforce.bootstrap.checks = true 变量ES_JAVA_OPTS）。 如果您处于这种特定情况，我们强烈建议您这样做。 这个系统属性可以用来强制执行独立于节点配置的引导检查。