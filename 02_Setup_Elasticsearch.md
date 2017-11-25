# Setup Elasticsearch

This div includes information on how to setup Elasticsearch and get it running, including:

  * Downloading 
  * Installing 
  * Starting 
  * Configuring 



## Supported platforms

The matrix of officially supported operating systems and JVMs is available here: [Support Matrix](/support/matrix). Elasticsearch is tested on the listed platforms, but it is possible that it will work on other platforms too.

## Java (JVM) Version

Elasticsearch is built using Java, and requires at least [Java 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html) in order to run. Only Oracle’s Java and the OpenJDK are supported. The same JVM version should be used on all Elasticsearch nodes and clients.

We recommend installing Java version **1.8.0_131 or later**. Elasticsearch will refuse to start if a known-bad version of Java is used.

The version of Java that Elasticsearch will use can be configured by setting the `JAVA_HOME` environment variable.

![Note](images/icons/note.png)

Elasticsearch ships with default configuration for running Elasticsearch on 64-bit server JVMs. If you are using a 32-bit client JVM, you must remove `-server` from [jvm.options](setting-system-settings.html#jvm-options "Setting JVM options") and if you are using any 32-bit JVM you should reconfigure the thread stack size from `-Xss1m` to `-Xss320k`.
