## 相关的文件系统变更 Filesystem related changes

Only a subset of index files were open with `mmap` on Elasticsearch 2.x. As of Elasticsearch 5.0, all index files will be open with `mmap` on 64-bit systems. While this may increase the amount of virtual memory used by Elasticsearch, there is nothing to worry about since this is only address space consumption and the actual memory usage of Elasticsearch will stay similar to what it was in 2.x. See <http://blog.thetaphi.de/2012/07/use-lucenes-mmapdirectory-on-64bit.html> for more information.
