## 堆栈大小检查 Heap size check

如果JVM启动的时候，初始化和最大堆栈大小不一致，可能会因为堆栈大小的扩容而导致JVM暂停。为了避免这个问题，最好的方式是配置JVM的初始化大小和最大的大小一致。另外，如果启用了[`bootstrap.memory_lock`](important-settings.html#bootstrap.memory_lock)，JVM将会在启动的时候锁住堆内存的大小。因此如果大小不一致，
如果初始堆大小不等于最大堆大小，则在调整大小后，将不会出现所有JVM堆都锁定在内存中的情况。 要通过堆大小检查，您必须配置[heap size](heap-size.html).配置的文件是jvm.options

个人粘一份默认的elasticsearch.yaml

    -Xms2g  初始化堆
    -Xmx2g  最大堆
    -XX:+UseConcMarkSweepGC
    -XX:CMSInitiatingOccupancyFraction=75
    -XX:+UseCMSInitiatingOccupancyOnly
    -XX:+AlwaysPreTouch
    -server
    -Xss1m
    -Djava.awt.headless=true
    -Dfile.encoding=UTF-8
    -Djna.nosys=true
    -Djdk.io.permissionsUseCanonicalPath=true
    -Dio.netty.noUnsafe=true
    -Dio.netty.noKeySetOptimization=true
    -Dio.netty.recycler.maxCapacityPerThread=0
    -Dlog4j.shutdownHookEnabled=false
    -Dlog4j2.disable.jmx=true
    -Dlog4j.skipJansi=true
    -XX:+HeapDumpOnOutOfMemoryError
