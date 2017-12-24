## 虚拟内存 Virtual memory

ES默认使用[`mmapfs / niofs`](index-modules-store.html#default_fs)目录来存储它的索引。操作系统默认mmap计数的限制可能太低，这可能会导致内存不足异常。

在Linux上，可以通过以`root`运行以下命令来增加mmap计数的大小：
    
    sysctl -w vm.max_map_count=262144
进行永久的变更，可以修改`/etc/sysctl.conf`文件中`vm.max_map_count`的大小。
To set this value permanently, update the `vm.max_map_count` setting in `/etc/sysctl.conf`. 要在重启系统后进行验证，使用验证命令为`sysctl vm.max_map_count`。

RPM和Debian软件包会自动配置这个设置。 不需要进一步的配置。
