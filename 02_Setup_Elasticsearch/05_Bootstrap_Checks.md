## 启动引导检查（Bootstrap check）

总的来说，我们有很多关于用户遭遇意外问题的经验，因为他们没有配置[重要的设置](important-ettings.html“Important Elasticsearch configuration”)。在之前的Elasticsearch版本中，某些设置的配置错误被记录为警告。可以理解的是，用户有时会错过这些日志消息。为了确保这些设置得到他们应得的关注，Elasticsearch在启动时进行引导检查。

这些引导检查检查各种Elasticsearch和系统设置，并将它们与Elasticsearch操作安全的值进行比较。如果Elasticsearch处于开发模式，那么失败的任何引导检查都会在Elasticsearch日志中显示为警告。如果Elasticsearch处于生产模式，则任何失败的引导检查都将导致Elasticsearch拒绝启动。

有一些引导程序检查始终强制执行，以防止Elasticsearch在不兼容的设置下运行。这些检查单独记录。

###开发环境 vs 生产环境

默认情况下，Elasticsearch绑定到`localhost`[HTTP](modules-http.html “HTTP”)和[transport（internal）](modules-transport.html“Transport”)进行通信的。这对于Elasticsearch的下载和试用，以及日常的开发是很好的，但对于生产系统来说是没有用的。要加入群集，必须通过传输通信访问Elasticsearch节点。要通过外部网络接口加入集群，节点必须将传输绑定到外部接口，而不是使用[单节点发现](bootstrap-checks.html＃单节点发现“单节点discoveryedit”)。因此，如果Elasticsearch节点无法通过外部网络接口与另一台计算机形成群集，并且在外部接口上可以加入群集，那么我们认为Elasticsearch节点处于开发模式，否则处于生产模式。

请注意，HTTP和transport可以通过[`http.host`](modules-http.html“HTTP”)和[`transport.host`](modules-transport.html“Transport”)单独配置。这对于配置单个节点可通过HTTP进行测试而无需触发生产模式是很有用的。

### 单节点发现（Single-node discovery）


我们认识到，一些用户需要将传输绑定到一个外部接口来测试他们对传输客户端的使用情况。对于这种情况，我们提供了发现类型“单节点”（通过将“discovery.type”设置为“单single-node”来配置它）。在这种情况下，一个节点将选举自己的主人，不会加入任何其他节点的集群

### 强制启动引导检查

如果在生产环境中运行单个节点，则可以避开引导程序检查（通过不将绑定绑定到外部接口，或通过将绑定绑定到外部接口并将发现类型设置为“单节点”）。对于这种情况，可以通过将系统属性`es.enforce.bootstrap.checks`设置为`true`来强制执行引导程序检查（在[Setting JVM options](setting-system-settings.html＃jvm-选项“设置JVM选项”)，或者通过将“-Des.enforce.bootstrap.checks = true”添加到环境变量ES_JAVA_OPTS中）。如果您处于这种特定情况，我们强烈建议您这样做。这个系统属性可以用来强制执行独立于节点配置的引导检查。
