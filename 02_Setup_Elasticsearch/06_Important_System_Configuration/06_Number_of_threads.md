## 线程数量 Number of threads

Elasticsearch为不同类型的操作使用了一些线程池。 在需要的时候能够创建新的线程是非常重要的。 确保Elasticsearch用户可以创建的线程数至少为2048。

可以使用`root`用户运行 [`ulimit -u 2048`](setting-system-settings.html#ulimit) 进行设置，或者在[`/etc/security/limits.conf`](setting-system-settings.html#limits.conf)文件中配置 `nproc`为`2048`。
