## Maximum size virtual memory check

Elasticsearch和Lucene使用mmap来将索引的一部分映射到Elasticsearch地址空间。 这样可以将某些索引数据从JVM堆中删除，但在内存中可以快速访问。 为了有效，Elasticsearch应该有无限的地址空间。 最大大小的虚拟内存检查强制Elasticsearch进程具有无限的地址空间，并且仅在Linux上执行。 要通过最大容量虚拟内存检查，您必须配置您的系统以允许Elasticsearch进程拥有无限制的地址空间。 这可以通过`/ etc / security / limits.conf`完成，使用`as`设置为'unlimited'（注意，你可能还需要增加`root`用户的限制）。


