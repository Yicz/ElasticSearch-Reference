## 通过文件jvm.options修改JV的堆大小（heap size）

默认地，ES使用的最小堆和最大堆的设置是2G,当迁移到生产环境时，配置一个满足可用的堆大小是一件重要的事情。


Elasticsearch将通过[jvm.options](setting-system-settings.html#jvm-options)来指定的整个堆的大小,配置选项是Xms（最小堆大小）和Xmx（最大堆大小）设置。

这些设置的值取决于服务器上可用的内存大小。 最佳的实践设置如下：

  * 将最小堆大小（Xms）和最大堆大小（Xmx）设置为彼此相等。
  * ES可用的堆越多，可用于缓存的内存就越多。 但是请注意，太大的堆可能会使您长时间垃圾收集暂停。
  * 将Xmx设置为不超过物理RAM的50％，以确保有足够的物理内存留给内核文件系统缓存。
  * 不要将Xmx设置为JVM用于压缩对象指针（压缩oops）的临界值以上; 确切上限不是脆只知道接近32 GB。 

    您可以通过在日志中查找如下信息来验证您是否在限制之下：

            heap size [1.9gb], compressed ordinary object pointers [true]
  * 甚至更好地尽量保持低于零压缩oops的门槛; 确切上限不清楚，但大多数系统上设置26GB是安全的，但在某些系统上可能设置到30GB。 您可以使用JVM选项“-XX：+ UnlockDiagnosticVMOptions -XX：+ PrintCompressedOopsMode”启动Elasticsearch，然后查找如下日志输出：

            heap address: 0x000000011be00000, size: 27648 MB, zero based Compressed Oops
  显示基于零的压缩oops被启用是如下输出

             heap address: 0x0000000118400000, size: 28672 MB, Compressed Oops with base: 0x00000001183ff000


下面是`jvm.options`文件的例子
Here are examples of how to set the heap size via the jvm.options file:
```sh
-Xms2g  # 最小堆大小为2G
-Xmx2g  # 最大堆大小为2G
```
也可以通过环境变量设置堆大小。 这可以通过在`jvm.options`文件中注释掉`Xms`和`Xmx`设置并通过`ES_JAVA_OPTS`设置这些值来完成： 
```sh
ES_JAVA_OPTS="-Xms2g -Xmx2g" ./bin/elasticsearch 
ES_JAVA_OPTS="-Xms4000m -Xmx4000m" ./bin/elasticsearch 
``` 
  
![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

为[Windows服务](windows.html#windows-service) 配置堆大小不同于上述内容。最初为Windows服务的值可以像上面那样配置，但在安装服务之后会有所不同。 有关更多详细信息，请参阅[Windows服务文档](windows.html#windows-service) 。
