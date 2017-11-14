# 暂停Elasticsearch

Elasticsearch的有序关闭确保Elasticsearch有机会清理并关闭未解决的资源。 例如，有序关闭的节点将从集群中删除自身，同步超时日志到磁盘，并执行其他相关的清理活动。 您可以通过正确停止Elasticsearch来帮助确保有序关闭。

如果您将Elasticsearch作为服务运行，则可以通过安装提供的服务管理功能来停止Elasticsearch。

如果您直接运行Elasticsearch，则可以通过发送control-C来停止Elasticsearch，如果您在控制台中运行Elasticsearch，或者通过将SIGTERM发送到POSIX系统上的Elasticsearch进程。 您可以通过各种工具（例如ps或jps）获取PID以发送信号：

```sh
jps | grep Elasticsearch
14542 Elasticsearch
```

从Elasticsearch启动日志获取：

```sh
[2016-07-07 12:26:18,908][INFO ][node                     ] [I8hydUG] version[5.0.0-alpha4], pid[15399], build[3f5b994/2016-06-27T16:23:46.861Z], OS[Mac OS X/10.11.5/x86_64], JVM[Oracle Corporation/Java HotSpot(TM) 64-Bit Server VM/1.8.0_92/25.92-b14]
```

或者通过指定启动时写入PID文件的位置（-p <path>）：

```sh
./bin/elasticsearch -p /tmp/elasticsearch-pid -d
cat /tmp/elasticsearch-pid && echo
15516
kill -SIGTERM 15516
```

## 致命错误导致停止
Elasticsearch虚拟机的生命期间,可能出现某些致命错误,把虚拟机处于可疑状态。这样的致命错误包括内存错误,虚拟机内部错误,严重的I / O错误。

当Elasticsearch检测到虚拟机已经遇到这样一个致命错误Elasticsearch将尝试记录错误,然后将停止虚拟机。当Elasticsearch发起这样一个关闭,它没有经过有序关闭如上所述。Elasticsearch处理也将返回一个特殊的状态代码（status）指示错误的本质。

|致命错误|状态|
|:---:|:---:|
|JVM internal error|128|
|Out of memory error|127|
|Stack overflow error|126|
|Unknown virtual machine error|125|
|Serious I/O error|124|
|Unknown fatal error|1|