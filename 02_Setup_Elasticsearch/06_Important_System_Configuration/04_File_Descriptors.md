## 文件描述符 File Descriptors

![Note](https://www.elastic.co/guide/en/elasticsearch/reference/current/images/icons/note.png)

这只适用于Linux和macOS，如果在Windows上运行Elasticsearch，可以放心地忽略它。 在Windows上，JVM使用[API](https://msdn.microsoft.com/en-us/library/windows/desktop/aa363858v=vs.85.aspx)仅受可用资源的限制。


Elasticsearch使用了大量的文件描述符或文件句柄。 用完文件描述符可能是灾难性的，并且很可能导致数据丢失。 确保将运行Elasticsearch的用户的打开文件描述符的数量限制增加到65,536或更高。


使用 `.zip`或`.tar.gz` 包安装的方式, 可以使用rooty启用执行[`ulimit -n 65536`](setting-system-settings.html#ulimit) 配置打开文件数量为`65535`, 或在[`/etc/security/limits.conf`](setting-system-settings.html#limits.conf)配置`nofile` 为 `65536`

使用`RPM`或`deb`包安装的方式已经默认配置了打开的文件描述符为`65536`不需要进行其他的配置。

你可以[_Nodes Stats_](cluster-nodes-stats.html) API来检查配置的`max_file_descriptors`大小：
    
    GET _nodes/stats/process?filter_path=**.max_file_descriptors
