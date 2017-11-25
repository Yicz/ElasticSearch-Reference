## Important System Configuration

Ideally, Elasticsearch should run alone on a server and use all of the resources available to it. In order to do so, you need to configure your operating system to allow the user running Elasticsearch to access more resources than allowed by default.

The following settings **must** be addressed before going to production:

  * [Set JVM heap size](heap-size.html "Set JVM heap size via jvm.options")
  * [Disable swapping](setup-configuration-memory.html "Disable swapping")
  * [Increase file descriptors](file-descriptors.html "File Descriptors")
  * [Ensure sufficient virtual memory](vm-max-map-count.html "Virtual memory")
  * [Ensure sufficient threads](max-number-of-threads.html "Number of threads")



### Development mode vs production mode

By default, Elasticsearch assumes that you are working in development mode. If any of the above settings are not configured correctly, a warning will be written to the log file, but you will be able to start and run your Elasticsearch node.

As soon as you configure a network setting like `network.host`, Elasticsearch assumes that you are moving to production and will upgrade the above warnings to exceptions. These exceptions will prevent your Elasticsearch node from starting. This is an important safety measure to ensure that you will not lose data because of a malconfigured server.
