## 客户端JVM检查 Client JVM check

OpenJDK派生的JVM提供了两种不同的JVM：客户端JVM和服务器JVM。 这些JVM使用不同的编译器从Java字节码中生成可执行的机器码。 客户端JVM针对启动时间和内存占用情况进行了调整，同时对服务器JVM进行了调整以实现最佳性能。 两台虚拟机之间的性能差异可能很大。 客户端JVM检查确保Elasticsearch不在客户端JVM内部运行。 要通过客户端JVM检查，必须使用服务器VM启动Elasticsearch。 在现代系统和操作系统上，服务器虚拟机是默认的。 另外，Elasticsearch默认配置为强制服务器虚拟机(server VM)。

