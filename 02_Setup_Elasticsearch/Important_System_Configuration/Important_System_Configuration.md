# 重要的系统配置

理想情况下，Elasticsearch应该在服务器上独立运行，并使用所有可用的资源。为此，您需要配置您的操作系统，以允许运行Elasticsearch的用户访问比默认允许的资源更多的资源。

在投入生产之前，必须解决以下设置：

* [设置JVM堆大小（Set JVM heap size）](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/heap-size.html)
* [禁用交换（Disable swapping）](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/setup-configuration-memory.html)
* [增加文件描述符（Increase file descriptors）](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/file-descriptors.html)
* [确保足够的虚拟内存（Ensure sufficient virtual memory）](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/vm-max-map-count.html)
* [确保足够的线程（Ensure sufficient threads）](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/max-number-of-threads.html)

## 开发模式与生产模式

默认情况下，Elasticsearch假定你正在开发模式下工作。如果以上任何设置配置不正确，则将向日志文件写入警告，但您将能够启动并运行Elasticsearch节点。

只要配置network.host等网络设置，Elasticsearch就会假定您正在转移到生产环境，并将上述警告升级为异常。这些异常将阻止您的Elasticsearch节点启动。这是一个重要的安全措施，以确保您不会因为配置错误的服务器而丢失数据。