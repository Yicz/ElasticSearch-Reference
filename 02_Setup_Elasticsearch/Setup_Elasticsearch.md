# 配置Elasicsearch

本章节的内容包括如下几个环节：

* 下载
* 安装
* 启动
* 配置

## 支持的平台
正式支持的操作系统和JVM的列表可在此处获得：[查看支持列表](https://www.elastic.co/support/matrix)。 Elasticsearch在列出的平台上进行了测试，但它也可能在其他平台上工作。

## java 版本
Elasticsearch是使用Java构建的，并且至少需要Java 8才能运行。 只有Oracle的Java和OpenJDK被支持。 所有Elasticsearch节点和客户端都应该使用相同的JVM版本。

我们建议安装Java版本1.8.0_131或更高版本。 如果使用已知不支持的Java版本，Elasticsearch将拒绝启动。

Elasticsearch将使用的Java版本可以通过设置JAVA_HOME环境变量进行配置。