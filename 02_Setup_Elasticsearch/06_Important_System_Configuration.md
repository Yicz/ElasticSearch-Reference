## 重要的系统配置


理想情况下，Elasticsearch应该在服务器上独立运行，并使用所有可用的资源。为此，您需要配置您的操作系统，以允许运行Elasticsearch的用户访问比默认允许的资源更多的资源。

在投入生产之前**必须**解决以下设置：

  * [Set JVM heap size](heap-size.html "Set JVM heap size via jvm.options") JVM堆栈大小
  * [Disable swapping](setup-configuration-memory.html "Disable swapping") 禁用内存交换
  * [Increase file descriptors](file-descriptors.html "File Descriptors") 增加文件描述
  * [Ensure sufficient virtual memory](vm-max-map-count.html "Virtual memory") 增加虚拟内存
  * [Ensure sufficient threads](max-number-of-threads.html "Number of threads") 增加线程数

### 开发环境 vs 生产环境

默认情况下，Elasticsearch假定你正在开发模式下工作。如果以上任何设置配置不正确，则将向日志文件写入警告，但您将能够启动并运行Elasticsearch节点。

只要你配置了一个像network.host这样的网络设置，Elasticsearch就会假设你正在转向生产，并将上述警告升级为异常。这些异常将阻止您的Elasticsearch节点启动。这是一个重要的安全措施，以确保您不会因为配置错误的服务器而丢失数据。
