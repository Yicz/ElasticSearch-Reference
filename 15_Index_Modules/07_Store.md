## Store

The store module allows you to control how index data is stored and accessed on disk.

### File system storage types

There are different file system implementations or _storage types_. By default, elasticsearch will pick the best implementation based on the operating environment.

This can be overridden for all indices by adding this to the `config/elasticsearch.yml` file:
    
    
    index.store.type: niofs

It is a _static_ setting that can be set on a per-index basis at index creation time:
    
    
    PUT /my_index
    {
      "settings": {
        "index.store.type": "niofs"
      }
    }

![Warning](images/icons/warning.png)

This is an expert-only setting and may be removed in the future 

The following divs lists all the different storage types supported.

`fs`
     Default file system implementation. This will pick the best implementation depending on the operating environment: `simplefs` on Windows 32bit, `niofs` on other 32bit systems and `mmapfs` on 64bit systems. 
`simplefs`
     The Simple FS type is a straightforward implementation of file system storage (maps to Lucene `SimpleFsDirectory`) using a random access file. This implementation has poor concurrent performance (multiple threads will bottleneck). It is usually better to use the `niofs` when you need index persistence. 
`niofs`
     The NIO FS type stores the shard index on the file system (maps to Lucene `NIOFSDirectory`) using NIO. It allows multiple threads to read from the same file concurrently. It is not recommended on Windows because of a bug in the SUN Java implementation. 
`mmapfs`
     The MMap FS type stores the shard index on the file system (maps to Lucene `MMapDirectory`) by mapping a file into memory (mmap). Memory mapping uses up a portion of the virtual memory address space in your process equal to the size of the file being mapped. Before using this class, be sure you have allowed plenty of [virtual address space](vm-max-map-count.html). 
`default_fs` [5.0.0] Deprecated in 5.0.0. The `default_fs` store type is deprecated - use `fs` instead 
     The `default` type is deprecated and is aliased to `fs` for backward compatibility. 
