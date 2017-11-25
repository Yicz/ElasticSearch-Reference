## Maximum map count check

Continuing from the previous [point](max-size-virtual-memory-check.html "Maximum size virtual memory check"), to use `mmap` effectively, Elasticsearch also requires the ability to create many memory-mapped areas. The maximum map count check checks that the kernel allows a process to have at least 262,144 memory-mapped areas and is enforced on Linux only. To pass the maximum map count check, you must configure `vm.max_map_count` via `sysctl` to be at least `262144`.
