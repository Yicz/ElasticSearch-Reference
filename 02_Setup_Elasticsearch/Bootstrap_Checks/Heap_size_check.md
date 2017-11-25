# 堆栈检查
如果JVM以不等的初始和最大堆设置启动，则在系统使用过程中可能会因为JVM堆的大小调整而容易中断。 为了避免这些调整大小的暂停，最好使用初始堆大小等于最大堆大小的JVM来启动。 此外，如果启用[bootstrap.memory_lock](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/important-settings.html#bootstrap.memory_lock)，则JVM将在启动时锁定堆的初始大小。 如果初始堆大小不等于最大堆大小，则在调整大小后，将不会出现所有JVM堆都锁定在内存中的情况。 要通过堆大小检查，您必须配[置堆大小](https://www.elastic.co/guide/en/elasticsearch/reference/5.4/heap-size.html)。