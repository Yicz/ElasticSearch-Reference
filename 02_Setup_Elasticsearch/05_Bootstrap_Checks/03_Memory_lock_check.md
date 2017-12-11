## 内存锁定检查 Memory lock check

当JVM执行一个主要的垃圾收集时，它会触及堆的每一页。如果这些页面中的任何一个被（swap）换出到磁盘上，它们将不得不被再次换回到存储器中。这会导致大量的磁盘抖动，Elasticsearch更愿意把性能用来处理请求。有几种方法可以配置系统禁止交换。一种方法是请求JVM通过“mlockall”（Unix）或虚拟锁（Windows）将内存锁定在内存中。这是通过Elasticsearch设置[`bootstrap.memory_lock`](important-settings.html＃bootstrap.memory_lock“bootstrap.memory_lockedit”)完成的。但是，有些情况下这个设置可以传递给Elasticsearch，但Elasticsearch不能锁定堆（例如，如果elasticsearch用户没有`memlock unlimited`）。内存锁定检查验证如果启用了`bootstrap.memory_lock`设置，则JVM能够成功锁定堆。要通过内存锁定检查，您可能需要配置[`mlockall`](setup-configuration-memory.html＃mlockall“Enable bootstrap.memory_lock”)。
