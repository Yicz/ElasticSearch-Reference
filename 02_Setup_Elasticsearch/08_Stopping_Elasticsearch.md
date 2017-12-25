## 关闭ES Stopping Elasticsearch

Elasticsearch的有序关闭确保Elasticsearch有机会清理并关闭使用的资源。 例如，有序关闭的节点将从集群中删除节点信息，同步超时日志到磁盘，并执行其他相关的清理活动。 您可以通过正确的方式来停止Elasticsearch来帮助确保其有序关闭。

如果您将Elasticsearch作为服务运行，则可以通过安装提供的服务管理功能来停止Elasticsearch。

如果您直接运行Elasticsearch，则可以通过在控制台中运行Elasticsearch界面使用`control-C`进行停止或通过在POSIX系统上向Elasticsearch进程发送SIGTERM来停止Elasticsearch。 您可以通过各种工具（例如`ps`或`jps`）获得PID以发送信号：
```sh    
jps | grep Elasticsearch
# echo 14542 Elasticsearch
```
从ES的启动日志中查找PID:
    
    [2016-07-07 12:26:18,908][INFO ][node                     ] [I8hydUG] version[5.0.0-alpha4], pid[15399], build[3f5b994/2016-06-27T16:23:46.861Z], OS[Mac OS X/10.11.5/x86_64], JVM[Oracle Corporation/Java HotSpot(TM) 64-Bit Server VM/1.8.0_92/25.92-b14]

或者在启动的时候，把PID写到一个指定的路径文件中（命令参数`-p <path>`）：

```sh    
    $ ./bin/elasticsearch -p /tmp/elasticsearch-pid -d
    $ cat /tmp/elasticsearch-pid && echo
    15516
    $ kill -SIGTERM 15516
```

### 致命错误导致的停止 Stopping on Fatal Errors

在Elasticsearch虚拟机的生命周期中，可能会出现某些致使虚拟机处于可疑状态的致命错误。 这种致命错误包括内存不足错误，虚拟机中的内部错误以及严重的I/O错误。

当Elasticsearch检测到虚拟机遇到这样的致命错误时，Elasticsearch将尝试记录错误，然后暂停虚拟机。当Elasticsearch发起这样的关闭时，它不会像上面描述的那样按顺序关闭。Elasticsearch进程也将返回一个特殊的状态码，指明错误的性质：

JVM internal error | 128     
:---:|:---:    
内存溢出 Out of memory error | 127     
栈溢出 Stack overflow error | 126     
未知虚拟机错误 Unknown virtual machine error | 125     
序列I/O错误 Serious I/O error | 124     
未知致命错误 Unknown fatal error | 1 
