## 最大内存映射计数器检查 Maximum map count check

继续上一个[point](max-size-virtual-memory-check.html“最大容量虚拟存储器检查”)，为了有效地使用mmap，Elasticsearch也需要能够创建许多内存映射区域。 最大映射计数检查检查内核是否允许进程拥有至少262,144个内存映射区域，并仅在Linux上执行。 要通过最大映射计数检查，必须通过“sysctl”配置`vm.max_map_count`至少为`262144`。
