## Use serial collector check

针对不同工作负载的OpenJDK派生的JVM有各种垃圾收集器。 串行收集器尤其适用于单个逻辑CPU或非常小的堆，这两个堆都不适合运行Elasticsearch。 与Elasticsearch一起使用串行收集器可能会破坏性能。 串行收集器检查确保Elasticsearch未配置为与串行收集器一起运行。 要通过串行收集器检查，您不得使用串行收集器启动Elasticsearch（无论是使用JVM的默认值，还是使用“-XX：+ UseSerialGC”显式指定）。 请注意，随Elasticsearch一起提供的默认JVM配置将Elasticsearch配置为使用CMS收集器。

