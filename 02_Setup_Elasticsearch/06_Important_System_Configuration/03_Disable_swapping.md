## 禁用交换 Disable swapping

大多数操作系统尝试尽可能多地为文件系统缓存使用内存，并急切地换出未使用的应用程序内存。 这可能会导致部分JVM堆或甚至其可执行页被换出到磁盘。

交换的性能非常差，节点稳定性差，不惜一切代价避免使用交换（swapping）。 它可能导致垃圾回收持续**分钟**而不是毫秒，并且可能导致节点响应缓慢甚至与集群断开连接。 在弹性分布式系统中，让操作系统杀死节点更为有效。

有三种方法禁用交换。 首选的选项是完全禁用交换。 如果这不使用这个选项，可以使用最小化swappiness与内存锁定（memory_lock）这两种方式，但这依赖于你的系统是否支持。

### 完全禁用交换 Disable all swap files

通常Elasticsearch是在一台服务器上运行的唯一服务，其内存使用情况由JVM选项控制。 应该不需要启用交换。

在Linux系统上，您可以运行以下命令临时禁用交换：
    
    sudo swapoff -a
要永久禁用它，你将需要编辑`/ etc / fstab`文件并注释掉包含“swap”这个词的所有行。

在Windows上，通过“系统属性→高级→性能→高级→虚拟内存”完全禁用页面文件，可以实现相等的效果。

### 配置尽可能少交换 `swappiness`

Linux系统上的另一个选项是确保sysctl值`vm.swappiness`被设置为`1`。这减少了内核交换的倾向，在正常情况下不应该导致交换，同时仍然允许整个系统在紧急情况下交换。

### 启用内存锁 `bootstrap.memory_lock`

另一个选择是在Linux/Unix系统上使用[mlockall](http://opengroup.org/onlinepubs/007908799/xsh/mlockall.html)，或在windos上使用[VirtualLock](https://msdn.microsoft.com/en-us/library/windows/desktop/aa366895%28v=vs.85%29.aspx)，试图将进程地址空间锁定到RAM中，防止任何ES内存被换出。 这可以通过配置`config/elasticsearch.yml`文件来完成：
    
    bootstrap.memory_lock: true

![Warning](images/icons/warning.png)

`mlockall`可能会导致JVM或shell会话退出，如果它试图分配超出可用的内存！

启动Elasticsearch之后，通过检查这个请求的输出中的`mlockall`的值可以看到这个设置是否被成功应用：
    
    GET _nodes?filter_path=**.mlockall

如果你看到`mlockall`是`false`，那么这意味着`mlockall`请求失败。 您还将在日志中看到更多信息，并带有“无法锁定JVM内存`Unable to lock JVM Memory`”的信息。

在Linux / Unix系统上，最可能的原因是运行Elasticsearch的用户没有锁定内存的权限。 这可以授予权限如下：

`.zip` 或 `.tar.gz`安装方式

    使用root用户设置[`ulimit -l unlimited`](setting-system-settings.html#ulimit) , 或者在[`/etc/security/limits.conf`](setting-system-settings.html#limits.conf)文件设置`memlock`为`unlimited` 
`RPM` 或 `Debian` 安装方式

    在[系统配置文件](setting-system-settings.html#sysconfig) (或使用`systemd`的查看下面的选项)配置`MAX_LOCKED_MEMORY`为`unlimited`
使用`systemd`的系统

    在[systemd 配置](setting-system-settings.html#systemd)配置 `LimitMEMLOCK` 为 `infinity`

`mlockall`可能会失败的另一个可能的原因是临时目录（通常为`/tmp`使用`noexec`选项挂载。这可以通过使用`ES_JAVA_OPTS`环境变量指定一个新的临时目录来解决：

```sh
export ES_JAVA_OPTS="$ES_JAVA_OPTS -Djava.io.tmpdir=/path/to/temp/dir"
./bin/elasticsearch
```

或者在jvm.options配置文件中设置这个JVM标签。
