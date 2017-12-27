# ES的配置

本章节包含如下的内容：

  * 下载
  * 安装 
  * 启动 
  * 配置



## 支持的平台
[支持列表](/support/matrix)中列出的平台，ES都测试过使用过。但不限于这些平台，还要可能在其他没有测试过的平台。

## Java (JVM) 版本

ES是使用java语言开发的，至少需要[java 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html)的运行环境，目录ES只支持Oracle和OpenJDK.ES集群中的节点应该都使用一致的JAVA运行环境。


我们推荐使用**1.8.0_131以上**的java版本.ES会拒绝启动，如果使用了一个不运行的JAVA版本。

ES使用的是`JAVA_HOME`的环境变量

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)
ES默认设置的是使用64位的服务器版的jvms,如果你想将他运行在32位的JVM上，你必须在[`jvm.options`]中移除`-server`并重新配置线程栈（thread stack）的大小，从`-Xss1m`到`-Xss320k`
